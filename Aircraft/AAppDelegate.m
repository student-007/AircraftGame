//
//  AAppDelegate.m
//  Aircraft
//
//  Created by Yufei Lang on 12/21/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AAppDelegate.h"

@implementation AAppDelegate

+ (AAppDelegate *)sharedInstance
{
    return (AAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)pushScreen:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:animated];
}

- (BOOL)popScreen:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.navigationController.topViewController == viewController)
    {
        [self.navigationController popViewControllerAnimated:animated];
        return YES;
    }
    return NO;
}

- (void)popToScreen:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController popToViewController:viewController animated:animated];
    // if the above method has system bug, use the following method [yufei]
//    return [self popToScreenFixed:viewController animated:animated];
}

- (BOOL)popToScreenFixed:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray *viewControllersOnStack = self.navigationController.viewControllers;
    
    NSUInteger index = [viewControllersOnStack indexOfObject:viewController];
    if (NSNotFound != index && index < [viewControllersOnStack count])
    {
        if (index < ([viewControllersOnStack count] - 1))
        {
            NSMutableArray *modifiedStack = [NSMutableArray arrayWithArray:viewControllersOnStack];
            // index is not the last object
            index++;
            NSRange popRange = NSMakeRange(index, [modifiedStack count] - index);
            [modifiedStack removeObjectsInRange:popRange];
            
            //setting view controllers directly as popToViewController: looks buggy
            [self.navigationController setViewControllers:modifiedStack animated:animated];
        }
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
#ifdef LITE_VERSION
    NSLog(@"lite version");
#elif PLUS_VERSION
    NSLog(@"plus version");
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    AWelcomeScreenViewController *welcomeScreenVC = [[AWelcomeScreenViewController alloc] initWithNibName:@"AWelcomeScreenViewController" bundle:nil];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:welcomeScreenVC];
    self.window.rootViewController = self.navigationController;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
