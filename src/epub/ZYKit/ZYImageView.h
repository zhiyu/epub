//
//  ZYImageView.h
//  scaffold
//
//  Created by zzy on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "CacheHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface ZYImageView : UIView

@property (nonatomic, retain) UIActivityIndicatorView *loader;
@property (nonatomic, retain) NSString *requestUrl;
@property (nonatomic, retain) NSURL *reqUrl;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) UIImageView *img;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic) int cornerRadius;
@property (nonatomic) long expires;
@property (nonatomic) float padding;

-(void)load:(NSString *)url;
-(void)render:(NSData *)data;

@end
