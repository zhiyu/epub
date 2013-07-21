//
//  ZYUITableViewCell.m
//  scaffold
//
//  Created by zzy on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define ROUND_SIZE 10

#import "ZYTableCellBackgroundView.h"

@implementation ZYTableCellBackgroundView

@synthesize bgColor;
@synthesize borderColor;
@synthesize pos;

- (id)initWithFrame:(CGRect) frame pos:(int)position{
    self = [super initWithFrame:frame];
    self.pos = position;
    self.bgColor = [[UIColor alloc] initWithRed:232/255.f green:232/255.f blue:232/255.f alpha:1];
    self.borderColor = [[UIColor alloc] initWithRed:171/255.f green:171/255.f blue:171/255.f alpha:1];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    
    if (pos == 0) {
        CGContextSetShouldAntialias(c, YES);
        CGContextSetFillColorWithColor(c, self.borderColor.CGColor);
        CGContextBeginPath(c);
        CGContextAddArc(c, ROUND_SIZE, ROUND_SIZE, ROUND_SIZE, M_PI,M_PI*1.5,  0);
        CGContextAddLineToPoint(c, w-ROUND_SIZE, 0);
        CGContextAddArc(c, w-ROUND_SIZE, ROUND_SIZE, ROUND_SIZE,  M_PI*1.5,M_PI*2, 0);
        CGContextAddLineToPoint(c, w, h);
        CGContextAddLineToPoint(c, 0, h);
        CGContextFillPath(c);
        CGContextClosePath(c);
        
        CGContextSetFillColorWithColor(c, self.bgColor.CGColor);
        CGContextBeginPath(c);
        CGContextAddArc(c, ROUND_SIZE, ROUND_SIZE, ROUND_SIZE-1, M_PI,M_PI*1.5,  0);
        CGContextAddLineToPoint(c, w-ROUND_SIZE, 1);
        CGContextAddArc(c, w-ROUND_SIZE, ROUND_SIZE, ROUND_SIZE-1,  M_PI*1.5,M_PI*2, 0);
        CGContextAddLineToPoint(c, w-1, h-1);
        CGContextAddLineToPoint(c, 1, h-1);
        CGContextFillPath(c);
        CGContextClosePath(c);
        return;
    } else if (pos == 1) {
        CGContextSetShouldAntialias(c, YES);
        CGContextBeginPath(c);
        CGContextSetFillColorWithColor(c, self.borderColor.CGColor);
        CGContextAddRect(c, CGRectMake(0, 0, w, h));
        CGContextFillPath(c);
        CGContextClosePath(c);
        
        CGContextBeginPath(c);
        CGContextSetFillColorWithColor(c, self.bgColor.CGColor);
        CGContextAddRect(c, CGRectMake(1, 0, w-2, h-1));
        CGContextFillPath(c);
        CGContextClosePath(c);
        return;
    } else if (pos == 2) {
        CGContextSetShouldAntialias(c, YES);
        CGContextSetFillColorWithColor(c, self.borderColor.CGColor);
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0, 0);
        CGContextAddLineToPoint(c, w, 0);
        CGContextAddLineToPoint(c, w, h-ROUND_SIZE);
        CGContextAddArc(c, w-ROUND_SIZE, h-ROUND_SIZE, ROUND_SIZE,  0,M_PI/2, 0);
        CGContextAddLineToPoint(c, ROUND_SIZE, h);
        CGContextAddArc(c, ROUND_SIZE, h-ROUND_SIZE, ROUND_SIZE, M_PI/2, M_PI, 0);
        CGContextFillPath(c);
        CGContextClosePath(c);
        
        CGContextSetFillColorWithColor(c, self.bgColor.CGColor);
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 1, 0);
        CGContextAddLineToPoint(c, w-1, 0);
        CGContextAddLineToPoint(c, w-1, h-ROUND_SIZE-1);
        CGContextAddArc(c, w-ROUND_SIZE, h-ROUND_SIZE, ROUND_SIZE-1,  0,M_PI/2, 0);
        CGContextAddLineToPoint(c, ROUND_SIZE, h-1);
        CGContextAddArc(c, ROUND_SIZE, h-ROUND_SIZE, ROUND_SIZE-1, M_PI/2, M_PI, 0);
        CGContextFillPath(c);
        CGContextClosePath(c);
        return;
    } else if (pos == 3) 
    {
        CGContextSetShouldAntialias(c, YES);
        CGContextSetFillColorWithColor(c, self.borderColor.CGColor);
        CGContextBeginPath(c);
        CGContextAddArc(c, ROUND_SIZE, ROUND_SIZE, ROUND_SIZE, M_PI,M_PI*1.5,  0);
        CGContextAddLineToPoint(c, w-ROUND_SIZE, 0);
        CGContextAddArc(c, w-ROUND_SIZE, ROUND_SIZE, ROUND_SIZE,  M_PI*1.5,M_PI*2, 0);
        CGContextAddLineToPoint(c, w, h-ROUND_SIZE);
        CGContextAddArc(c, w-ROUND_SIZE, h-ROUND_SIZE, ROUND_SIZE,  0,M_PI/2, 0);
        CGContextAddLineToPoint(c, ROUND_SIZE, h);
        CGContextAddArc(c, ROUND_SIZE, h-ROUND_SIZE, ROUND_SIZE, M_PI/2, M_PI, 0);
        CGContextFillPath(c);
        CGContextClosePath(c);
        
        CGContextSetFillColorWithColor(c, self.bgColor.CGColor);
        CGContextBeginPath(c);
        CGContextAddArc(c, ROUND_SIZE, ROUND_SIZE, ROUND_SIZE-1, M_PI,M_PI*1.5,  0);
        CGContextAddLineToPoint(c, w-ROUND_SIZE, 1);
        CGContextAddArc(c, w-ROUND_SIZE, ROUND_SIZE, ROUND_SIZE-1,  M_PI*1.5,M_PI*2, 0);
        CGContextAddLineToPoint(c, w-1, h-ROUND_SIZE);
        CGContextAddArc(c, w-ROUND_SIZE, h-ROUND_SIZE, ROUND_SIZE-1,  0,M_PI/2, 0);
        CGContextAddLineToPoint(c, ROUND_SIZE, h-1);
        CGContextAddArc(c, ROUND_SIZE, h-ROUND_SIZE, ROUND_SIZE-1, M_PI/2, M_PI, 0);
        CGContextFillPath(c);
        CGContextClosePath(c);
        return;
    } 
} 

@end
