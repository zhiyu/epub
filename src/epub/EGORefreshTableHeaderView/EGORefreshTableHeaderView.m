//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"

#define  RefreshViewHight 65.0f
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;
@synthesize direction;
@synthesize releaseText;
@synthesize pullText;
@synthesize loadingText;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor direction:(int)dir{
    if((self = [super initWithFrame:frame])) {
        
        self.pullText    = @"下拉刷新";
        self.releaseText = @"释放后刷新";
        self.loadingText = @"正在刷新...";
        self.direction   = dir;
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];

        if(direction == 0){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            label.font = [UIFont systemFontOfSize:12.0f];
            label.textColor = textColor;
            label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
            label.shadowOffset = CGSizeMake(0.0f, 1.0f);
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            [self addSubview:label];
            _lastUpdatedLabel=label;
            [label release];
            
           
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            label.font = [UIFont boldSystemFontOfSize:13.0f];
            label.textColor = textColor;
            label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
            label.shadowOffset = CGSizeMake(0.0f, 1.0f);
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            [self addSubview:label];
            _statusLabel=label;
            [label release];
            
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
            layer.contentsGravity = kCAGravityResizeAspect;
            layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
            #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
                if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                    layer.contentsScale = [[UIScreen mainScreen] scale];
                }
            #endif
                
            [[self layer] addSublayer:layer];
            _arrowImage=layer;
            
            UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
            [self addSubview:view];
            _activityView = view;
            [view release];
            
        }else{
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHight - 30.0f, self.frame.size.width, 20.0f)];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            label.font = [UIFont systemFontOfSize:12.0f];
            label.textColor = TEXT_COLOR;
            label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
            label.shadowOffset = CGSizeMake(0.0f, 1.0f);
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            [self addSubview:label];
            _lastUpdatedLabel=label;
            [label release];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHight - 48.0f, self.frame.size.width, 20.0f)];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            label.font = [UIFont boldSystemFontOfSize:13.0f];
            label.textColor = TEXT_COLOR;
            label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
            label.shadowOffset = CGSizeMake(0.0f, 1.0f);
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            [self addSubview:label];
            _statusLabel=label;
            [label release];
            
            
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(25.0f, 5, 30.0f, 55.0f);
            layer.contentsGravity = kCAGravityResizeAspect;
            layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
                
            #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
                if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                    layer.contentsScale = [[UIScreen mainScreen] scale];
                }
            #endif
                
            [[self layer] addSublayer:layer];
            _arrowImage=layer;    
            
            UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            view.frame = CGRectMake(25.0f, 27, 20.0f, 20.0f);
            [self addSubview:view];
            _activityView = view;
            [view release];
        }
		
		
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
    
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR direction:0];
}

- (id)initWithFrameUpDirection:(CGRect)frame  {
    
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR direction:1];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
            _statusLabel.text = releaseText;
            
			[CATransaction begin];
          	[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
            _statusLabel.text = pullText;
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;            
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
            
			break;
            
		case EGOOPullRefreshLoading:
            _statusLabel.text = loadingText;
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
		
//		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
//		offset = MIN(offset, 60);
//        
//        if(direction == 0 )
//		  scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
//        else
//          scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, RefreshViewHight, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
        
        if(direction == 0){
		
	  	  if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			  [self setState:EGOOPullRefreshNormal];
		  } else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
              [self setState:EGOOPullRefreshPulling];
		  }
		
		  if (scrollView.contentInset.top != 0) {
		    	scrollView.contentInset = UIEdgeInsetsZero;
		  }
        
        }else{
		
	  	  if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight && scrollView.contentOffset.y > 0.0f && !_loading) {
			  [self setState:EGOOPullRefreshNormal];
		  } else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight  && !_loading) {
			  [self setState:EGOOPullRefreshPulling];
		  }
		
        
		  if (scrollView.contentInset.bottom != 0) {
			  scrollView.contentInset = UIEdgeInsetsZero;
		  }
        
        }
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
    if(direction == 0){
	  if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	  }
    }else{
	  if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
		[UIView commitAnimations];
	  }
    }
    
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
