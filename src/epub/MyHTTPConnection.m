
#import "MyHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "DDNumber.h"
#import "HTTPLogging.h"

#import "MultipartFormDataParser.h"
#import "MultipartMessageHeaderField.h"
#import "HTTPDynamicFileResponse.h"
#import "HTTPFileResponse.h"
#import "HTTPRedirectResponse.h"

#define COCOA_SERVER_INDEX   NSLocalizedString(@"upload_index", nil) 
#define COCOA_SERVER_WEBROOT @"web"

// Log levels : off, error, warn, info, verbose
// Other flags: trace
static const int httpLogLevel = HTTP_LOG_LEVEL_VERBOSE; // | HTTP_LOG_FLAG_TRACE;


/**
 * All we have to do is override appropriate methods in HTTPConnection.
 **/

@implementation MyHTTPConnection

@synthesize storeFile;
@synthesize parser;
@synthesize uploadedFiles;

- (void)dealloc {
    [storeFile release];
	[parser release];
    [uploadedFiles release];
    [super dealloc];
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
	HTTPLogTrace();
	
	return YES;
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path
{
	HTTPLogTrace();
	
	// Inform HTTP server that we expect a body to accompany a POST request
	
	if([method isEqualToString:@"POST"]) {
        // here we need to make sure, boundary is set in header
        NSString* contentType = [request headerField:@"Content-Type"];
        NSUInteger paramsSeparator = [contentType rangeOfString:@";"].location;
        if( NSNotFound == paramsSeparator ) {
            return NO;
        }
        if( paramsSeparator >= contentType.length - 1 ) {
            return NO;
        }
        NSString* type = [contentType substringToIndex:paramsSeparator];
        if( ![type isEqualToString:@"multipart/form-data"] ) {
            // we expect multipart/form-data content type
            return NO;
        }

		// enumerate all params in content-type, and find boundary there
        NSArray* params = [[contentType substringFromIndex:paramsSeparator + 1] componentsSeparatedByString:@";"];
        for( NSString* param in params ) {
            paramsSeparator = [param rangeOfString:@"="].location;
            if( (NSNotFound == paramsSeparator) || paramsSeparator >= param.length - 1 ) {
                continue;
            }
            NSString* paramName = [param substringWithRange:NSMakeRange(1, paramsSeparator-1)];
            NSString* paramValue = [param substringFromIndex:paramsSeparator+1];
            
            if( [paramName isEqualToString: @"boundary"] ) {
                // let's separate the boundary from content-type, to make it more handy to handle
                [request setHeaderField:@"boundary" value:paramValue];
            }
        }
        // check if boundary specified
        if( nil == [request headerField:@"boundary"] )  {
            return NO;
        }
        return YES;
    }
	return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	HTTPLogTrace();

	if ([method isEqualToString:@"POST"]){
        return [[HTTPRedirectResponse alloc] initWithPath:path];
    }else{
        if([path rangeOfString:@"/delFile"].location == 0){
            NSString *realPath = [self filePathForURI:[[[self parseGetParams] objectForKey:@"fileName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] allowDirectory:YES];
            
            NSFileManager *defaultManager = [NSFileManager defaultManager];
            [defaultManager removeItemAtPath:realPath error:nil];
            
            return [[HTTPDataResponse alloc] initWithData:[[[self parseGetParams] objectForKey:@"url"] dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            NSString *realPath = [self filePathForURI:path allowDirectory:YES];
            if([path rangeOfString:@"/res/"].location == 0){
                realPath = [NSString stringWithFormat:@"%@/%@%@",[[NSBundle mainBundle] resourcePath], COCOA_SERVER_WEBROOT, path];
            }
            BOOL isDir = TRUE;
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:realPath isDirectory:&isDir];
            
            if(isExist && isDir){
                NSString *filesStr = [self generateLists:realPath];
                NSString* templatePath = [NSString stringWithFormat:@"%@/%@%@",[[NSBundle mainBundle] resourcePath],COCOA_SERVER_WEBROOT,COCOA_SERVER_INDEX];
                
                NSDictionary* replacementDict = [NSDictionary dictionaryWithObject:filesStr forKey:@"MyFiles"];
                
                return [[HTTPDynamicFileResponse alloc] initWithFilePath:templatePath forConnection:self separator:@"$" replacementDictionary:replacementDict];
            }else{
                return [[HTTPFileResponse alloc] initWithFilePath:realPath forConnection:self];
            }
        }        
	}
	
    return [super httpResponseForMethod:method URI:path];
}

-(NSString *)generateLists:(NSString *)realPath{
    NSArray *files = [self listFiles:realPath];
    NSMutableString* filesStr = [[NSMutableString alloc] init];
    for(NSString *file in files) {
        NSString *path = [self filePathForURI:file allowDirectory:YES];
        BOOL isDir = TRUE;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
        if(isExist && isDir){
            [filesStr appendFormat:@"<tr><td width='20' class='dir'></td><td><a href=\"%@/\"> %@ </a></td><td width='50'><a class=\"btn btn-update\" href=\'javascript:delFile(\"%@\")\'>%@</a></td></tr>",file, file,file,NSLocalizedString(@"delete", nil)];
        }else{
            [filesStr appendFormat:@"<tr><td width='20' class='file'></td><td><a href=\"%@\"> %@ </a></td><td width='50'><a class=\"btn btn-update\" href=\'javascript:delFile(\"%@\")\'>%@</a></td></tr>",file, file,file,NSLocalizedString(@"delete", nil)];
        }
    }
    return [filesStr autorelease];
}

-(NSArray *)listFiles:(NSString *)path{
    return [[[NSFileManager alloc] init] contentsOfDirectoryAtPath:path error:nil];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength
{
	HTTPLogTrace();
	
	// set up mime parser
    NSString* boundary = [request headerField:@"boundary"];
    self.parser = [[MultipartFormDataParser alloc] initWithBoundary:boundary formEncoding:NSUTF8StringEncoding];
    [parser release];
    
    parser.delegate = self;

	self.uploadedFiles = [[NSMutableArray alloc] init];
    [uploadedFiles release];
}

- (void)processBodyData:(NSData *)postDataChunk
{
	HTTPLogTrace();
    // append data to the parser. It will invoke callbacks to let us handle
    // parsed data.
    [parser appendData:postDataChunk];
}


//-----------------------------------------------------------------
#pragma mark multipart form data parser delegate


- (void) processStartOfPartWithHeader:(MultipartMessageHeader*) header {
	// in this sample, we are not interested in parts, other then file parts.
	// check content disposition to find out filename

    MultipartMessageHeaderField* disposition = [header.fields objectForKey:@"Content-Disposition"];
	NSString* filename = [[disposition.params objectForKey:@"filename"] lastPathComponent];
    
    if ( (nil == filename) || [filename isEqualToString: @""] ) {
        // it's either not a file part, or
		// an empty form sent. we won't handle it.
		return;
	}    
	NSString* uploadDirPath = [config documentRoot];

	BOOL isDir = YES;
	if (![[NSFileManager defaultManager]fileExistsAtPath:uploadDirPath isDirectory:&isDir ]) {
		[[NSFileManager defaultManager]createDirectoryAtPath:uploadDirPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
    NSString* filePath = [uploadDirPath stringByAppendingPathComponent: filename];
    HTTPLogVerbose(@"Saving file to %@", filePath);
    if(![[NSFileManager defaultManager] createDirectoryAtPath:uploadDirPath withIntermediateDirectories:true attributes:nil error:nil]) {
        HTTPLogError(@"Could not create directory at path: %@", filePath);
    }
    if(![[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil]) {
        HTTPLogError(@"Could not create file at path: %@", filePath);
    }
    self.storeFile = [NSFileHandle fileHandleForWritingAtPath:filePath];

    [uploadedFiles addObject: [NSString stringWithFormat:@"%@", filename]];
}


- (void) processContent:(NSData*) data WithHeader:(MultipartMessageHeader*) header 
{
	// here we just write the output from parser to the file.
	if( storeFile ) {
		[storeFile writeData:data];
    }
}

- (void) processEndOfPartWithHeader:(MultipartMessageHeader*) header
{
	// as the file part is over, we close the file.
	[storeFile closeFile];
	storeFile = nil;
}

- (void) processPreambleData:(NSData*) data 
{
    // if we are interested in preamble data, we could process it here.

}

- (void) processEpilogueData:(NSData*) data 
{
    // if we are interested in epilogue data, we could process it here.

}

@end
