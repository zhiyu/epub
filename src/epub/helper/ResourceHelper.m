//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResourceHelper.h"

@implementation ResourceHelper

+(UIImage *) loadImageByTheme:(NSString *) name{    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        name = [[NSString alloc] initWithFormat:@"%@_pad",name];
    }
    
    NSString *file = [[NSString alloc] initWithFormat:@"themes/%@/%@",[ResourceHelper  getUserDefaults:@"theme"],name];
    
	NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"png"];
	return [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
}

+(UIImage *) loadImage:(NSString *) name{
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
	return [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
}

+(NSObject *) getUserDefaults:(NSString *) name{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:name];
}

+(void) setUserDefaults:(NSObject *) defaults forKey:(NSString *) key{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:defaults forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
