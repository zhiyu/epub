#import <Foundation/Foundation.h>
@class Chapter;

@protocol ChapterDelegate <NSObject>
@required
- (void) chapterDidFinishLoad:(Chapter*)chapter;
@end

@interface Chapter : NSObject <UIWebViewDelegate>{
    NSString* spinePath;
    NSString* title;
    id <ChapterDelegate> delegate;
    int pageCount;
    int chapterIndex;
    CGRect windowSize;
    int fontPercentSize;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) int pageCount, chapterIndex, fontPercentSize;
@property (nonatomic, readonly) NSString *spinePath, *title;
@property (nonatomic, readonly) CGRect windowSize;

- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex;
- (void) loadChapterWithWindowSize:(CGRect)theWindowSize fontPercentSize:(int) theFontPercentSize;

@end
