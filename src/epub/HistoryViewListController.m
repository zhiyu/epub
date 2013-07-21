#import "HistoryViewListController.h"
#import "FileHelper.h"
#import "FileHelper.h"
#import "ResourceHelper.h"

@implementation HistoryListViewController

@synthesize data;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    self.data = [[NSMutableArray alloc] init];   
    self.tableView.separatorColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
    
    [self loadBooks];
    return self;
}

-(void)loadBooks{    
    NSMutableArray *books = [FileHelper getDataFromFile:@"history"];
    [self.data removeAllObjects];
    if(books!=nil)
        self.data = books;
    [self.tableView reloadData];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(self.data.count==0){
        return 1;
    }
    return self.data.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if(data.count==0){
        cell.textLabel.text = NSLocalizedString(@"no records", nil);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }else if(data.count == indexPath.row){
        cell.textLabel.text =  NSLocalizedString(@"clear records", nil);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }else{
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.text = [[[data objectAtIndex:indexPath.row] objectForKey:@"name"] stringByDeletingPathExtension];
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"item_bg_selected"]];
    [backView release];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
    myView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 16)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text=NSLocalizedString(@"recently read", nil);
    [myView addSubview:titleLabel];
    [titleLabel release];
    return myView;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if(data.count!=0){
        if(data.count == indexPath.row){
            [FileHelper empty:@"history"];
            self.data = [FileHelper getDataFromFile:@"history"];
            [self.tableView reloadData];
            return;
        }
        NSDictionary *path = [[self.data objectAtIndex:indexPath.row] objectForKey:@"path"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadBook" object:path];
    }
}

@end
