//
//  ZYBadgeView.m
//  scaffold
//
//  Created by zhiyu zheng on 12-8-3.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import "ZYBadgeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZYBadgeView

@synthesize label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity =0.6;
        
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.masksToBounds = YES;
        
        // Initialization code
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor =[UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setText:(NSString *)text{
    UIFont *font = [UIFont fontWithName:@"Times New Roman" size:10];
    self.label.font = font;
    self.label.text = text;
    CGSize constraintSize = CGSizeMake(MAXFLOAT, 10);
    
    CGSize contentSize = [text sizeWithFont:font constrainedToSize:constraintSize];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,contentSize.width+6,contentSize.height+1);
    self.label.frame =  CGRectMake(3, 1,contentSize.width,contentSize.height);
}

@end
