//
//  CollectionReusableView.m
//  LienMinhSamSoi
//
//  Created by tuan anh on 6/27/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView

- (IBAction)searchAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(searhActionReusbleView:)]) {
        [self.delegate searhActionReusbleView:self.nameTextField.text];
    }
}
@end
