//
//  UIStoryboard+Quickly.m
//  Quickly
//
//  Created by Phi Dung on 1/20/15.
//  Copyright (c) 2015 NewWind Software. All rights reserved.
//

#import "UIStoryboard+Quickly.h"

@implementation UIStoryboard (Quickly)


+ (UIStoryboard *)SplashStoryboard {
	return [self storyboardWithName:@"Splash" bundle:nil];
}

+ (UIStoryboard *)section1Storyboard {
    return [self storyboardWithName:@"Section1" bundle:nil];
}

+ (UIStoryboard *)homeStoryboard {
	return [self storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard *)rightViewStoryboard {
	return [self storyboardWithName:@"RightView" bundle:nil];
}

+ (UIStoryboard *)tab2Storyboard{
    return [self storyboardWithName:@"Tab2ViewController" bundle:nil];
}
+ (UIStoryboard *)tab3Storyboard{
    return [self storyboardWithName:@"Tab3ViewController" bundle:nil];
}
+ (UIStoryboard *)tab4Storyboard{
    return [self storyboardWithName:@"Tab4ViewController" bundle:nil];
}


@end
