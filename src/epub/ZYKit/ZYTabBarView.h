//
//  TabViewController.h
//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYTabBarDelegate<NSObject>
-(void)itemClicked:(int)index data:(NSDictionary*)item;
@end


@interface ZYTabBarView : UIView

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) id<ZYTabBarDelegate> delegate;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImage *normalImage;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *textColorSelected;
@property (nonatomic, retain) UIButton *prev;
@property (nonatomic, retain) UIButton *next;
@property (nonatomic, assign) float tabWidth;
@property (nonatomic, assign) float navBtnWidth;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) BOOL showNav;
@property (nonatomic, assign) BOOL showShadow;
@property (nonatomic, assign) BOOL fixed;

-(id) initWithData:(NSArray *)_data;
-(void)build;
-(void)select:(int)index;
@end
