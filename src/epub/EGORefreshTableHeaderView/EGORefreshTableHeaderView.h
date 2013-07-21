#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,	
} EGOPullRefreshState;

@protocol EGORefreshTableHeaderDelegate;

@interface EGORefreshTableHeaderView : UIView {
	id _delegate;
	EGOPullRefreshState _state;
    int direction;
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
    
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <EGORefreshTableHeaderDelegate> delegate;
@property(nonatomic) int direction;
@property(nonatomic,assign) NSString *pullText;
@property(nonatomic,assign) NSString *releaseText;
@property(nonatomic,assign) NSString *loadingText;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor direction:(int) dir;
- (id)initWithFrameUpDirection:(CGRect)frame;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;
@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view;
@end
