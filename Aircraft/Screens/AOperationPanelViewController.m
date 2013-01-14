//
//  AOperationPanelViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 1/14/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "AOperationPanelViewController.h"

@interface AOperationPanelViewController ()

@end

@implementation AOperationPanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//CATransition *animation = [CATransition animation];
//animation.duration = 0.4;
//    animation.delegate = self;
//    /* Delegate methods for CAAnimation. */
//    @interface NSObject (CAAnimationDelegate)
//    /* Called when the animation begins its active duration. */
//    - (void)animationDidStart:(CAAnimation *)anim;
//
//    /* Called when the animation either completes its active duration or
//     * is removed from the object it is attached to (i.e. the layer). 'flag'
//     * is true if the animation reached the end of its active duration
//     * without being removed. */
//    - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
//animation.timingFunction = [CAMediaTimingFunction functionWithName:@"default"];
//animation.type = @"cube";
//animation.subtype = _flag?kCATransitionFromBottom:kCATransitionFromTop;
//[self.container exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
//[[self.container layer] addAnimation:animation forKey:@"animation"];
//_flag = !_flag;

@end
