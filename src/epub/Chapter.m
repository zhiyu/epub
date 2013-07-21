#import "Chapter.h"
#import "NSString+HTML.h"
#import "Constants.h"

@implementation Chapter 

@synthesize delegate, chapterIndex, title, pageCount, spinePath, windowSize, fontPercentSize;

- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex{
    if((self=[super init])){
        spinePath = [theSpinePath retain];
        title = [theTitle retain];
        chapterIndex = theIndex;
    }
    return self;
}

- (void) loadChapterWithWindowSize:(CGRect)theWindowSize fontPercentSize:(int) theFontPercentSize{
    fontPercentSize = theFontPercentSize;
    windowSize = theWindowSize;
    UIWebView* webView = [[UIWebView alloc] initWithFrame:windowSize];
    [webView setDelegate:self];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:spinePath]];
    [webView loadRequest:urlRequest];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@", error);
	[webView release];
}

- (void) webViewDidFinishLoad:(UIWebView*)webView{	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'font-size:14px;margin:0px;padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",fontPercentSize];
    
	[webView stringByEvaluatingJavaScriptFromString:SHEET];
	[webView stringByEvaluatingJavaScriptFromString:ADDCSSRULE];
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
    [webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
    
	int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
	pageCount = (int)((float)totalWidth/webView.bounds.size.width);

    [webView release];
    [delegate chapterDidFinishLoad:self];    
}

- (void)dealloc {
    [title release];
	[spinePath release];
    [super dealloc];
}


@end
