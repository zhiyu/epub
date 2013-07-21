//
//  HttpServerViewController.m
//  epub
//
//  Created by zhiyu on 13-6-4.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "HttpServerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ResourceHelper.h"

@interface HttpServerViewController ()

@end

@implementation HttpServerViewController

@synthesize httpServer;
@synthesize text;
@synthesize url;
@synthesize wifi;

#define PORT 8000

- (void)dealloc {
    [httpServer release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.hidden = YES;
    }
    return self;
}

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
    
    UIButton *stop = [[UIButton alloc] initWithFrame:CGRectMake(120, self.view.bounds.size.height/2+140, 80, 80)];
    [stop setImage:[ResourceHelper loadImageByTheme:@"close_wifi"] forState:UIControlStateNormal];
    [stop addTarget:self action:@selector(stopServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stop];
    
    self.wifi = [[UIButton alloc] initWithFrame:CGRectMake(80, self.view.bounds.size.height/2-160, 160, 160)];
    [wifi release];
    [wifi setImage:[ResourceHelper loadImageByTheme:@"wifi_close"] forState:UIControlStateNormal];
    [wifi setImage:[ResourceHelper loadImageByTheme:@"wifi"] forState:UIControlStateHighlighted];
    [wifi setUserInteractionEnabled:NO];
    
    self.text = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2+30, self.view.frame.size.width, 20)];
    [text release];
    [text setTextAlignment:NSTextAlignmentCenter];
    [text setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]];
    
    self.url = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2+60, self.view.frame.size.width, 20)];
    [url release];
    [url setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:text];
    [self.view addSubview:url];
    [self.view addSubview:wifi];
    
}

-(void)switchAction:(id)sender
{
    UISwitch *s = (UISwitch*)sender;
    BOOL isButtonOn = [s isOn];
    if(isButtonOn){
        [self startServer];
    }else{
        [self stopServer];
    }
}

-(void) startServer{
    [wifi setHighlighted:YES];
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    self.view.hidden = NO;
    [UIView commitAnimations];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *ip = [GetAddress localWiFiIPAddress];
    
    if(ip == NULL){
        text.text = NSLocalizedString(@"server_network_err", nil);
        url.text = @"";
        [wifi setHighlighted:NO];
        return;
    }
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
	
    self.httpServer = [[HTTPServer alloc] init];
    [httpServer release];
    
	[httpServer setType:@"_http._tcp."];
	[httpServer setPort:PORT];
    
	[httpServer setDocumentRoot:documentsDirectory];
    [httpServer setConnectionClass:[MyHTTPConnection class]];
	
	NSError *error = nil;
	if(![httpServer start:&error])
	{
        text.text = NSLocalizedString(@"server_server_err", nil);
        [wifi setHighlighted:NO];
	}else{
        text.text = NSLocalizedString(@"server_upload_info", nil);
        url.text = [NSString stringWithFormat:@"http://%@:%d",ip,PORT];
    }
}

-(void)stopServer{
    [httpServer stop:NO];
    [wifi setHighlighted:NO];
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    self.view.hidden = YES;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
