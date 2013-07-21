//
//  BookLoader.m
//  epub
//
//  Created by zhiyu zheng on 12-6-6.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import "BookLoader.h"

@interface BookLoader()

- (void) parse;

@end

@implementation BookLoader

@synthesize spineArray,filePath,error;

- (id) initWithPath:(NSString*)path{
    if((self=[super init])){
        error = 0;
		self.filePath = path;
		self.spineArray = [[NSMutableArray alloc] init];
        [self.spineArray release];
		[self parse];
	}
	return self;
}

- (void) parse{

}
@end
