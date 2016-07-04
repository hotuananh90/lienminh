//
//  DetailViewController.m
//  LienMinhSamSoi
//
//  Created by admin on 6/17/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DetailViewController.h"
#import "UIView+SwipeTableViewFrame.h"
#import "CustomSegmentControl.h"
#import "SwipeTableView.h"
#import "Macro.h"
#import "DetailTab1ViewController.h"
#import "DetailTab2ViewController.h"
#import "UIStoryboard+Home.h"
#import "LOLListTopChampionModel.h"

#define RGBColorAlpha(r,g,b,f)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:f]
@interface DetailViewController ()<SwipeTableViewDataSource,SwipeTableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) SwipeTableView * swipeTableView;
@property (nonatomic, assign) BOOL isJustOneKindOfClassView;
@property (nonatomic, assign) BOOL shouldHiddenNavigationBar;
@property (nonatomic, assign) BOOL shouldFitItemsContentSize;
@property (nonatomic, strong) UIImageView * tableViewHeader;
@property (nonatomic, strong) CustomSegmentControl * segmentBar;
@property (nonatomic, strong) NSString * actionIdentifier;
@property (nonatomic, strong) NSMutableArray * arrTopChampion;
@property (nonatomic) UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.actionIdentifier = @"shouldHidenNavigationBar";
    // back
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    // Do any additional setup after loading the view.
    [self setup];
    [self getdata];
}

- (void) getdata{
    _arrTopChampion = [[NSMutableArray alloc]init];
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@/topchampions?count=5&api_key=%@",self.baseURL,self.lolListRankModel.playerOrTeamId,KEY_API] ;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr = responseObject;
        for (NSDictionary *dic in arr) {
            LOLListTopChampionModel *champion = [[LOLListTopChampionModel alloc]init];
            champion.championId = [Validator getSafeString:dic[@"championId"]];
            champion.championLevel = [Validator getSafeString:dic[@"championLevel"]];
            champion.championPoints = [Validator getSafeString:dic[@"championPoints"]];
            champion.championPointsSinceLastLevel = [Validator getSafeString:dic[@"championPointsSinceLastLevel"]];
            champion.championPointsUntilNextLevel = [Validator getSafeString:dic[@"championPointsUntilNextLevel"]];
            champion.chestGranted = [Validator getSafeString:dic[@"chestGranted"]];
            champion.lastPlayTime = [Validator getSafeString:dic[@"lastPlayTime"]];
            champion.playerId = [Validator getSafeString:dic[@"playerId"]];
            champion.tokensEarned = [Validator getSafeString:dic[@"tokensEarned"]];
            [_arrTopChampion addObject:champion];
        }
        
        NSDictionary *dic = [gDataChampion objectAtIndex:0];
        LOLListTopChampionModel *champion = [_arrTopChampion objectAtIndex:0];
        NSArray *arrDic = [dic allKeys];
        for (NSString *name in arrDic) {
            if ([name isEqualToString:champion.championId]) {
                NSString *strchampion = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/img/champion/splash/%@_0.jpg",dic[name]];
                NSURLRequest *urlReques = [NSURLRequest requestWithURL:[NSURL URLWithString:strchampion]];
                __weak typeof(self) weakSelf = self;
                [self.imageView setImageWithURLRequest:urlReques placeholderImage:[UIImage imageNamed:@"img_list_placeholder"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                    weakSelf.imageView.image = image;
                    weakSelf.swipeTableView.swipeHeaderView = weakSelf.tableViewHeader;
                    [weakSelf.swipeTableView reloadData];
                    [SVProgressHUD dismiss];
                } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                    [SVProgressHUD dismiss];
                }];
                break;
            }
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
    
}



- (void)setup{
    self.swipeTableView = [[SwipeTableView alloc]initWithFrame:self.view.bounds];
    _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeTableView.delegate = self;
    _swipeTableView.dataSource = self;
    _swipeTableView.shouldAdjustContentSize = _shouldFitItemsContentSize;
    
    _swipeTableView.swipeHeaderBar = self.segmentBar;
    if (_shouldHiddenNavigationBar) {
        _swipeTableView.swipeHeaderTopInset = 0;
    }
    [self.view addSubview:_swipeTableView];
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(10, 0, 40, 40);
    back.top = _shouldHiddenNavigationBar?25:74;
    back.backgroundColor = RGBColorAlpha(10, 202, 0, 0.95);
    back.layer.cornerRadius = back.height/2;
    back.layer.masksToBounds = YES;
    back.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back setTitleColor:RGB(255, 255, 215) forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    // edge gesture
    [_swipeTableView.contentView.panGestureRecognizer requireGestureRecognizerToFail:self.screenEdgePanGestureRecognizer];
}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer {
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0) {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

#pragma mark -

- (void)setActionIdentifier:(NSString *)actionIdentifier {
    _actionIdentifier = actionIdentifier;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(_actionIdentifier) withObject:nil];
#pragma clang diagnostic pop
}

- (void)setIsJustOneKindOfClassView {
    _isJustOneKindOfClassView = YES;
}

- (void)setFitItemsContentSize {
    _shouldFitItemsContentSize = YES;
    _swipeTableView.shouldAdjustContentSize = _shouldFitItemsContentSize;
}

- (void)shouldHidenNavigationBar {
    _shouldHiddenNavigationBar = YES;
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Header & Bar

- (UIView *)tableViewHeader {
    if (nil == _tableViewHeader) {
        
        UIImage * headerImage = [UIImage imageNamed:@"onepiece_kiudai"];
        self.tableViewHeader = [[UIImageView alloc]initWithImage:self.imageView.image];
        _tableViewHeader.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * (headerImage.size.height/headerImage.size.width));
        _tableViewHeader.backgroundColor = [UIColor purpleColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 20)];
        label.text = self.lolListRankModel.playerOrTeamName;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [_tableViewHeader addSubview:label];
    }
    return _tableViewHeader;
}

- (CustomSegmentControl * )segmentBar {
    if (nil == _segmentBar) {
        self.segmentBar = [[CustomSegmentControl alloc]initWithItems:@[@"Item0",@"Item1",@"Item2"]];
        _segmentBar.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);
        _segmentBar.font = [UIFont systemFontOfSize:15];
        _segmentBar.textColor = RGB(100, 100, 100);
        _segmentBar.selectedTextColor = RGB(0, 0, 0);
        _segmentBar.backgroundColor = RGB(249, 251, 198);
        _segmentBar.selectionIndicatorColor = RGB(249, 104, 92);
        _segmentBar.selectedSegmentIndex = _swipeTableView.currentItemIndex;
        [_segmentBar addTarget:self action:@selector(changeSwipeViewIndex:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentBar;
}

- (void)changeSwipeViewIndex:(UISegmentedControl *)seg {
    [_swipeTableView scrollToItemAtIndex:seg.selectedSegmentIndex animated:NO];
}

#pragma mark - SwipeTableView M

- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return 3;
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    NSInteger numberOfRows = 10;
    if (_isJustOneKindOfClassView || _shouldFitItemsContentSize || _shouldHiddenNavigationBar) {
        // 重用
        if (nil == view) {
            DetailTab1ViewController * tableView = [[DetailTab1ViewController alloc]initWithFrame:swipeView.bounds style:UITableViewStylePlain];
            view = tableView;
        }
        if (index == 1 || index == 3) {
            numberOfRows = 5;
        }
        [view setValue:@(numberOfRows) forKey:@"numberOfRows"];
        [view setValue:@(index) forKey:@"itemIndex"];
        
    }else {
        // 混合的itemview只有同类型的item采用重用
        if (index == 0) {
            DetailTab1ViewController * tableView= [swipeView viewWithTag:1000];
            if (nil == tableView) {
                tableView = [[DetailTab1ViewController alloc]initWithFrame:swipeView.bounds style:UITableViewStylePlain];
                tableView.tag = 1000;
            }
            view = tableView;
        }else {
            DetailTab2ViewController * collectionView = [swipeView viewWithTag:1001];
            if (nil == collectionView) {
                collectionView = [[DetailTab2ViewController alloc]initWithFrame:swipeView.bounds style:UITableViewStylePlain];
                collectionView.tag = 1001;
            }
            view = collectionView;
        }
    }
    [view performSelector:@selector(reloadData)];
    return view;
}

- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    _segmentBar.selectedSegmentIndex = swipeView.currentItemIndex;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:_shouldHiddenNavigationBar animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak typeof(self) weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
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

@end
