#import <UIKit/UIKit.h>
#import "ZipArchive.h"
#import "BookLoader.h"
#import "Chapter.h"
#import "ResourceHelper.h"
#import "MBProgressHUD.h"
#import "FileHelper.h"
#import "HistoryViewListController.h"
#import "HttpServerViewController.h"

@interface BookViewController : UIViewController <UIGestureRecognizerDelegate,UIWebViewDelegate, ChapterDelegate, UISearchBarDelegate>

- (void) showChapterIndex:(id)sender;
- (void) increaseTextSizeClicked:(id)sender;
- (void) decreaseTextSizeClicked:(id)sender;
- (void) slidingStarted:(id)sender;
- (void) slidingEnded:(id)sender;
- (void) doneClicked:(id)sender;
- (void) loadBook:(NSNotification *)notification;

@property (nonatomic,retain) HistoryListViewController *historyListViewController;
@property (nonatomic,retain) HttpServerViewController *httpServerViewController;

@property (nonatomic,retain)  MBProgressHUD *hud;
@property (nonatomic, retain) BookLoader *bookLoader;
@property (nonatomic, retain) UIView *headerbar;
@property (nonatomic, retain) UIView *toolbar;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIButton *chapterListButton;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UIButton *decTextSizeButton;
@property (nonatomic, retain) UIButton *incTextSizeButton;
@property (nonatomic, retain) UIButton *uploadButton;
@property (nonatomic, retain) UISlider *pageSlider;
@property (nonatomic, retain) UILabel *currentPageLabel;
@property (nonatomic, retain) UILabel *currentPageLabel2;
@property BOOL epubLoaded;
@property BOOL paginating;
@property BOOL enablePaging;
@property BOOL searching;
@property BOOL isClearWebViewContent;
@property int currentSpineIndex;
@property int currentPageInSpineIndex;
@property int pagesInCurrentSpineCount;
@property int currentTextSize;
@property int totalPagesCount;

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex;

@end
