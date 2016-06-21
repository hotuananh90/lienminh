//
//  ViewController.m
//  TMApp
//
//  Created by LongNH on 9/18/15.
//  Copyright (c) 2015 LongNH. All rights reserved.
//

#import "ViewController.h"
#import "Macro.h"
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
#import "MHTabBarController.h"

@interface ViewController ()<REFrostedViewControllerDelegate>
{
    UIButton *revealButton;
}

@property (weak, nonatomic) IBOutlet UICollectionView *accountCollection;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (nonatomic) NSDictionary *dicAccount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTheme];
}

- (void)setTheme{
    revealButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    [revealButton setImage:[UIImage imageNamed:@"ic_Home.png"] forState:UIControlStateNormal];
    [revealButton addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:revealButton];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchAction:(id)sender {
    if (self.nameTextField.text.length >0) {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *url = [NSString stringWithFormat:@"https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/%@?api_key=2112a619-bd40-4f33-a086-cb41d67c3423",self.nameTextField.text];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            self.dicAccount = responseObject;
            [self.accountCollection reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.dicAccount.allKeys.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *xib = ChampionCollectionViewCellIdentifier;
    ChampionCollectionViewCell *cell = (ChampionCollectionViewCell *)[_accountCollection dequeueReusableCellWithReuseIdentifier:xib forIndexPath:indexPath];
    NSDictionary *dic = [self.dicAccount objectForKey:self.dicAccount.allKeys[indexPath.row]];
    [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.12.1/img/profileicon/%@.png",[dic objectForKey:@"profileIconId"]]] placeholderImage:[UIImage imageNamed:@"img_list_placeholder"]];
    cell.nameLabel.text =self.dicAccount.allKeys[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *home = [UIStoryboard instantiateDetailViewController];
    home.title = @"概要";
    [self.navigationController pushViewController:home animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor whiteColor]; // Default color
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0, 0, 0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
