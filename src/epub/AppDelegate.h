#import <UIKit/UIKit.h>
#import "HTTPServer.h"
#import "ZYTabViewController.h"
#import "SettingsViewController.h"
#import "BookViewController.h"
#import "ChaptersListViewController.h"
#import "BooksListViewController.h"
#import "StoreViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> 

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *detailViewController;
@property (nonatomic, retain) BookViewController *bookViewController;
@property (nonatomic, retain) ZYTabViewController *leftViewController;
@property (nonatomic, retain) UIViewController *rightViewController;
@property (nonatomic, retain) ChaptersListViewController *chaptersListViewController;
@property (nonatomic, retain) BooksListViewController *booksListViewController;
@property (nonatomic, retain) StoreViewController *storeViewController;
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) NSString *path;
@property (nonatomic) int selectedChapter;

@property (nonatomic) int slideWidth;

@end
