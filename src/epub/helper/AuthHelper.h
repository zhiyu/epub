//
//  AuthHelper.h
//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

@interface AuthHelper : NSObject {

}

+(NSMutableDictionary *)login:(NSString *) path withUserName:(NSString *)userName password:(NSString *)password;
+(Boolean)isLogin;

@end
