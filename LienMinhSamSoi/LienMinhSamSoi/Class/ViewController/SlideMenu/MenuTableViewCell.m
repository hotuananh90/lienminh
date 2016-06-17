//
//  MenuTableViewCell.m
//  TMApp
//
//  Created by admin on 9/21/15.
//  Copyright (c) 2015 LongNH. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.lblName.layer.cornerRadius = 5;
    //self.lblName.clipsToBounds = YES;
    self.lblName.layer.masksToBounds = NO;
    self.lblName.layer.shadowOffset = CGSizeMake(0, 0);
    self.lblName.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.lblName.layer.shadowRadius = 2.4f;
    self.lblName.layer.shadowOpacity = 2.4;
    //self.lblName.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.lblName.layer.bounds] CGPath];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
