//
//  ChampionCollectionViewCell.h
//  LienMinhSamSoi
//
//  Created by admin on 6/16/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ChampionCollectionViewCellIdentifier @"ChampionCollectionViewCell"
@interface ChampionCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
