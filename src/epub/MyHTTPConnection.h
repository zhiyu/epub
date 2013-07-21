
#import "HTTPConnection.h"

@class MultipartFormDataParser;

@interface MyHTTPConnection : HTTPConnection  {

}

@property(nonatomic, retain) MultipartFormDataParser *parser;
@property(nonatomic, retain) NSFileHandle *storeFile;
@property(nonatomic, retain) NSMutableArray *uploadedFiles;

@end
