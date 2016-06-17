//
//  ListChampionViewController.m
//  LienMinhSamSoi
//
//  Created by admin on 6/16/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ListChampionViewController.h"
#import "ChampionCollectionViewCell.h"
#import "iOSLoLAPI.h"
#import "DEMONavigationController.h"
#import "UIImageView+AFNetworking.h"
#import <AFNetworking.h>
@interface ListChampionViewController ()
{
    UIButton *revealButton;
    NSString *version;
}
@property (weak, nonatomic) IBOutlet UICollectionView *championCollectionView;
@property (nonatomic) NSDictionary *dicChampion;
@end

@implementation ListChampionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTheme];
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://na.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=all&api_key=2112a619-bd40-4f33-a086-cb41d67c3423" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        _dicChampion = [responseObject objectForKey:@"keys"];
        version = [responseObject objectForKey:@"version"];
        [self.championCollectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)setTheme{
    revealButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    [revealButton setImage:[UIImage imageNamed:@"ic_Home.png"] forState:UIControlStateNormal];
    [revealButton addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:revealButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.dicChampion.allValues.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(65, 65);
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *xib = ChampionCollectionViewCellIdentifier;
    ChampionCollectionViewCell *cell = (ChampionCollectionViewCell *)[_championCollectionView dequeueReusableCellWithReuseIdentifier:xib forIndexPath:indexPath];
    [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/%@/img/champion/%@.png",version,self.dicChampion.allValues[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"img_list_placeholder"]];
    cell.nameLabel.text =self.dicChampion.allValues[indexPath.row];
    cell.nameLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    if (cell.selected) {
        cell.backgroundColor = [UIColor lightGrayColor]; // highlight selection
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor]; // Default color
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor whiteColor]; // Default color
}

@end
