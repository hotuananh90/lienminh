//
//  DetailViewController.h
//  LienMinhSamSoi
//
//  Created by admin on 6/17/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoLListRankModel.h"

@interface DetailViewController : UIViewController
@property (nonatomic) LoLListRankModel *lolListRankModel;
@property (nonatomic) NSString *baseURL;
@end
