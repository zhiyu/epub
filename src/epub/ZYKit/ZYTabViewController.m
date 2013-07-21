//
//  TabViewController.m
//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZYTabViewController.h"
#import "ResourceHelper.h"
#import <QuartzCore/QuartzCore.h> 

#define TABVIEW_HEIGHT 44

@implementation ZYTabViewController

@synthesize viewControllers;
@synthesize contentView;
@synthesize tabView;
@synthesize tabItems;
@synthesize selectedBgView;
@synthesize backgroundColor;

-(id) initWithControllers:(NSArray *)controllers tabItems:(NSArray *) items bg:(UIColor *)color{
    self = [super init];
    self.viewControllers = controllers;
    self.tabItems = items;
    self.backgroundColor = color;
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabs:) name:@"hideTabs" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabs:) name:@"showTabs" object:nil];
    
}

-(void)build{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-TABVIEW_HEIGHT)];
    
    self.contentView.autoresizesSubviews =YES;
    
    self.tabView     = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - TABVIEW_HEIGHT, self.view.frame.size.width, TABVIEW_HEIGHT)];

    self.tabView.backgroundColor = self.backgroundColor;
    
    int buttonWidth = self.tabView.frame.size.width/self.tabItems.count;
    CGSize buttonSize = CGSizeMake(buttonWidth, TABVIEW_HEIGHT);
    
    for(int i=0;i<self.tabItems.count;i++){
        int x = i*buttonWidth;
        NSDictionary *tabItem = [tabItems objectAtIndex:i];
        NSString *text = [tabItem objectForKey:@"text"];
        NSString *imageNameNormal = [tabItem objectForKey:@"imageNormal"];
        NSString *imageNameSelected = [tabItem objectForKey:@"imageSelected"];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, buttonSize.width,TABVIEW_HEIGHT)];
        UIImage *imageNormal   = [ResourceHelper loadImageByTheme:imageNameNormal];
        UIImage *imageSelected = [ResourceHelper loadImageByTheme:imageNameSelected];
        
        btn.tag = i;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setImage:imageNormal forState:UIControlStateNormal];
        [btn setImage:imageSelected forState:UIControlStateHighlighted];
        [btn setImage:imageSelected forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabView addSubview:btn];
        [btn release];
    }
    
    [self.view addSubview:contentView];
    [self.view addSubview:tabView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, buttonSize.width, buttonSize.height-2)];
    UIImageView *ind = [[UIImageView alloc] initWithImage:[ResourceHelper loadImageByTheme:@"tabind"]];
    ind.frame = CGRectMake((buttonSize.width-7)/2, 0, 7, 7);
    [bgView addSubview:ind];
    bgView.backgroundColor = [[UIColor alloc] initWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
    self.selectedBgView = bgView;
    UIView *tabViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabView.frame.size.width, 2)];
    tabViewHeader.backgroundColor = [[UIColor alloc] initWithRed:251/255.f green:144/255.f blue:44/255.f alpha:1];
    [self.tabView insertSubview:tabViewHeader atIndex:0];
    [self.tabView insertSubview:bgView atIndex:1];
    
    tabViewHeader.hidden = YES;
    bgView.hidden = YES;
    [bgView release];
    [tabViewHeader release];
    
    [contentView release];
    [tabView release];
    
    for(UIViewController *vc in viewControllers){
        vc.view.frame = contentView.bounds;
    }
    
    [self selectTab:0];

}
-(void)selectTab:(int)index{
    [self tabButtonPressed:[self.tabView.subviews objectAtIndex:(index+2)]];
}

-(void)tabButtonPressed:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    for(UIView *b in tabView.subviews){
        if([b isMemberOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)b;
            button.selected = NO;
        }
    }
    int index = btn.tag;
    
    btn.selected = YES;
    
    int buttonWidth = self.tabView.frame.size.width/self.tabItems.count;
    int x= index*buttonWidth;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2];
	CGRect rect = [self.selectedBgView frame];
	rect.origin.x = x;
	[self.selectedBgView setFrame:rect];
	[UIView commitAnimations];
    
    if(self.contentView.subviews.count > 0)
       [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
    
    if([viewControllers objectAtIndex:index]!=nil){
	    [self.contentView addSubview:[[viewControllers objectAtIndex:index] view]];
        [[viewControllers objectAtIndex:index] viewWillAppear:NO];
    }
}

-(void)hideTabs:(NSNotification *)notification{
    if(!tabView.hidden){
        CATransition *transition = [CATransition animation]; 
        transition.duration = 1.0f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"rippleEffect";
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self; 
        [self.tabView.layer addAnimation:transition forKey:nil]; 
        tabView.hidden = YES;
    }
}
       
-(void)showTabs:(NSNotification *)notification{
    if(tabView.hidden){
        CATransition *transition = [CATransition animation]; 
        transition.duration = 1.0f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"rippleEffect";
        //@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip" 
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self; 
        [self.tabView.layer addAnimation:transition forKey:nil]; 
        tabView.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"tab will appear");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)dealloc {
    [super dealloc];
	[contentView release];
	[tabView release];
    [viewControllers release];
    [tabItems release];
    [selectedBgView release];
    [backgroundColor release];
}


@end
