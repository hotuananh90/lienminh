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
#import "CarbonKit.h"
#import "ListRankViewController.h"
#import "CollectionReusableView.h"

@interface ViewController ()<CollectionReusableViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *accountCollection;
@property (nonatomic) NSDictionary *dicAccount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.dicAccount.allKeys.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionReusableView *header = nil;
    
    if ([kind isEqual:UICollectionElementKindSectionHeader])
    {
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                    withReuseIdentifier:@"HeaderView"
                                                           forIndexPath:indexPath];
        
        
    }
    header.delegate = self;
    return header;
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

- (void)searhActionReusbleView:(NSString *)text{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/%@?api_key=2112a619-bd40-4f33-a086-cb41d67c3423",text];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        self.dicAccount = responseObject;
        [self.accountCollection reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
