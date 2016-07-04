//
//  ListRankViewController.m
//  LienMinhSamSoi
//
//  Created by admin on 6/20/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ListRankViewController.h"
#import "ListRankTableViewCell.h"
#import "DEMONavigationController.h"
#import "LoLListRankModel.h"
#import "DetailViewController.h"
#import "UIStoryboard+Home.h"

@interface ListRankViewController ()
{
    UIButton *revealButton;
    NSString *baseUrl;
}
@property (weak, nonatomic) IBOutlet UITableView *listRankTableview;
@property (nonatomic) NSMutableArray *arrRank;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSString *strIndex;
@end

@implementation ListRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTheme];
    self.arrRank = [[NSMutableArray alloc]init];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.listRankTableview;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    [self.listRankTableview setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    self.listRankTableview.estimatedRowHeight = 100;
    self.listRankTableview.rowHeight = UITableViewAutomaticDimension;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"IndexViewController" object:nil];
}

- (void)loadData:(NSNotification *)notification {
    self.strIndex = notification.object;
    [self refreshData];
}

- (void)refreshData{
    [self.refreshControl endRefreshing];
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if ([_strIndex isEqualToString:@"1"]) {
        baseUrl = @"https://kr.api.pvp.net/api/lol/kr/";
    }else if ([_strIndex isEqualToString:@"2"]){
        baseUrl = @"https://na.api.pvp.net/api/lol/na/";
    }else{
        baseUrl = @"https://br.api.pvp.net/api/lol/br/";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@v2.5/league/challenger?type=RANKED_SOLO_5x5&api_key=%@",baseUrl,KEY_API] ;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.arrRank removeAllObjects];
        NSArray *arr = responseObject[@"entries"];
        for (NSDictionary *dic in arr) {
            LoLListRankModel *rank = [[LoLListRankModel alloc]init];
            rank.leaguePoints = [Validator getSafeString:dic[@"leaguePoints"]];
            rank.isFreshBlood = [Validator getSafeString:dic[@"isFreshBlood"]];
            rank.isHotStreak = [Validator getSafeString:dic[@"isHotStreak"]];
            rank.division = [Validator getSafeString:dic[@"division"]];
            rank.isInactive = [Validator getSafeString:dic[@"isInactive"]];
            rank.isVeteran = [Validator getSafeString:dic[@"isVeteran"]];
            rank.losses = [Validator getSafeString:dic[@"losses"]];
            rank.playerOrTeamName = [Validator getSafeString:dic[@"playerOrTeamName"]];
            rank.playerOrTeamId = [Validator getSafeString:dic[@"playerOrTeamId"]];
            rank.wins = [Validator getSafeString:dic[@"wins"]];
            [self.arrRank addObject:rank];
        }
        NSArray *sorted = [self.arrRank sortedArrayUsingComparator:^NSComparisonResult(id lhs, id rhs) {
            LoLListRankModel *p1 = lhs, *p2 = rhs;
            
            if ([p1.leaguePoints intValue] > [p2.leaguePoints intValue]) {
                return NSOrderedAscending;
            } else if ([p1.leaguePoints intValue] < [p2.leaguePoints intValue]) {
                return NSOrderedDescending;
            } return NSOrderedSame;
        }];
        
        self.arrRank = [NSMutableArray arrayWithArray:sorted];
        //        for (int i=0; i<self.arrRank.count; i++) {
        //            LoLListRankModel *rank = [self.arrRank objectAtIndex:i];
        //            AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        //            [manager1 GET:[NSString stringWithFormat:@"https://na.api.pvp.net/api/lol/na/v1.4/summoner/%@?api_key=b531556e-a9a8-48b8-9edb-46d9276a8cd8",rank.playerOrTeamId] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //                num = num +1;
        //                NSDictionary *dic = responseObject;
        //                NSString *asd = [dic.allKeys objectAtIndex:0];
        //                NSDictionary *dicarr = responseObject[asd];
        //                LoLListRankModel *rankID = [[LoLListRankModel alloc]init];
        //                rankID = rank;
        //                rankID.profileID = [Validator getSafeString:dicarr[@"profileIconId"]];
        //                [self.arrRank replaceObjectAtIndex:i withObject:rankID];
        //                if (num == sorted.count-1) {
        [SVProgressHUD dismiss];
        [self.listRankTableview reloadData];
        //                }
        //            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //                [SVProgressHUD dismiss];
        //            }];
        //        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IndexViewController" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTheme{
    revealButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    [revealButton setImage:[UIImage imageNamed:@"ic_Home.png"] forState:UIControlStateNormal];
    [revealButton addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:revealButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrRank.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ListRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListRank"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListRank" owner:self options:nil];
        cell = (ListRankTableViewCell*)[nib objectAtIndex:0];
    }
    LoLListRankModel *rank = [self.arrRank objectAtIndex:indexPath.row];
    [cell.avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.12.1/img/profileicon/%@.png",rank.profileID]] placeholderImage:[UIImage imageNamed:@"img_list_placeholder"]];
    cell.nameLabel.text = rank.playerOrTeamName;
    cell.winLabel.text = [NSString stringWithFormat:@"%@W",rank.wins];
    cell.loseLabel.text = [NSString stringWithFormat:@"%@L",rank.losses];
    cell.eloLabel.text = rank.leaguePoints;
    if (indexPath.row%2 == 0) {
        cell.backGroundCell.backgroundColor = RGB(90,90, 90);
    }else{
        cell.backGroundCell.backgroundColor = RGB(50, 50, 50);
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoLListRankModel *rank = [self.arrRank objectAtIndex:indexPath.row];
    DetailViewController *detail = [UIStoryboard instantiateDetailViewController];
    detail.lolListRankModel = rank;
    if ([_strIndex isEqualToString:@"1"]) {
        detail.baseURL = @"https://kr.api.pvp.net/championmastery/location/kr/player/";
    }else if ([_strIndex isEqualToString:@"2"]){
        detail.baseURL = @"https://na.api.pvp.net/championmastery/location/NA/player/";
    }else{
        detail.baseURL = @"https://br.api.pvp.net/championmastery/location/br/player/";
    }
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)actionSearch:(id)sender {
    
}


@end
