//
//  UIStoryboard+Home.h
//  QAConnect
//
//  Copyright © 2016年 Robust Inc. All rights reserved.

#import <UIKit/UIKit.h>
#import "ListChampionViewController.h"
#import "ViewController.h"
#import "DetailViewController.h"
#import "DetailTab1ViewController.h"
#import "DetailTab2ViewController.h"
#import "HomeViewController.h"

@interface UIStoryboard (Home)
+ (UIStoryboard *)homeStoryboard;
+ (ListChampionViewController *)ListChampionViewController;
+ (HomeViewController *)instantiateHomeViewController;
+ (ViewController *)searchViewController;
+ (DetailViewController *)instantiateDetailViewController;
+ (DetailTab1ViewController *)instantiateDetailTab1ViewController;
+ (DetailTab2ViewController *)instantiateDetailTab2ViewController;
@end
