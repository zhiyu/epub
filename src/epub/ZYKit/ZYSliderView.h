//
//  ZYSliderViewController.h
//  scaffold
//
//  Created by zhiyu zheng on 12-7-28.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYPageControl.h"

@protocol ZYSliderViewDelegate<NSObject>
-(void)slideItemClicked:(int)index data:(NSDictionary*)item;
@end

@interface ZYSliderView : UIView<UIScrollViewDelegate>

@property(nonatomic,retain) NSMutableArray *data;
@property(nonatomic,retain) ZYPageControl *pageControl;
@property(nonatomic,retain) UIView *indicatorControl;
@property(nonatomic,retain) UIView *indicatorSelected;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) id<ZYSliderViewDelegate> delegate;
@property(nonatomic,assign) int type;

-(void)reloadData;

@end
