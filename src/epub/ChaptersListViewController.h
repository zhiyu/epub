#import <UIKit/UIKit.h>
#import "BookViewController.h"

@interface ChaptersListViewController : UITableViewController

@property(nonatomic, assign) BookViewController* bookViewController;
@property(nonatomic,retain) NSIndexPath *selectedIndexPath;

-(void)loadChapters;

@end