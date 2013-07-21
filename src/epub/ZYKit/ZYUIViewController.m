//
//  ZYUIViewController.m
//  scaffold
//
//  Created by zhiyu zheng on 12-6-11.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import "ZYUIViewController.h"
#import "AppDelegate.h"

@implementation ZYUIViewController

@synthesize hud;

-(void)hudShow:(NSString *)message delay:(int)delay{
    if(hud!=nil)
        [hud hide:NO];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.customView = [[[UIView alloc] init] autorelease];
    hud.mode = MBProgressHUDModeCustomView;
    [self.view addSubview:hud];
    [hud release];
    hud.labelText = message;
    [hud show:YES];
    if(delay > 0)
    [hud hide:YES afterDelay:1];
}

-(void)hudHide{
    [hud hide:NO];
}

-(void)hudLoad:(NSString *)message{
    if(hud!=nil)
        [hud hide:NO];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud release];
    hud.labelText = message;
    [hud show:YES];
}


- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;
}

- (void)dealloc {
    [hud release];
    [super dealloc];
}


@end
