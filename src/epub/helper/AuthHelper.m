#import "AuthHelper.h"
#import "ASIHTTPRequest.h"
#import "ResourceHelper.h"

@implementation AuthHelper

+(NSMutableDictionary *)login:(NSString *) path withUserName:(NSString *)userName password:(NSString *)password{
	NSURL *url = [[[NSURL alloc] initWithString:[[NSString alloc]initWithFormat:path,userName,password]] autorelease];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	[request setUseCookiePersistence:YES];
	[request startSynchronous];
	NSString *res=[request responseString];
	return [res objectFromJSONString];
}

+(Boolean)isLogin{
    if([ResourceHelper getUserDefaults:@"isLogin"]!=nil){
        return YES;
    }
    return NO;
}

@end
