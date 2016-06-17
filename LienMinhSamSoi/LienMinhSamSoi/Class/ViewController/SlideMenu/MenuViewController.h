//
//  MenuViewController.h
//  TMApp
//
//  Created by admin on 9/21/15.
//  Copyright (c) 2015 LongNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface MenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblMenu;
@property (strong, nonatomic)  UINavigationController* naviTabbar;
@end
