//
//  listViewController.h
//  TwitterRedux
//
//  Created by kaden Chiang on 2015/7/9.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableViewController.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "HeaderCell.h"
#import "TweetCell.h"

@class ListViewController;

@protocol ListViewControllerDelegate <NSObject>

- (void)triggerMenuBtn;

@end


@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MenuTableViewControllerDelegate, TweetCellDelegate,TweetViewControllerDelegate,ComposeViewControllerDelegate>

@property (nonatomic, strong) id<ListViewControllerDelegate> delegate;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

@end
