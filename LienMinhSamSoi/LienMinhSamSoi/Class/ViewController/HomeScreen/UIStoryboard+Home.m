//
//  UIStoryboard+Home.m
//  QAConnect
//
//  Copyright © 2016年 Robust Inc. All rights reserved.

#import "UIStoryboard+Home.h"
static NSString * const kListChampionVC = @"ListChampion";
static NSString * const kHomeVC = @"Home";
static NSString * const kDetailVC = @"Detail";
static NSString * const kDetailTab1VC = @"DetailTab1";
static NSString * const kDetailTab2VC = @"DetailTab2";
@implementation UIStoryboard (Home)

+ (UIStoryboard *)homeStoryboard{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (ListChampionViewController *)ListChampionViewController{
    return [[self homeStoryboard] instantiateViewControllerWithIdentifier:kListChampionVC];
}

+ (ViewController *)instantiateHomeViewController{
    return [[self homeStoryboard] instantiateViewControllerWithIdentifier:kHomeVC];
}

+ (DetailViewController *)instantiateDetailViewController{
    return [[self homeStoryboard] instantiateViewControllerWithIdentifier:kDetailVC];
}
+ (DetailTab1ViewController *)instantiateDetailTab1ViewController{
    return [[self homeStoryboard] instantiateViewControllerWithIdentifier:kDetailTab1VC];
}
+ (DetailTab2ViewController *)instantiateDetailTab2ViewController{
    return [[self homeStoryboard] instantiateViewControllerWithIdentifier:kDetailTab2VC];
}

@end
