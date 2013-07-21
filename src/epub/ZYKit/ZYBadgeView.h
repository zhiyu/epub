//
//  ZYBadgeView.h
//  scaffold
//
//  Created by zhiyu zheng on 12-8-3.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYBadgeView : UIView

@property(nonatomic,retain) UILabel *label;

-(void)setText:(NSString *)text;
@end
