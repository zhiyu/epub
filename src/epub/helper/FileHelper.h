//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+(void)appendData:(NSObject *)data toFile:(NSString *)file;
+(void)prependData:(NSObject *)data toFile:(NSString *)file;
+(NSMutableArray *)getDataFromFile:(NSString *)file;
+(void)deleteData:(NSObject *)data ofFile:(NSString *)file;
+(void)empty:(NSString *)file;

@end
