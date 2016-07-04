//
//  MenuViewController.m
//  TMApp
//
//  Created by admin on 9/21/15.
//  Copyright (c) 2015 LongNH. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "MenuTableViewCell.h"
#import "ViewController.h"
#import "DEMONavigationController.h"
#import "REFrostedViewController.h"
#import "Macro.h"
#import "ListChampionViewController.h"
#import "UIStoryboard+Home.h"
#import "ListRankViewController.h"

@interface MenuViewController ()<REFrostedViewControllerDelegate>
{
    NSMutableArray *arrMenu;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH_PORTRAIT/3-20, 7, 120, 30)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)];
    label.text = @"Menu";
    [self.navigationController.navigationBar addSubview:label];
    arrMenu = [[NSMutableArray alloc]init];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tblMenu reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = (MenuTableViewCell*)[nib objectAtIndex:0];
    }
    NSArray *titles = @[@"Home", @"Danh sách tướng", @"Chats"];
    cell.lblName.text = titles[indexPath.row];
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = RGB(218, 218, 218);
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        ViewController *homeViewController = [UIStoryboard instantiateHomeViewController];
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:homeViewController];
        self.frostedViewController.contentViewController = navigationController;
    } else if(indexPath.row == 1){
        ListChampionViewController *ListChampion = [UIStoryboard ListChampionViewController];
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:ListChampion];
        self.frostedViewController.contentViewController = navigationController;
    }else if(indexPath.row == 2){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"ListRank" bundle: nil];
        ListChampionViewController *controller = (ListChampionViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ListRankView"];
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:controller];
        self.frostedViewController.contentViewController = navigationController;
    }
    
    [self.frostedViewController hideMenuViewController];
}
@end
