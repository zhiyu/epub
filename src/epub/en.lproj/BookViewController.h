#import <UIKit/UIKit.h>
#import "ZipArchive.h"
#import "BookLoader.h"
#import "Chapter.h"

@interface BookViewController : UIViewController <UIWebViewDelegate, ChapterDelegate, UISearchBarDelegate>

- (void) showChapterIndex:(id)sender;
- (void) increaseTextSizeClicked:(id)sender;
- (void) decreaseTextSizeClicked:(id)sender;
- (void) slidingStarted:(id)sender;
- (void) slidingEnded:(id)sender;
- (void) doneClicked:(id)sender;
- (void) loadBook:(NSString *) path;

@property (nonatomic, retain) BookLoader *bookLoader;
@property (nonatomic, retain) UIView *toolbar;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIButton *chapterListButton;
@property (nonatomic, retain) UIButton *booksListButton;
@property (nonatomic, retain) UIButton *decTextSizeButton;
@property (nonatomic, retain) UIButton *incTextSizeButton;
@property (nonatomic, retain) UISlider *pageSlider;
@property (nonatomic, retain) UILabel *currentPageLabel;
@property BOOL epubLoaded;
@property BOOL paginating;
@property BOOL searching;
@property int currentSpineIndex;
@property int currentPageInSpineIndex;
@property int pagesInCurrentSpineCount;
@property int currentTextSize;
@property int totalPagesCount;

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex;

@end
