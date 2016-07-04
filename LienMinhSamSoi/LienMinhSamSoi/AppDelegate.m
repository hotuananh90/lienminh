//
//  AppDelegate.m
//  LienMinhSamSoi
//
//  Created by admin on 6/15/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "AppDelegate.h"
#import "DEMONavigationController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "Macro.h"
#import "UIStoryboard+Home.h"
@interface AppDelegate ()<REFrostedViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIFont *font = [UIFont systemFontOfSize:12];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:font}
                                             forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"line_bottom"]];
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] < 7) {
        [[UINavigationBar appearance] setTintColor:RGB(40, 92, 101)];
    } else {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [[UINavigationBar appearance] setBarTintColor:RGB(40, 92, 101)];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    gCheckFirtApp = YES;
    gDataChampion = [[NSMutableArray alloc]init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://na.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=all&api_key=%@",KEY_API];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        gVersion = [responseObject objectForKey:@"version"];
        NSDictionary *dic = [responseObject objectForKey:@"keys"];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistFile = @"Champion.plist";
        NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFile];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath: path])
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Champion" ofType:@"plist"];
            [fileManager copyItemAtPath:bundle toPath: path error:&error];
        }else{
            [fileManager removeItemAtPath:path error:NULL];
        }
        NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:path];
        [data addObject:dic];
        [data writeToFile: path atomically:YES];
        gDataChampion = data;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHAMPION object: nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    // Create content and menu controllers
    //
    HomeViewController *homeViewController = [UIStoryboard instantiateHomeViewController];
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:homeViewController];
    //MenuViewController *menuController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:Nil];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:Nil]];
    // Create frosted view controller
    //
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:navi];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    frostedViewController.menuViewSize = CGSizeMake(SCREEN_WIDTH_PORTRAIT/1.5, SCREEN_HEIGHT_PORTRAIT);
    // Make it a root controller
    //
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
