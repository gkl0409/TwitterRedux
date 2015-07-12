//
//  ViewController.m
//  TwitterRedux
//
//  Created by kaden Chiang on 2015/7/8.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import "ViewController.h"
#import "ListViewController.h"
#import "MenuTableViewController.h"

const float MASK_ALPHA_MAX=0.6;

@interface ViewController ()

@property CGPoint pointStart;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    ListViewController *listVC = [self.childViewControllers[0] childViewControllers][0];
    MenuTableViewController *menuVC = self.childViewControllers[1];
    menuVC.delegate = listVC;
    [menuVC.delegate menuTableViewController:menuVC link:@"timeline"];
    
//    for (UIViewController *vc in self.childViewControllers) {
//        NSLog(@"%@", NSStringFromClass(vc.class));
//    }
//    NSLog(@"%@", NSStringFromClass([[self.childViewControllers[0] childViewControllers][0] class]));

}

- (void)viewDidAppear:(BOOL)animated
{
    MenuTableViewController *menuVC = self.childViewControllers[1];
    if (menuVC.user == nil) {
        [self triggerMenuBtn];
    }

}

- (void)triggerMenuBtn
{
    CGRect frame = self.containerView.frame;
    CGRect mainFrame = self.mainView.frame;
    if (frame.origin.x < 0) {
        NSLog(@"add mask view");
//        [self.view addSubview:self.maskView];
    }
    [UIView animateWithDuration:0.2 animations:^{
        if (frame.origin.x < 0) {
            self.containerView.frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
            self.mainView.frame = CGRectMake(frame.size.width, mainFrame.origin.y, mainFrame.size.width, mainFrame.size.height);
            self.maskView.frame = CGRectMake(frame.size.width, mainFrame.origin.y+44, mainFrame.size.width, mainFrame.size.height-44);
            [self.maskView setAlpha:MASK_ALPHA_MAX];
        } else {
            self.containerView.frame = CGRectMake(-frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
            self.mainView.frame = CGRectMake(0, mainFrame.origin.y, mainFrame.size.width, mainFrame.size.height);
            self.maskView.frame = CGRectMake(0, mainFrame.origin.y+44, mainFrame.size.width, mainFrame.size.height-44);
            [self.maskView setAlpha:0.0f];
        }
    } completion:^(BOOL finished) {
        if (frame.origin.x >= 0) {
//            [self.maskView removeFromSuperview];
        }
    }];
}

- (void)onPan:(UIPanGestureRecognizer *)recognizer
{
    CGRect frame = self.containerView.frame;
    CGRect mainFrame = self.mainView.frame;
    CGRect maskFrame = self.maskView.frame;
    CGPoint point = [recognizer translationInView:self.view];

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.pointStart = point;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (frame.origin.x + point.x - self.pointStart.x <= 0 && frame.origin.x + point.x - self.pointStart.x >= -frame.size.width) {
            frame.origin.x += point.x - self.pointStart.x;
            mainFrame.origin.x += point.x - self.pointStart.x;
            maskFrame.origin.x += point.x - self.pointStart.x;
            self.containerView.frame = frame;
            self.mainView.frame = mainFrame;
            self.maskView.frame = maskFrame;
            self.pointStart = point;
            [self.maskView setAlpha:MASK_ALPHA_MAX*((frame.size.width + frame.origin.x)/frame.size.width)];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            if (frame.size.width + frame.origin.x > frame.size.width/2) {
                self.containerView.frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
                self.mainView.frame = CGRectMake(frame.size.width, mainFrame.origin.y, mainFrame.size.width, mainFrame.size.height);
                self.maskView.frame = CGRectMake(frame.size.width, mainFrame.origin.y+44, mainFrame.size.width, mainFrame.size.height-44);
                [self.maskView setAlpha:MASK_ALPHA_MAX];
            } else {
                self.containerView.frame = CGRectMake(-frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
                self.mainView.frame = CGRectMake(0, mainFrame.origin.y, mainFrame.size.width, mainFrame.size.height);
                self.maskView.frame = CGRectMake(0, mainFrame.origin.y+44, mainFrame.size.width, mainFrame.size.height-44);
                [self.maskView setAlpha:0];
            }
        }];
    }
    
}
                                 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
