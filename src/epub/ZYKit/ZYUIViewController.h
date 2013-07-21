//
//  ZYUIViewController.h
//  scaffold
//
//  Created by zhiyu zheng on 12-6-11.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ZYTabViewController.h"

@interface ZYUIViewController : UIViewController

@property(nonatomic,retain) MBProgressHUD *hud;
-(void)hudShow:(NSString *)message delay:(int)delay;
-(void)hudHide;
-(void)hudLoad:(NSString *)message;

-(void)ZLHudLoad;
-(void)ZLHudHide;

@end
