//
//  ViewController.h
//  TwitterRedux
//
//  Created by kaden Chiang on 2015/7/8.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface ViewController : UIViewController <UIGestureRecognizerDelegate, ListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIView *maskView;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@end

