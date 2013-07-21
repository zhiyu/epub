//
//  ZYSliderViewController.m
//  scaffold
//
//  Created by zhiyu zheng on 12-7-28.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import "ZYSliderView.h"
#import "ZYImageView.h"

@implementation ZYSliderView

@synthesize data;
@synthesize pageControl;
@synthesize scrollView;
@synthesize delegate;
@synthesize indicatorControl;
@synthesize indicatorSelected;
@synthesize type;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.data = [[NSMutableArray alloc] init];
        [self.data release];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        
        [self addSubview:scrollView]; 
        [scrollView release];

        type = 0;
    }
    return self;
}

-(void)reloadData{
    self.scrollView.frame = self.bounds;
    
    if(type == 0){
        self.indicatorControl = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-4, self.bounds.size.width, 4)];
        [indicatorControl release];
        indicatorControl.backgroundColor = [UIColor colorWithRed:248/255.f green:248/255.f blue:248/255.f alpha:1];
        
        self.indicatorSelected = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-4, self.bounds.size.width, 4)];
        [indicatorSelected release];
        indicatorSelected.backgroundColor = [UIColor colorWithRed:70/255.f green:134/255.f blue:234/255.f alpha:1];
        
        [self addSubview:indicatorControl];
        [self addSubview:indicatorSelected];
        indicatorSelected.frame = CGRectMake(0, self.bounds.size.height-4, self.bounds.size.width/self.data.count, 4);
    }else{
        self.pageControl = [[ZYPageControl alloc] init];
        pageControl.frame = CGRectMake(self.bounds.size.width-130, self.bounds.size.height-15, 130, 15);
        pageControl.numberOfPages = 0;
        pageControl.currentPage = 0;
        
        [self addSubview:pageControl];  
        [pageControl release];
        
        
        pageControl.frame = CGRectMake(self.bounds.size.width-130, self.bounds.size.height-15, 130, 15);
        pageControl.numberOfPages = self.data.count;
        pageControl.currentPage = 0;
    }
    
    
    [self.scrollView setContentSize:CGSizeMake(0, scrollView.bounds.size.height)];
    
    for(int i=0;i<self.scrollView.subviews.count;i++){
        [[self.scrollView.subviews objectAtIndex:i] removeFromSuperview];
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.data.count*scrollView.bounds.size.width, scrollView.bounds.size.height)];
    
    for(int i=0;i<self.data.count;i++){
        NSDictionary *dic = [data objectAtIndex:i];
        
        ZYImageView *imgView = [[ZYImageView alloc] initWithFrame:CGRectOffset(scrollView.bounds, scrollView.bounds.size.width*i, 0)];
        [self.scrollView addSubview:imgView];
        [imgView load:[dic objectForKey:@"url"]];
        imgView.expires = 60*60*24*365;
        [imgView release];
        
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(scrollView.bounds.size.width*i, scrollView.bounds.size.height-40, scrollView.bounds.size.width, 40)];
        bgView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        bgView.tag = i;
        [self.scrollView addSubview:bgView];
        [bgView release];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(scrollView.bounds.size.width*i+5, scrollView.bounds.size.height-40, scrollView.bounds.size.width-5, 36)];
        title.backgroundColor = [UIColor clearColor];
        title.text = [dic objectForKey:@"title"];
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor blackColor];
    
        [self.scrollView addSubview:title];
        [title release];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectOffset(scrollView.bounds, scrollView.bounds.size.width*i, 0)];
        btn.tag = i;
        [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [btn release];
    }
}

-(void)itemClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    [delegate slideItemClicked:tag data:[self.data objectAtIndex:tag]];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    int page = self.scrollView.contentOffset.x / scrollView.bounds.size.width;
    if(type == 0){
        UIView *headView = [self.scrollView viewWithTag:page];
        [headView setHidden:NO];
        
        [UIView beginAnimations:nil context:nil];  
        [UIView setAnimationDuration:0.3]; 
        indicatorSelected.frame = CGRectMake(page*indicatorSelected.frame.size.width, self.bounds.size.height-4, indicatorSelected.frame.size.width, 4);
        [UIView commitAnimations]; 
    }else{
        
        pageControl.currentPage = page;
    }
}



- (void)dealloc {
    [self.data release];
    [super dealloc];
}

@end
