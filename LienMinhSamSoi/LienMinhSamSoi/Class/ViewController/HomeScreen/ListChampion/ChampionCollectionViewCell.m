//
//  ChampionCollectionViewCell.m
//  LienMinhSamSoi
//
//  Created by admin on 6/16/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ChampionCollectionViewCell.h"
#import "Macro.h"

@implementation ChampionCollectionViewCell
- (void)layoutSubviews{
    [super layoutSubviews];
    dispatch_async (dispatch_get_main_queue(), ^{
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];
        self.nameLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self.bgView.layer setBorderWidth:1];
        [self.bgView.layer setBorderColor:RGB(146, 130, 88).CGColor];
    });
}
@end
