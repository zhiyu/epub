//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageHelper : NSObject

+ (void)show:(id)controller message:(NSString *) message detail:(NSString*)detail delay:(int)delay;
+ (void)load:(id)controller message:(NSString *) message detail:(NSString*)detail view:(UIView*) view delay:(int) delay;

+ (void)hide;
+ (void)reset;

@end
