//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

+(void)appendData:(NSObject *)data toFile:(NSString *)file{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0){
		NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:file];
		if(![fileManager fileExistsAtPath:path]){
			NSMutableArray *fileData = [[NSMutableArray alloc] init];
            if([fileData writeToFile:path atomically:YES]){
                
            }

            [fileData release];
		}
        NSMutableArray *fileData = [[NSMutableArray alloc] initWithContentsOfFile:path];
        [fileData addObject:data];
        if([fileData writeToFile:path atomically:YES]){
            
        }
        [fileData release];
	}
}

+(void)prependData:(NSObject *)data toFile:(NSString *)file{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0){
		NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:file];
		if(![fileManager fileExistsAtPath:path]){
			NSMutableArray *fileData = [[NSMutableArray alloc] init];
            if([fileData writeToFile:path atomically:YES]){
                
            }
            [fileData release];
		}
        NSMutableArray *fileData = [[NSMutableArray alloc] initWithContentsOfFile:path];
        if(![fileData containsObject:data]){
            [fileData insertObject:data atIndex:0];
            if([fileData writeToFile:path atomically:YES]){
                
            }
        }    
        [fileData release];
	}
}

+(NSMutableArray *)getDataFromFile:(NSString *)file{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0){
		NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:file];
		if(![fileManager fileExistsAtPath:path]){
			return nil;
		}
        
        NSMutableArray *fileData = [[NSMutableArray alloc] initWithContentsOfFile:path];
        return  fileData;
	}
    
    return nil;
}

+(void)deleteData:(NSObject *)data ofFile:(NSString *)file{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0){
		NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:file];
		if([fileManager fileExistsAtPath:path]){
			NSMutableArray *fileData = [[NSMutableArray alloc] initWithContentsOfFile:path];
            [fileData removeObject:data];
            if([fileData writeToFile:path atomically:YES]){}
            [fileData release];
		}
	}
}

+(void)empty:(NSString *)file{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0){
		NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:file];
		if([fileManager fileExistsAtPath:path]){
			NSMutableArray *fileData = [[NSMutableArray alloc] initWithContentsOfFile:path];
            [fileData removeAllObjects];
            if([fileData writeToFile:path atomically:YES]){}
            [fileData release];
		}
	}
}


@end
