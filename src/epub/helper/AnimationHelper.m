//  scaffold
//
//  Created by zzy on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimationHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnimationHelper

+(void)addAnimation:(int) type subType:(int) subType forView:(UIView *)view duration:(float)duration{
    CATransition *animation = [CATransition animation];
    animation.duration = duration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
	animation.removedOnCompletion = YES;

	switch (type) {
		case 0:
			animation.type = kCATransitionPush;
			break;
		case 1:
			animation.type = kCATransitionMoveIn;
			break;
		case 2:
			animation.type = kCATransitionReveal;
			break;
		case 3:
			animation.type = kCATransitionFade;
			break;
		default:
			break;
	}
    
    switch (subType) {
		case 0:
			animation.subtype = kCATransitionFromTop;
			break;
		case 1:
			animation.subtype = kCATransitionFromRight;
			break;
		case 2:
			animation.subtype = kCATransitionFromBottom;
			break;
		case 3:
			animation.subtype = kCATransitionFromLeft;
			break;
		default:
			break;
	}
    
	[view.layer addAnimation:animation forKey:@"animation"];
}
@end
