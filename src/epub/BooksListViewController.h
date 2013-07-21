#import <UIKit/UIKit.h>
#import "BookViewController.h"

@interface BooksListViewController : UITableViewController

@property(nonatomic,retain) NSMutableArray *data;
@property(nonatomic,retain) NSIndexPath *selectedIndexPath;

-(void)loadBooks;

@end