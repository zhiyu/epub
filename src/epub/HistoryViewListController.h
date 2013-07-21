#import <UIKit/UIKit.h>

@interface HistoryListViewController : UITableViewController

@property(nonatomic,retain) NSMutableArray *data;

-(void)loadBooks;

@end