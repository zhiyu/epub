//
//  SettingsViewController.m
//  epub
//
//  Created by zhiyu on 13-6-7.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "SettingsViewController.h"
#import "ResourceHelper.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(58, 50, 160, 160)];
    view.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"logobg"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 210, 160, 20)];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1];
    label.text = [NSString stringWithFormat:@"%@%@",@"Version: ",(NSString *)[[[NSBundle mainBundle] infoDictionary] valueForKey:kCFBundleVersionKey]];
    
    
    UILabel *com = [[UILabel alloc] initWithFrame:CGRectMake(60, 320, 160, 20)];
    com.textAlignment = UITextAlignmentCenter;
    com.textColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1];
    com.text = @"bracecloud.com";
    
    UILabel *cr = [[UILabel alloc] initWithFrame:CGRectMake(60, 340, 160, 20)];
    cr.textAlignment = UITextAlignmentCenter;
    cr.font = [UIFont systemFontOfSize:10];
    cr.textColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1];
    cr.text = @"copyright © 2013";
    
    [self.view addSubview:view];
    [self.view addSubview:label];
    [self.view addSubview:com];
    [self.view addSubview:cr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
