//
//  ZYImageView.m
//  scaffold
//
//  Created by zzy on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZYImageView.h"

@implementation ZYImageView

@synthesize reqUrl;
@synthesize requestUrl;
@synthesize loader;
@synthesize request;
@synthesize cornerRadius;
@synthesize expires;
@synthesize img;
@synthesize padding;
@synthesize label;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        
        float w = self.bounds.size.width;
        float h = self.bounds.size.height;
        
        self.padding = 0;
        
        self.loader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((w-20)/2, (h-20)/2, 20, 20)];
        [loader release];
        [loader setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [loader setHidesWhenStopped:YES];
        [self addSubview:loader];  
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake((w-100)/2, (h-20)/2, 100, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.hidden = YES;
        [label release];
        [self addSubview:label];  

        self.cornerRadius = 0;
        self.expires = 60*60*24*30*12;
    }
    return self;
}

-(void)load:(NSString *)url{
    if(url==nil || url==[NSNull null] || [url isEqualToString:@""])
        return;
    
    label.hidden = YES;
    [loader startAnimating];
    self.requestUrl = url;
    NSData *cache = [CacheHelper get:requestUrl];
    if(cache!=nil){
        NSData *data = [NSKeyedUnarchiver unarchiveObjectWithData:cache];
        [self render:data];
    }else{
        self.reqUrl = [[NSURL alloc] initWithString: requestUrl];
        [reqUrl release];
        
        self.request = [[ASIHTTPRequest alloc] initWithURL:reqUrl];
        [request release];
        [request setValidatesSecureCertificate:NO];
        [request setTimeOutSeconds:30];
        [request setDelegate:self];
        [request startAsynchronous];   
    }

}

- (void)requestFinished:(ASIHTTPRequest *)req
{
    if([reqUrl isEqual:req.url]){
        NSData *data = [req responseData];
        if(data!=nil){
            [self render:data];
            NSData *cache = [NSKeyedArchiver archivedDataWithRootObject:data];
            [CacheHelper setObject:cache forKey:requestUrl withExpires:expires];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)req
{
    if([reqUrl isEqual:req.url]){
        [req cancel];
        [loader stopAnimating];
         label.hidden = NO;
        label.text = @"加载失败!";
    }
}

-(void)render:(NSData *)data{
    
    if(self.img == nil){
        self.img = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds,self.padding,self.padding)];
        [img release];
        [self addSubview:img];
    }
    
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.borderWidth = 0;
    self.layer.masksToBounds = YES;
    
    self.img.layer.cornerRadius = self.cornerRadius-self.padding;
    self.img.layer.borderWidth = 0;
    self.img.layer.masksToBounds = YES;
    
    UIImage *image = [[UIImage alloc] initWithData:data];  
    self.img.image = image;
    self.img.contentMode = UIViewContentModeScaleAspectFill;  
    [self setNeedsDisplay];   
    [image release];
    [loader stopAnimating];
}

- (void)dealloc {  
    [request clearDelegatesAndCancel];
    [request release];
    [loader release];  
    [requestUrl release];  
    [reqUrl release];  
    [img release];
    [label release];
    [super dealloc];  
} 

@end
