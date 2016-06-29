//
//  CollectionReusableView.h
//  LienMinhSamSoi
//
//  Created by tuan anh on 6/27/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionReusableViewDelegate <NSObject>

@optional
- (void)searhActionReusbleView:(NSString *)text;
@end

@interface CollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) id<CollectionReusableViewDelegate> delegate;
@end
