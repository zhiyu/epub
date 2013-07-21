//
//  ZYPageControl.m
//  scaffold
//
//  Created by zhiyu zheng on 12-9-4.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import "ZYPageControl.h"

@implementation ZYPageControl

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount{    
    return  CGSizeMake(pageCount*5, 20);
}

@end
