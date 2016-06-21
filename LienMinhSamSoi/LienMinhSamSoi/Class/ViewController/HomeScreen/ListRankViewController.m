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
#import "NIDropDown.h"

@interface ListRankViewController ()<NIDropDownDelegate>
{
    UIButton *revealButton;
    NIDropDown *dropDown;
}
@property (weak, nonatomic) IBOutlet UITableView *listRankTableview;
@property (nonatomic) NSMutableArray *arrRank;
@end

@implementation ListRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTheme];
    self.arrRank = [[NSMutableArray alloc]init];
    [self.listRankTableview setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    self.listRankTableview.estimatedRowHeight = 100;
    self.listRankTableview.rowHeight = UITableViewAutomaticDimension;
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"https://kr.api.pvp.net/api/lol/kr/v2.5/league/challenger?type=RANKED_SOLO_5x5&api_key=6de0d632-b5e0-4221-97de-c4156b3617d3";
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
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
        [self.listRankTableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
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
    [cell.avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.12.1/img/profileicon/%@.png",rank.playerOrTeamId]] placeholderImage:[UIImage imageNamed:@"img_list_placeholder"]];
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
    
}

- (IBAction)actionSearch:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Add Prospect", @"Product Knowledge", @"Business Knowledge",nil];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    if (sender.indexPath.row == 0) {
        
    }
    if (sender.indexPath.row == 1) {
        
    }
    if (sender.indexPath.row == 2) {
        
    }
    [self rel];
}

@end
