//
//  HttpHelper.h
//  scaffold
//
//  Created by zhiyu zheng on 12-5-23.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EncryptHelper.h"

@interface HttpHelper : NSObject

+(void)getSigned:(NSString *)url params:(NSMutableDictionary *)params delegate:(id)delegate success:(SEL)success error:(SEL)error;

+(void)get:(NSString *)url params:(NSMutableDictionary *)params delegate:(id)delegate success:(SEL)success error:(SEL)error;

+(void)getWebPage:(NSString *)url params:(NSMutableDictionary *)params delegate:(id)delegate success:(SEL)success error:(SEL)error;

+(void)getWebPageSigned:(NSString *)url params:(NSMutableDictionary *)params delegate:(id)delegate success:(SEL)success error:(SEL)error;

@end
