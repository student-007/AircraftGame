//
//  AAppDelegate.h
//  Aircraft
//
//  Created by Yufei Lang on 12/21/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWelcomeScreenViewController.h"

@interface AAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

+ (AAppDelegate *)sharedInstance;

- (void)pushScreen:(UIViewController *)viewController animated:(BOOL)animated;
- (BOOL)popScreen:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popToScreen:(UIViewController *)viewController animated:(BOOL)animated;

@end
