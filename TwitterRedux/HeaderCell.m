//
//  HeaderCell.m
//  TwitterRedux
//
//  Created by kaden Chiang on 2015/7/11.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import "HeaderCell.h"
#import <UIImageView+AFNetworking.h>
@interface HeaderCell ()


@property (weak, nonatomic) IBOutlet UIView *tweetsView;
@property (weak, nonatomic) IBOutlet UIView *followingView;
@property (weak, nonatomic) IBOutlet UIView *followersView;

@end

@implementation HeaderCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setWithUser:(User *)user
{
    NSString *imageUrl = [user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    [self.profileImage setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self.profileImage.layer setCornerRadius:3.0f];
    [self.profileImage setClipsToBounds:YES];
    [self.BackgroundImage setBackgroundColor:UIColorFromRGB(user.profileBackgroundColor)];
    [self.BackgroundImage setClipsToBounds:YES];
    if (user.profileBannerUrl != nil) {
        [self.BackgroundImage setImageWithURL:[NSURL URLWithString:user.profileBannerUrl]];
    }
    self.tweetsCountLabel.text = [NSString stringWithFormat:@"%ld", user.statusesCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%ld", user.friendsCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%ld", user.followersCount];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.followingView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.followingView.layer.borderWidth = 1.0f;
    self.followersView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.followersView.layer.borderWidth = 1.0f;
    self.tweetsView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tweetsView.layer.borderWidth = 1.0f;

    UIView *mask1 = [[UIView alloc] initWithFrame:CGRectMake(1, 1, ceilf(self.frame.size.width/3), self.tweetsView.frame.size.height - 1)];
    UIView *mask2 = [[UIView alloc] initWithFrame:CGRectMake(1, 1, ceilf(self.frame.size.width/3), self.tweetsView.frame.size.height - 1)];
    UIView *mask3 = [[UIView alloc] initWithFrame:CGRectMake(1, 1, ceilf(self.frame.size.width/3)-2 ,self.tweetsView.frame.size.height - 1)];
    mask1.backgroundColor = [UIColor blackColor];
    mask2.backgroundColor = [UIColor blackColor];
    mask3.backgroundColor = [UIColor blackColor];
    self.tweetsView.layer.mask = mask1.layer;
    self.followingView.layer.mask = mask2.layer;
    self.followersView.layer.mask = mask3.layer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
