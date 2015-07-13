//
//  MenuTableViewController.m
//  TwitterRedux
//
//  Created by kaden Chiang on 2015/7/9.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import "MenuTableViewController.h"
#import <UIImageView+AFNetworking.h>

@interface MenuTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWithUser:[User currentUser]];
}

- (void)setWithUser: (User *)user
{
    if (user != nil) {
        self.user = user;
        [self.loginBtn setTitle:@"Logout" forState:UIControlStateNormal];
        NSString *imageUrl = [self.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        [self.profileImage setImageWithURL:[NSURL URLWithString:imageUrl]];
        [self.profileImage.layer setCornerRadius:3.0f];
        [self.profileImage setClipsToBounds:YES];
        [self.nameLabel setText:self.user.name];
        [self.screenNameLabel setText:[NSString stringWithFormat:@"@%@", self.user.screenName ]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    if (self.user == nil) {
        [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
            if (user != nil) {
                [self setWithUser:user];
                [self.delegate menuTableViewController:self link:@"timeline" userId: nil];
                [self.tableView reloadData];
            } else {
                NSLog(@"Fail to get request token: %@", [error localizedDescription]);
            }
        }];
    } else {
        self.user = nil;
        [User setCurrentUser:nil];
        [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
        [self.loginBtn setTitle:@"Login" forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.user == nil) {
        return 2;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((self.user == nil) && (indexPath.row == 1)) {
        return [super tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    }

    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
//        NSLog(@"setSeparatorInset");
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//        [cell preservesSuperviewLayoutMargins: NO];
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth(cell.bounds)/2.0, 0, CGRectGetWidth(cell.bounds)/2.0)];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row == 0) || (indexPath.row == 5)) {
        return nil;
    } else {
        return indexPath;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( ((self.user == nil) && (indexPath.row == 1))
        || ((self.user != nil) && (indexPath.row == 4))) {
        return 1024.f;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( ((self.user == nil) && (indexPath.row == 1))
        || ((self.user != nil) && (indexPath.row == 4))) {
        return 1024.f;
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.user != nil) {
        if (indexPath.row == 1) {
            [self.delegate menuTableViewController:self link:@"user" userId: nil];
        } else if (indexPath.row == 2) {
            [self.delegate menuTableViewController:self link:@"timeline" userId: nil];
        } else if (indexPath.row == 3) {
            [self.delegate menuTableViewController:self link:@"mentions" userId: nil];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
