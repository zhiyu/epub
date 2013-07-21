//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CacheHelper.h"
#import "EncryptHelper.h"

@implementation CacheHelper

+ (void) setObject:(NSData *) data forKey:(NSString *) key withExpires:(int) expires{
	NSDate *dt = [NSDate date];
	double now = [dt timeIntervalSince1970];
    NSMutableString *expiresString = [[NSMutableString alloc] init];
	NSData *dataExpires = [[expiresString stringByAppendingFormat:@"%f",now+expires] dataUsingEncoding:NSUTF8StringEncoding];
	[expiresString release];
	[dataExpires writeToFile:[[self getTempPath:key] stringByAppendingFormat:@"%@",@".expires"] atomically:NO];
    [data writeToFile:[self getTempPath:key] atomically:NO];
    //NSLog(@"cache:%@",[self getTempPath:key]);
}

+ (NSData *) get:(NSString *) key{
	if(![self fileExists:[self getTempPath:key]] || [self isExpired:[self getTempPath:key]]){
		//NSLog(@"no cache:%@",[self getTempPath:key]);
	    return nil;
	}
	
    NSData *data = [NSData dataWithContentsOfFile:[self getTempPath:key]];
	return data;
}

+ (void) clear{
    
}

+ (NSString *)getTempPath:(NSString*)key{
	NSString *tempPath = NSTemporaryDirectory();
	return [tempPath stringByAppendingPathComponent:[EncryptHelper md5:key]];
}

+ (BOOL)fileExists:(NSString *)filepath{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:filepath];
}

+ (BOOL)isExpired:(NSString *) key{
	NSData *data = [NSData dataWithContentsOfFile:[key stringByAppendingFormat:@"%@",@".expires"]];
	NSString *expires = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
	double exp = [expires doubleValue];
	[expires release];
	NSDate *dt = [NSDate date];
	double value = [dt timeIntervalSince1970];
	
	if(exp > value){
		return NO;
	}
	return YES;
}

@end