//
//  HttpServerViewController.h
//  epub
//
//  Created by zhiyu on 13-6-4.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHTTPConnection.h"
#import "GetAddress.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "HTTPServer.h"

@interface HttpServerViewController : UIViewController


@property (nonatomic, retain) HTTPServer *httpServer;
@property (nonatomic, retain) UILabel *text;
@property (nonatomic, retain) UILabel *url;
@property (nonatomic, retain) UIButton *wifi;

-(void) startServer;
-(void) stopServer;

@end
