#import "BooksListViewController.h"

@implementation BooksListViewController

@synthesize data, selectedIndexPath;

-(void)editList:(id)sender{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    self.data = [[NSMutableArray alloc] init];   
    self.tableView.separatorColor = [UIColor colorWithRed:225/255.f green:225/255.f blue:225/255.f alpha:1];
    
    return self;
}

-(void)loadBooks{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *dirs = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSMutableDictionary *dir = [[NSMutableDictionary alloc] init];
    [dir setObject:NSLocalizedString(@"books", nil) forKey:@"title"];
    NSMutableArray *books = [[NSMutableArray alloc] init];
    for(int i=0;i<dirs.count;i++){
        if([[[dirs objectAtIndex:i] pathExtension] isEqualToString:@"epub"]){
            NSMutableDictionary *book = [[NSMutableDictionary alloc] init];
            [book setObject:[dirs objectAtIndex:i] forKey:@"title"];
            [book setObject:[NSString stringWithFormat:@"%@/%@",documentsDirectory,[dirs objectAtIndex:i]] forKey:@"path"];
            [books addObject:book];
            [book release];
        }
    }
    [dir setObject:books forKey:@"data"];
    
    [self.data removeAllObjects];
    [self.data addObject:dir];
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

- (void)viewDidLayoutSubviews{
    if(self.selectedIndexPath!=nil)
        [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[data objectAtIndex:section] objectForKey:@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"item_bg"]];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1];
        cell.textLabel.highlightedTextColor=[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
        
        //[cell.textLabel setShadowColor:[UIColor whiteColor]];
        //[cell.textLabel setShadowOffset:CGSizeMake(0, 1)];
        
        UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = backView;
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"item_bg_selected"]];
        [backView release];
    }

    cell.textLabel.text = [[[[[data objectAtIndex:[indexPath section]] objectForKey:@"data"] objectAtIndex:[indexPath row]] objectForKey:@"title"] stringByDeletingPathExtension];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{    
    UIView* myView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)] autorelease];
    myView.backgroundColor = [UIColor colorWithPatternImage:[ResourceHelper loadImageByTheme:@"head_bg"]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 44)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text=[[data objectAtIndex:section] objectForKey:@"title"];
    [myView addSubview:titleLabel];
    [titleLabel release];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(myView.frame.size.width-44, 0, 44,44)];
    [editBtn setImage:[ResourceHelper loadImageByTheme:@"trash"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editList:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:editBtn];
    
    return myView;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    return UITableViewCellEditingStyleDelete;
} 

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"delete", nil);
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{ 
    return NO; 
} 

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *) fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{ 
    
} 

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *path = [[[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"path"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:path]){
            [fileManager removeItemAtPath:path error:nil];
        }

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        NSString *strPath=[NSString stringWithFormat:@"%@/%@/",cacheDirectory,path];
        
        if ([fileManager fileExistsAtPath:strPath]) {
            NSLog(@"exist");
            NSError *error;
            [fileManager removeItemAtPath:strPath error:&error];
        }
             
        [self loadBooks];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:nil];
    NSDictionary *book = [[[self.data objectAtIndex:[indexPath section]] objectForKey:@"data"] objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBooks" object:[book objectForKey:@"path"]];
}

@end
