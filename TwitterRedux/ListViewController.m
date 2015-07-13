//
//  listViewController.m
//  TwitterRedux
//
//  Created by kaden Chiang on 2015/7/9.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import "ListViewController.h"
#import "ViewController.h"
#import "Tweet.h"
#import "User.h"
#import "TwitterClient.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"

@interface ListViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, assign) NSUInteger tweetsOffset;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSIndexPath *seletedIndexPath;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    ViewController *viewController = (ViewController *)[[self parentViewController] parentViewController];
    self.delegate = viewController;
    
    UIImage *menuImage = [[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn setFrame: CGRectMake(0, 0, 22, 22)];
    [menuBtn setImage:menuImage forState:UIControlStateNormal];
    [menuBtn setTintColor: [UIColor whiteColor]];
    [menuBtn addTarget:self action:@selector(delegateTriggerMenuBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem = barBtnItem;

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.refreshControl addTarget:self action:@selector(bindTweets)  forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

- (IBAction)onNew:(id)sender {
    if (self.user == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Login" message: @"please login first!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
    } else {
        // sender replyTweetId
        [self performSegueWithIdentifier:@"segueCompose" sender:nil];
    }
}

-(void)delegateTriggerMenuBtn
{
    [self.delegate triggerMenuBtn];
}

- (void)menuTableViewController:(MenuTableViewController *)menuTableViewController link:(NSString *)link userId:(NSString *)userId
{
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    if (menuTableViewController.user == nil) {
        [self.delegate triggerMenuBtn];
        return;
    }
        
//    if ([link isEqualToString:self.link]) {
//        [self.delegate triggerMenuBtn];        
//        return;
//    }

    self.link = link;
    self.user = menuTableViewController.user;
    if ([self.link isEqualToString:@"user"]) {
        self.tweetsOffset = -1;
    } else {
        self.tweetsOffset = 0;
    }
    
    if ([self.link isEqualToString:@"user"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"@%@", self.user.screenName];
    } else {
        self.navigationItem.title = link;
    }
    [self bindTweetsWithUserId:nil];

    [self.delegate triggerMenuBtn];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
}

- (void) touchProfileImage:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    Tweet *tweet = (Tweet *)self.tweets[gesture.view.tag];

    self.link = @"user";
    self.user = tweet.user;
    self.tweetsOffset = -1;
    self.navigationItem.title = [NSString stringWithFormat:@"@%@", self.user.screenName];
    [self bindTweetsWithUserId:self.user.userId];
}

- (void)bindTweets
{
    [self bindTweetsWithUserId:nil];
}

- (void)bindTweetsWithUserId:(NSString *)userId
{
    NSLog(@"userId: %@", userId);
    NSString *apiUrl;
    if ([self.link isEqualToString:@"timeline"]) {
        apiUrl = @"1.1/statuses/home_timeline.json";
    } else if ([self.link isEqualToString:@"user"]){
        apiUrl = @"1.1/statuses/user_timeline.json";
        if (userId != nil) {
            apiUrl = [NSString stringWithFormat:@"%@?user_id=%@", apiUrl, userId];
            NSLog(@"usl: %@", apiUrl);
        }
    } else if ([self.link isEqualToString:@"mentions"]){
        apiUrl = @"1.1/statuses/mentions_timeline.json";
    }
    
    [[TwitterClient sharedInstance] GET:apiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        self.tweets = [NSMutableArray arrayWithArray:[Tweet tweetsWithArray:responseObject]];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"faill to load timeline: %@", [error localizedDescription]);
    }];
}

- (void)tweetCell:(TweetCell *)cell replyTweetId:(NSString *)tweetId
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self performSegueWithIdentifier:@"segueCompose" sender:indexPath];
}

- (void)tweetCell:(TweetCell *)cell didUpdateTweet:(Tweet *)tweet
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tweets replaceObjectAtIndex:indexPath.row withObject:tweet];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tweetViewController:(TweetViewController *)viewController didUpdateTweet:(Tweet *)tweet
{
    if ([self.link isEqualToString:@"mentions"]) return;

    [self.tweets replaceObjectAtIndex:self.seletedIndexPath.row+self.tweetsOffset withObject:tweet];
    [self.tableView reloadRowsAtIndexPaths:@[self.seletedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)composeViewController:(ComposeViewController *)viewController composedTweet:(Tweet *)tweet
{
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.link isEqualToString:@"user"]) return [self.tweets count] + 1;
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.link isEqualToString:@"user"] && (indexPath.row == 0)) {
        HeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        [cell setWithUser:self.user];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins: NO];
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth(cell.bounds)/2.0, 0, CGRectGetWidth(cell.bounds)/2.0)];
        return cell;
    }
    TweetCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.delegate = self;
    [cell setWithTweet: self.tweets[indexPath.row+self.tweetsOffset]];
    [cell setSeparatorInset:UIEdgeInsetsZero];

    [cell.profileImageView setUserInteractionEnabled:YES];
    cell.profileImageView.tag = indexPath.row+self.tweetsOffset;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchProfileImage:)];
    [tapped setNumberOfTapsRequired:1];
    [cell.profileImageView addGestureRecognizer:tapped];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.link isEqualToString:@"user"] && (indexPath.row == 0)) {
        // do noting
    } else {
        self.seletedIndexPath = indexPath;
        [self performSegueWithIdentifier:@"segueTweet" sender:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.link isEqualToString:@"user"] && (indexPath.row == 0)) {
        return nil;
    } else {
        return indexPath;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    if ([[segue identifier] isEqualToString:@"segueTweet"]) {
        TweetViewController *vc = (TweetViewController *)[segue destinationViewController];
        vc.delegate = self;
        
        vc.tweet = self.tweets[indexPath.row+self.tweetsOffset];
    } else if ([[segue identifier] isEqualToString:@"segueCompose"]) {
        UINavigationController *nvc = (UINavigationController *)[segue destinationViewController];
        ComposeViewController *vc = (ComposeViewController *)nvc.viewControllers[0];
        vc.delegate = self;
        vc.user = self.user;
        if (indexPath != nil) {
            vc.inReplyToStatusId = [self.tweets[indexPath.row+self.tweetsOffset] tweetId];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
