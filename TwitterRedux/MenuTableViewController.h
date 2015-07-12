//
//  MenuTableViewController.h
//  TwitterRedux
//
//  Created by kaden Chiang on 2015/7/9.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "User.h"

@class MenuTableViewController;

@protocol MenuTableViewControllerDelegate <NSObject>

- (void) menuTableViewController: (MenuTableViewController *) menuTableViewController link:(NSString *)link;

@end

@interface MenuTableViewController : UITableViewController

@property (strong, nonatomic) User *user;
@property (weak, nonatomic) id<MenuTableViewControllerDelegate> delegate;

@end
