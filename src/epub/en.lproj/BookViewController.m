#import "BookViewController.h"
#import "ChapterListViewController.h"
#import "UIWebView+SearchWebView.h"
#import "Chapter.h"
#import "EPubBookLoader.h"

@interface BookViewController()

- (void) gotoNextSpine;
- (void) gotoPrevSpine;
- (void) gotoNextPage;
- (void) gotoPrevPage;
- (int)  getGlobalPageCount;
- (void) gotoPageInCurrentSpine: (int)pageIndex;
- (void) updatePagination;

@end

@implementation BookViewController

@synthesize bookLoader;
@synthesize toolbar;
@synthesize webView;
@synthesize booksListButton;
@synthesize chapterListButton;
@synthesize decTextSizeButton;
@synthesize incTextSizeButton;
@synthesize pageSlider;
@synthesize currentPageLabel;
@synthesize epubLoaded;
@synthesize paginating;
@synthesize searching;
@synthesize currentSpineIndex;
@synthesize currentPageInSpineIndex;
@synthesize pagesInCurrentSpineCount;
@synthesize currentTextSize;
@synthesize totalPagesCount;

#pragma mark -

- (void) loadBook:(NSString *)path{
    currentSpineIndex = 0;
    currentPageInSpineIndex = 0;
    pagesInCurrentSpineCount = 0;
    totalPagesCount = 0;
	searching = NO;
    epubLoaded = NO;
    self.bookLoader = [[EPubBookLoader alloc] initWithPath:path];
    epubLoaded = YES;
	[self updatePagination];
}

- (void) chapterDidFinishLoad:(Chapter *)chapter{
    totalPagesCount+=chapter.pageCount;

	if(chapter.chapterIndex + 1 < [bookLoader.spineArray count]){
		[[bookLoader.spineArray objectAtIndex:chapter.chapterIndex+1] setDelegate:self];
		[[bookLoader.spineArray objectAtIndex:chapter.chapterIndex+1] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
		[currentPageLabel setText:[NSString stringWithFormat:@"0/%d", totalPagesCount]];
	} else {
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
		paginating = NO;
		NSLog(@"Pagination Ended!");
	}
    
    //NSLog(@"chapter:%@",chapter.spinePath);
}

- (int) getGlobalPageCount{
	int pageCount = 0;
	for(int i=0; i<currentSpineIndex; i++){
		pageCount+= [[bookLoader.spineArray objectAtIndex:i] pageCount]; 
	}
	pageCount+=currentPageInSpineIndex+1;
	return pageCount;
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
	webView.hidden = YES;
	
	NSURL* url = [NSURL fileURLWithPath:[[bookLoader.spineArray objectAtIndex:spineIndex] spinePath]];
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
	if(!paginating){
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];	
	}

}

- (void) gotoPageInCurrentSpine:(int)pageIndex{
	if(pageIndex>=pagesInCurrentSpineCount){
		pageIndex = pagesInCurrentSpineCount - 1;
		currentPageInSpineIndex = pagesInCurrentSpineCount - 1;	
	}
	
	float pageOffset = pageIndex*webView.bounds.size.width;

	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset];
	
	[webView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[webView stringByEvaluatingJavaScriptFromString:goTo];
	
	if(!paginating){
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];	
	}
	
	webView.hidden = NO;
}

- (void) gotoNextSpine {
	if(!paginating){
		if(currentSpineIndex+1<[bookLoader.spineArray count]){
			[self loadSpine:++currentSpineIndex atPageIndex:0];
		}	
	}
}

- (void) gotoPrevSpine {
	if(!paginating){
		if(currentSpineIndex-1>=0){
			[self loadSpine:--currentSpineIndex atPageIndex:0];
		}	
	}
}

- (void) gotoNextPage {
	if(!paginating){
      if(currentPageInSpineIndex+1<pagesInCurrentSpineCount){
			[self gotoPageInCurrentSpine:++currentPageInSpineIndex];
		} else {
			[self gotoNextSpine];
		}		
	}
}

- (void) gotoPrevPage {
	if (!paginating) {
		if(currentPageInSpineIndex-1>=0){
			[self gotoPageInCurrentSpine:--currentPageInSpineIndex];
		} else {
			if(currentSpineIndex!=0){
				int targetPage = [[bookLoader.spineArray objectAtIndex:(currentSpineIndex-1)] pageCount];
				[self loadSpine:--currentSpineIndex atPageIndex:targetPage-1];
			}
		}
	}
}


- (void) increaseTextSizeClicked:(id)sender{
	if(!paginating){
		if(currentTextSize+25<=200){
			currentTextSize+=25;
			[self updatePagination];
			if(currentTextSize == 200){
				[incTextSizeButton setEnabled:NO];
			}
			[decTextSizeButton setEnabled:YES];
		}
	}
}
- (void) decreaseTextSizeClicked:(id)sender{
	if(!paginating){
		if(currentTextSize-25>=50){
			currentTextSize-=25;
			[self updatePagination];
			if(currentTextSize==50){
				[decTextSizeButton setEnabled:NO];
			}
			[incTextSizeButton setEnabled:YES];
		}
	}
}

- (void) doneClicked:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


- (void) slidingStarted:(id)sender{
    int targetPage = ((pageSlider.value/(float)100)*(float)totalPagesCount);
    if (targetPage==0) {
        targetPage++;
    }
	[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d", targetPage, totalPagesCount]];
}

- (void) slidingEnded:(id)sender{
    NSLog(@"%f",pageSlider.value);
	int targetPage = (int)((pageSlider.value/(float)100)*(float)totalPagesCount);
    if (targetPage==0) {
        targetPage++;
    }
	int pageSum = 0;
	int chapterIndex = 0;
	int pageIndex = 0;
	for(chapterIndex=0; chapterIndex<[bookLoader.spineArray count]; chapterIndex++){
		pageSum+=[[bookLoader.spineArray objectAtIndex:chapterIndex] pageCount];
		NSLog(@"Chapter %d, targetPage: %d, pageSum: %d, pageIndex: %d", chapterIndex, targetPage, pageSum, (pageSum-targetPage));
		if(pageSum>=targetPage){
			pageIndex = [[bookLoader.spineArray objectAtIndex:chapterIndex] pageCount] - 1 - pageSum + targetPage;
			break;
		}
	}
	[self loadSpine:chapterIndex atPageIndex:pageIndex];
}

- (void) showChapterIndex:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showChapters" object:nil];  
}

- (void) showBooksIndex:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBooks" object:nil];  
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView{
	
	NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
    "mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}"
	"}";
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",fontPercentSize];
    
	[webView stringByEvaluatingJavaScriptFromString:varMySheet];
	[webView stringByEvaluatingJavaScriptFromString:addCSSRule];
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
    [webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
	int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
    
	pagesInCurrentSpineCount = (int)((float)totalWidth/webView.bounds.size.width);
	[self gotoPageInCurrentSpine:currentPageInSpineIndex];
}

- (void) updatePagination{
	if(epubLoaded){
        if(!paginating){
            NSLog(@"Pagination Started!");
            paginating = YES;
            totalPagesCount=0;
            [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
            [[bookLoader.spineArray objectAtIndex:0] setDelegate:self];
            [[bookLoader.spineArray objectAtIndex:0] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
            [currentPageLabel setText:@"?/?"];
            
            NSLog(@"pages:%d",totalPagesCount);
        }
	}
}

#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"shouldAutorotate");
    [self updatePagination];
	return YES;
}

#pragma mark -
#pragma mark View lifecycle

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"readerBg.png"]];

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 35, self.view.frame.size.width-10, self.view.frame.size.height - 84)];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    [webView setDelegate:self];
    [self.view addSubview:webView];
    
    self.pageSlider = [[UISlider alloc] initWithFrame:CGRectMake(-2, self.view.frame.size.height-56, self.view.frame.size.width+4, 3)];
    
    [pageSlider setThumbImage:[UIImage imageNamed:@"slider_ball_normal.png"] forState:UIControlStateNormal];
    [pageSlider setThumbImage:[UIImage imageNamed:@"slider_ball.png"] forState:UIControlStateHighlighted];
	[pageSlider setMinimumTrackImage:[UIImage imageNamed:@"orangeslide.png"] forState:UIControlStateNormal];
	[pageSlider setMaximumTrackImage:[UIImage imageNamed:@"yellowslide.png"] forState:UIControlStateNormal];

    [pageSlider setMinimumValue:1];
    [pageSlider setMaximumValue:100];
    [pageSlider addTarget:self action:@selector(slidingEnded:) forControlEvents:UIControlEventTouchUpInside];
    [pageSlider addTarget:self action:@selector(slidingEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [pageSlider addTarget:self action:@selector(slidingStarted:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageSlider];    
    
	UIScrollView* sv = nil;
	for (UIView* v in  webView.subviews) {
		if([v isKindOfClass:[UIScrollView class]]){
			sv = (UIScrollView*) v;
			sv.scrollEnabled = NO;
			sv.bounces = NO;
		}
	}
    
    
	currentTextSize = 100;	 
	
	UISwipeGestureRecognizer* rightSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)] autorelease];
	[rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
	
	UISwipeGestureRecognizer* leftSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)] autorelease];
	[leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
	
	[webView addGestureRecognizer:rightSwipeRecognizer];
	[webView addGestureRecognizer:leftSwipeRecognizer];
    

    self.toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    self.toolbar.backgroundColor = [UIColor clearColor];
    
    self.chapterListButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 44, 44)];
    [chapterListButton setImage:[UIImage imageNamed:@"chapters.png"] forState:UIControlStateNormal];
    [chapterListButton addTarget:self action:@selector(showChapterIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    self.booksListButton = [[UIButton alloc] initWithFrame:CGRectMake(toolbar.frame.size.width - 49, 0, 44, 44)];
    [booksListButton setImage:[UIImage imageNamed:@"chapters.png"] forState:UIControlStateNormal];
    [booksListButton addTarget:self action:@selector(showBooksIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    self.decTextSizeButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 100, 30)];
    decTextSizeButton.titleLabel.text =@"-A";
    self.incTextSizeButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 100, 30)];
    incTextSizeButton.titleLabel.text =@"+A";
    
    self.currentPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 120, 30)];
    currentPageLabel.backgroundColor = [UIColor clearColor];
    currentPageLabel.font = [UIFont systemFontOfSize:12];
    currentPageLabel.textAlignment = UITextAlignmentCenter;
    currentPageLabel.textColor = [UIColor colorWithRed:37/255.f green:37/255.f blue:37/255.f alpha:1];
    
    
    [self.toolbar addSubview:chapterListButton];
    [self.toolbar addSubview:decTextSizeButton];
    [self.toolbar addSubview:incTextSizeButton];
    [self.toolbar addSubview:currentPageLabel];
    [self.toolbar addSubview:booksListButton];
    [self.view addSubview:toolbar];
}

- (void)viewDidUnload {
	self.toolbar = nil;
	self.webView = nil;
	self.chapterListButton = nil;
	self.decTextSizeButton = nil;
	self.incTextSizeButton = nil;
	self.pageSlider = nil;
	self.currentPageLabel = nil;	
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    self.toolbar = nil;
	self.webView = nil;
	self.chapterListButton = nil;
	self.decTextSizeButton = nil;
	self.incTextSizeButton = nil;
	self.pageSlider = nil;
	self.currentPageLabel = nil;
	[bookLoader release];
    [super dealloc];
}

@end
