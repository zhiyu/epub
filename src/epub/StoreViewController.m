//
//  StoreViewController.m
//  epub
//
//  Created by zhiyu on 13-6-8.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "StoreViewController.h"
#import "ResourceHelper.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(58, 50, 160, 160)];
    view.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:NSLocalizedString(@"store_bg", nil)]];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
