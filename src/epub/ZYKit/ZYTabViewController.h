//
//  TabViewController.h
//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYTabViewController : UIViewController

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIView *tabView;
@property (nonatomic, retain) UIView *selectedBgView;
@property (nonatomic, retain) NSArray *tabItems;
@property (nonatomic, retain) UIColor *backgroundColor;

-(id) initWithControllers:(NSArray *)controllers tabItems:(NSArray *) items bg:(UIColor *)color;
-(void)tabButtonPressed:(id)sender;
-(void)selectTab:(int)index;
-(void)hideTabs:(NSNotification *)notification;
-(void)showTabs:(NSNotification *)notification;
-(void)build;

@end
