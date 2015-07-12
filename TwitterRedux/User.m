//
//  User.m
//  TwitterAPP
//
//  Created by kaden Chiang on 2015/7/4.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import "User.h"

@interface User()

@property (strong, nonatomic) NSDictionary *dictionary;

@end

@implementation User

- (id)initWithDictionary: (NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.profileBannerUrl = [dictionary valueForKey:@"profile_banner_url"];

        unsigned hexInt = 0;
        NSScanner *scanner = [NSScanner scannerWithString:[dictionary valueForKey:@"profile_background_color"]];
        [scanner scanHexInt:&hexInt];
        self.profileBackgroundColor = hexInt;
        
        self.tagline = dictionary[@"description"];
        self.statusesCount = [dictionary[@"statuses_count"] integerValue];
        self.friendsCount = [dictionary[@"friends_count"] integerValue];
        self.followersCount = [dictionary[@"followers_count"] integerValue];
    }
    return self;
}

static User *_currentUser = nil;
NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *)currentUser
{
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser
{
    _currentUser = currentUser;
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:Nil];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
