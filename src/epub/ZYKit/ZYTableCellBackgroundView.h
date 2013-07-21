//
//  ZYUITableViewCell.h
//  scaffold
//
//  Created by zzy on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYTableCellBackgroundView : UIView

@property (nonatomic, retain) UIColor *bgColor;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic) int pos;

- (id)initWithFrame:(CGRect) frame pos:(int)position;

@end
