//
//  ListRankTableViewCell.m
//  LienMinhSamSoi
//
//  Created by admin on 6/20/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ListRankTableViewCell.h"

@implementation ListRankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    dispatch_async (dispatch_get_main_queue(), ^{
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];
        [self.backGroundCell.layer setCornerRadius:4];
    });
}
@end
