//
//  TabViewController.m
//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZYTabBarView.h"
#import "ResourceHelper.h"
#import <QuartzCore/QuartzCore.h> 

@implementation ZYTabBarView

@synthesize data;
@synthesize delegate;
@synthesize normalImage;
@synthesize selectedImage;
@synthesize textColor;
@synthesize textColorSelected;
@synthesize prev;
@synthesize next;
@synthesize tabWidth;
@synthesize navBtnWidth;
@synthesize scrollView;
@synthesize selectedIndex;
@synthesize showNav;
@synthesize showShadow;
@synthesize fixed;

-(id) initWithData:(NSArray *)_data{
    self = [super init];
    self.data = _data;
    self.tabWidth = 100;
    self.navBtnWidth = 20;
    self.showNav = NO;
    self.showShadow = NO;
    self.fixed = NO;
    return self;
}

-(void)build{
    if(showShadow){
        self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity =0.1;
    }
    
    if(!showNav){
        navBtnWidth = 0;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(navBtnWidth, 0, self.frame.size.width-2*navBtnWidth, self.frame.size.height)];
    [self.scrollView release];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    CGSize newSize = CGSizeMake(tabWidth * data.count, self.frame.size.height);
    scrollView.contentSize = newSize;
    
    for(int i=0;i<data.count;i++){
        float x = tabWidth*i;
        NSDictionary *item = [data objectAtIndex:i];
        NSString *text = [item objectForKey:@"text"];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, tabWidth,self.frame.size.height)];
        btn.tag = i;
        
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [btn setTitleColor:textColor forState:UIControlStateNormal];
        [btn setTitleColor:textColorSelected forState:UIControlStateSelected];
        [btn setTitleColor:textColorSelected forState:UIControlStateHighlighted];
        
        [btn setAdjustsImageWhenHighlighted:NO];
        [btn setTitle:text forState:UIControlStateNormal];
        [btn setTitle:text forState:UIControlStateNormal];
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [btn setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
        [btn setBackgroundImage:selectedImage forState:UIControlStateReserved];
        [btn addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        [btn release];
        
    }
    [self addSubview:scrollView];
    [scrollView release];
    
    if(showNav){
        self.prev = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, navBtnWidth,self.frame.size.height)];
        [prev release];
        [prev setAdjustsImageWhenHighlighted:NO];
        [self.prev addTarget:self action:@selector(prev:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:prev];
        
        self.next = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-navBtnWidth, 0, navBtnWidth,self.frame.size.height)];
        [next release];
        [next setAdjustsImageWhenHighlighted:NO];
        [self.next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:next];
    }
    
}

-(void)prev:(id)sender{
    if(selectedIndex>0){
        [self select:(selectedIndex-1)];
    }
}

-(void)next:(id)sender{
    if(selectedIndex<(self.data.count-1)){
        [self select:(selectedIndex+1)];
    }
}

-(void)select:(int)index{
    UIButton *btn = (UIButton *)[scrollView.subviews objectAtIndex:index];
    [self tabButtonPressed:btn];
}

-(void)tabButtonPressed:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    for(UIView *b in scrollView.subviews){
        if([b isMemberOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)b;
            button.selected = NO;
        }
    }
    int index = btn.tag;
    
    self.selectedIndex = index;
    btn.selected = YES;
    
    float off = selectedIndex*tabWidth;
    if(scrollView.contentSize.width <= scrollView.frame.size.width){
        off = 0;
    }else{
        if(scrollView.contentSize.width - off < scrollView.frame.size.width){
            off = scrollView.contentSize.width - scrollView.frame.size.width;
        }
    }
    if(!fixed){
        [scrollView setContentOffset:CGPointMake(off, 0) animated:YES];
    }
    [delegate itemClicked:index data:[data objectAtIndex:index]];
}

- (void)dealloc {
    [super dealloc];
}


@end
