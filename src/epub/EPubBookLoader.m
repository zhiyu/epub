#import "EPubBookLoader.h"
#import "ZipArchive.h"
#import "Chapter.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "EncryptHelper.h"
#import "ResourceHelper.h"

@interface EPubBookLoader()
- (void) unzipAndSaveFile;
- (NSString*) applicationDocumentsDirectory;
- (NSString*) parseManifestFile;
- (void) parseOPF:(NSString*)opfPath;

@end

@implementation EPubBookLoader

@synthesize spineArray;

- (void) parse{
	[self unzipAndSaveFile];
	NSString* opfPath = [self parseManifestFile];
    if(opfPath == nil){
        self.error = 1;
        return;
    }
    [self parseOPF:opfPath];
}

- (void)unzipAndSaveFile{
	ZipArchive* za = [[ZipArchive alloc] init];
    if([za UnzipOpenFile:self.filePath]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        NSString *strPath=[NSString stringWithFormat:@"%@/%@/",cacheDirectory,self.filePath];
        
        NSString *md5 = [EncryptHelper fileMd5:self.filePath];
        if(![md5 isEqualToString:(NSString *)[ResourceHelper getUserDefaults:[self.filePath lastPathComponent]]]){
            NSLog(@"unzip...");
            //Delete all the previous files
            NSFileManager *filemanager=[[NSFileManager alloc] init];
            if ([filemanager fileExistsAtPath:strPath]) {
                NSError *error;
                [filemanager removeItemAtPath:strPath error:&error];
            }
            //[filemanager release];
            //start unzip
            BOOL ret = [za UnzipFileTo:strPath overWrite:YES];
            if( NO==ret ){
                // error handler here
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Error while unzipping the epub"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
                [alert show];
                //[alert release];
                alert=nil;
            }
            [za UnzipCloseFile];
            
            [ResourceHelper setUserDefaults:md5 forKey:[self.filePath lastPathComponent]];
        }
	}					
	//[za release];
    NSLog(@"unzip finished");
}

- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString*) parseManifestFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *strPath=[NSString stringWithFormat:@"%@/%@/",cacheDirectory,self.filePath];
    
	NSString* manifestFilePath = [NSString stringWithFormat:@"%@META-INF/container.xml", strPath];
    
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if ([fileManager fileExistsAtPath:manifestFilePath]) {
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:[NSData dataWithContentsOfFile:manifestFilePath] options:0 error:nil];
        NSString *opfPath = [[[[xmlDoc.rootElement elementForName:@"rootfiles"] elementForName:@"rootfile"] attributeForName:@"full-path"] stringValue];
		return [NSString stringWithFormat:@"%@%@", strPath, opfPath];
	} else {
		NSLog(@"ERROR: ePub not Valid");
		return nil;
	}
	//[fileManager release];
}

- (void) parseOPF:(NSString*)opfPath{
    NSLog(@"start parse OPF:%d",(int)[[NSDate date] timeIntervalSince1970]);
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:[NSData dataWithContentsOfFile:opfPath] options:0 error:nil];
    NSArray* itemsArray = [xmlDoc nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    
    if(itemsArray.count == 0){
        itemsArray = [xmlDoc nodesForXPath:@"//item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    }
    
    NSLog(@"finish item:%d",(int)[[NSDate date] timeIntervalSince1970]);
    
    NSString* ncxFileName;
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
	for (DDXMLElement* element in itemsArray) {
            [itemDictionary setObject:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
            if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
                ncxFileName = [[element attributeForName:@"href"] stringValue];
            }
    }
    
    NSLog(@"finish items:%d",(int)[[NSDate date] timeIntervalSince1970]);
    
    int lastSlash = [opfPath rangeOfString:@"/" options:NSBackwardsSearch].location;
	NSString* ebookBasePath = [opfPath substringToIndex:(lastSlash +1)];
    
    DDXMLDocument *ncxToc = [[DDXMLDocument alloc] initWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@%@", ebookBasePath, ncxFileName]] options:0 error:nil];
    
    NSLog(@"finish ncx:%d",(int)[[NSDate date] timeIntervalSince1970]);
    
    //titles
    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray* navPoints = [ncxToc nodesForXPath:@"//ncx:navPoint" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
    if(navPoints.count == 0){
        navPoints = [ncxToc nodesForXPath:@"//navPoint" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
    }
    NSLog(@"%@",[ncxToc stringValue]);
    
    for (DDXMLElement* navPoint in navPoints) {
        DDXMLElement *hrefElement = [navPoint elementForName:@"content"];
        DDXMLElement *titleElement = [[navPoint elementForName:@"navLabel"] elementForName:@"text"];
        NSString* href = [[hrefElement attributeForName:@"src"] stringValue];
        NSString* title = [titleElement stringValue];
        [titleDictionary setValue:title forKey:href];
    }
    
    NSLog(@"finish titles:%d",(int)[[NSDate date] timeIntervalSince1970]);
    
    //chapters
	NSArray* itemRefsArray = [xmlDoc nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    if(itemRefsArray.count == 0){
        itemRefsArray = [xmlDoc nodesForXPath:@"//itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    }

    NSLog(@"finish chapters:%d",(int)[[NSDate date] timeIntervalSince1970]);
    
	NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    int count = 0;

    for (DDXMLElement* element in itemRefsArray) {
        if(![[[[element attributeForName:@"linear"] stringValue] lowercaseString] isEqualToString:@"no"]){
            NSString* href = [itemDictionary objectForKey:[[element attributeForName:@"idref"] stringValue]];
            NSString *title = [titleDictionary objectForKey:href];
            if(title == nil){
                title = href;
            }
            Chapter* tmpChapter = [[Chapter alloc] initWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, href]
                                                          title:title
                                                   chapterIndex:count++];
            [tmpArray addObject:tmpChapter];
            //[tmpChapter release];
        }
	}
    
    NSLog(@"finish spines:%d",(int)[[NSDate date] timeIntervalSince1970]);
    
	self.spineArray = [NSArray arrayWithArray:tmpArray]; 
	
	//[opfFile release];
	//[tmpArray release];
	//[ncxToc release];
	//[itemDictionary release];
	//[titleDictionary release];
    
    NSLog(@"end parse OPF");

}

- (void)dealloc {
    //[spineArray release];
    //[super dealloc];
}

@end
