//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EncryptHelper : NSObject {

}

+(NSString *) md5:(NSString *) str;
+(NSString *)fileMd5:(NSString *) path;

@end
