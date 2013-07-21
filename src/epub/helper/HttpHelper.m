//
//  HttpHelper.m
//  scaffold
//
//  Created by zhiyu zheng on 12-5-23.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import "HttpHelper.h"
#import "ASIHTTPRequest.h"
#import "ASIWebPageRequest.h"
#import "ASIDownloadCache.h"
#import "ASIFormDataRequest.h"

@implementation HttpHelper

+(NSString *)getSignature:(NSMutableDictionary *) params {

//    NSString *uuid = [params valueForKey:@"uuid"];
    NSString *udid = @"74E1B615A9C6";
    
//    [params removeObjectForKey:@"uuid"];
    [params removeObjectForKey:@"udid"];
    
    NSArray *myKeys = [params allKeys];
    NSArray *sortKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableString *aParamsString = [[[NSMutableString alloc] init] autorelease];
    
    for (int i=0; i<[sortKeys count]; i++) {
        
        NSString *key = [sortKeys objectAtIndex:i];
        NSString *value = [params valueForKey:key];
        
        [aParamsString appendFormat:@"%@%@", key, value];
    }
    
    [aParamsString appendFormat:@"%@%@", @"udid", udid];
    
    NSLog(@"aParamsString:%@", aParamsString);
    return aParamsString;
}

+(void)getSigned:(NSString *)url params:(NSMutableDictionary *)params delegate:(id)delegate success:(SEL)success error:(SEL)error{
    NSMutableString *paramsString = [[NSMutableString alloc] initWithFormat:@"%@", url];
    
    [params retain];
    
    ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];  
    for(NSString *key in params){
        
        if([paramsString hasSuffix:@"?"])
        {
            [paramsString appendFormat:@"%@=%@",key,[formDataRequest encodeURL:[params objectForKey:key]]];
        }
        else
        {
            [paramsString appendFormat:@"&%@=%@",key,[formDataRequest encodeURL:[params objectForKey:key]]];
        }
    }
    
    NSString *signature = [[HttpHelper getSignature:params] retain];
    [paramsString appendFormat:@"&%@=%@", @"signature", [EncryptHelper md5:signature]];
    [signature release];
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"%@", paramsString];
    NSURL *reqUrl = [[NSURL alloc] initWithString:requestString];
    
    NSLog(@"url:%@",requestString);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:reqUrl];
    [reqUrl release];
    
    [request setTimeOutSeconds:30];
    [request setUserInfo:params];
    [request setDelegate:delegate];
    [request setDidFinishSelector:success];
    [request setDidFailSelector:error];
    [request startAsynchronous];   
    
    [params release];
    [paramsString release];
    [requestString release];
}

+(void)get:(NSString *)url params:(NSMutableDictionary *)params delegate:(id)delegate success:(SEL)success error:(SEL)error{
    NSMutableString *paramsString = [[NSMutableString alloc] init];
    
    [params retain];
    for(NSString *key in params){
        [paramsString appendFormat:@"&%@=%@",key,[params objectForKey:key]];
    }
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"%@%@",url,paramsString];
    NSURL *reqUrl = [[NSURL alloc] initWithString:requestString];
    
    NSLog(@"url:%@",requestString);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:reqUrl];
    [reqUrl release];
    
    [request setTimeOutSeconds:10];
    [request setUserInfo:params];
    [request setDelegate:delegate];
    [request setDidFinishSelector:success];
    [request setDidFailSelector:error];
    [request startAsynchronous];   
    
    [params release];
    [paramsString release];
    [requestString release];
}

+(void)getWebPage:(NSString *)url params:(NSMutableDictionary *)params delegate:(id)delegate success:(SEL)success error:(SEL)error{
    NSMutableString *paramsString = [[NSMutableString alloc] init];
    
    [params retain];
    for(NSString *key in params){
        [paramsString appendFormat:@"&%@=%@",key,[params objectForKey:key]];
    }
    
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"%@%@",url,paramsString];
    NSURL *reqUrl = [[NSURL alloc] initWithString:requestString];
    
    NSLog(@"url:%@",requestString);
    ASIWebPageRequest *request = [[ASIWebPageRequest alloc] initWithURL:reqUrl];
    [reqUrl release];
    
    request.delegate = self;
    [request setUrlReplacementMode:ASIReplaceExternalResourcesWithData];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
    [request setTimeOutSeconds:10];
    [request setShouldAttemptPersistentConnection:NO];
    [request setUserInfo:params];
    [request setDelegate:delegate];
    [request setDidFinishSelector:success];
    [request setDidFailSelector:error];
    [request startAsynchronous];  
    
    [params release];
    [paramsString release];
    [requestString release];
}

+(void)getWebPageSigned:(NSString *)url params:(NSMutableDictionary *)params delegate:(id)delegate success:(SEL)success error:(SEL)error{
    NSMutableString *paramsString = [[NSMutableString alloc] initWithFormat:@"%@", url];
    
    [params retain];
    for(NSString *key in params){
        
        if([paramsString hasSuffix:@"?"])
        {
            [paramsString appendFormat:@"%@=%@",key,[params objectForKey:key]];
        }
        else
        {
            [paramsString appendFormat:@"&%@=%@",key,[params objectForKey:key]];
        }
    }
    
    NSString *signature = [[HttpHelper getSignature:params] retain];
    [paramsString appendFormat:@"&%@=%@", @"signature", [EncryptHelper md5:signature]];
    [signature release];
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"%@", paramsString];
    
    NSURL *reqUrl = [[NSURL alloc] initWithString:requestString];
    
    NSLog(@"url:%@",requestString);
    ASIWebPageRequest *request = [[ASIWebPageRequest alloc] initWithURL:reqUrl];
    [reqUrl release];
    
    request.delegate = self;
    [request setUrlReplacementMode:ASIReplaceExternalResourcesWithData];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
    [request setTimeOutSeconds:10];
    [request setShouldAttemptPersistentConnection:NO];
    [request setUserInfo:params];
    [request setDelegate:delegate];
    [request setDidFinishSelector:success];
    [request setDidFailSelector:error];
    [request startAsynchronous];  
    
    [params release];
    [paramsString release];
    [requestString release];
}

@end
