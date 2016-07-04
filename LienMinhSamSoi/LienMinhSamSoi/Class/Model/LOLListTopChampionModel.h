//
//  LOLListTopChampionModel.h
//  LienMinhSamSoi
//
//  Created by tuan anh on 6/29/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LOLListTopChampionModel : NSObject
@property (strong , nonatomic) NSString * championId;
@property (strong , nonatomic) NSString * championLevel;
@property (strong , nonatomic) NSString * championPoints;
@property (strong , nonatomic) NSString * championPointsSinceLastLevel;
@property (strong , nonatomic) NSString * championPointsUntilNextLevel;
@property (strong , nonatomic) NSString * chestGranted;
@property (strong , nonatomic) NSString * lastPlayTime;
@property (strong , nonatomic) NSString * playerId;
@property (strong , nonatomic) NSString * tokensEarned;
@end
