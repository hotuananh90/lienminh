//
//  HomeViewController.m
//  LienMinhSamSoi
//
//  Created by tuan anh on 6/27/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "HomeViewController.h"
#import "DEMONavigationController.h"
#import "MBProgressHUD.h"
#import "Util.h"
#import "REFrostedViewController.h"
#import "iOSLoLAPI.h"
#import <AFNetworking.h>
#import "ChampionCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"
#import "DetailTab1ViewController.h"
#import "DetailTab2ViewController.h"
#import "UIStoryboard+Home.h"
#import "CarbonKit.h"
#import "ListRankViewController.h"

@interface HomeViewController ()<REFrostedViewControllerDelegate,CarbonTabSwipeNavigationDelegate>
{
    UIButton *revealButton;
    NSArray *items;
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTheme];
    items = @[
              @"Tìm Kiếm",
              @"Thách Đấu Hàn Quốc",
              @"Thách Đấu NA",
              @"Thách Đấu Brasin",
              @"Top Paid"
              ];
    
    carbonTabSwipeNavigation = [[CarbonTabSwipeNavigation alloc] initWithItems:items delegate:self];
    [carbonTabSwipeNavigation insertIntoRootViewController:self];
    [self style];
    if (gCheckFirtApp) {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChampion:) name:NOTIFICATION_CHAMPION object:nil];
}

- (void)setTheme{
    revealButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    [revealButton setImage:[UIImage imageNamed:@"ic_Home.png"] forState:UIControlStateNormal];
    [revealButton addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:revealButton];
}

- (void)getChampion:(NSNotification *)notification {
    gCheckFirtApp = NO;
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)style {
    
    UIColor *color = [UIColor colorWithRed:24.0 / 255 green:75.0 / 255 blue:152.0 / 255 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    carbonTabSwipeNavigation.toolbar.translucent = NO;
    [carbonTabSwipeNavigation setIndicatorColor:color];
    [carbonTabSwipeNavigation setTabExtraWidth:30];
    // Custimize segmented control
    [carbonTabSwipeNavigation setNormalColor:[color colorWithAlphaComponent:0.6]
                                        font:[UIFont boldSystemFontOfSize:14]];
    [carbonTabSwipeNavigation setSelectedColor:color font:[UIFont boldSystemFontOfSize:14]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
                                 viewControllerAtIndex:(NSUInteger)index {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"ListRank" bundle: nil];
    switch (index) {
        case 0:
            return [UIStoryboard searchViewController];
            //return [mainStoryboard instantiateViewControllerWithIdentifier: @"ListRankView"];
        case 1:
            return [mainStoryboard instantiateViewControllerWithIdentifier: @"ListRankView"];
        case 2:
            return [mainStoryboard instantiateViewControllerWithIdentifier: @"ListRankView"];
        default:
            return [mainStoryboard instantiateViewControllerWithIdentifier: @"ListRankView"];
    }
}

// optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                 willMoveAtIndex:(NSUInteger)index {
    self.title = @"Home";
    
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
    NSLog(@"Did move at index: %ld", index);
    if (!(index == 0)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IndexViewController" object:[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    }
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

@end
