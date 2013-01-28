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

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupAircraftHolders];

    
    [self.view addSubview:self.aircraftHolderView];
    
//    [self.view addSubview:self.operationPanelView];
//    
//    [self.view bringSubviewToFront:self.aircraftHolderView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setAircraftHolderView:nil];
    [self setOperationPanelView:nil];
    [self setAircraftHolderBkgd:nil];
    [self setOperationPanelBkgd:nil];
    [self setExitButton:nil];
    [self setSwitchButton:nil];
    [self setTool1Button:nil];
    [self setTool2Button:nil];
    [self setAttackButton:nil];
    [self setStatusView:nil];
    [self setTurnIndicatorImgView:nil];
    [self setTimeIndicatorImgView:nil];
    [self setTurnLabel:nil];
    [self setTurnTimeLabel:nil];
    [self setTotalTimeLabel:nil];
    [self setReadyButton:nil];
    [self setAircraftUpHolderImgView:nil];
    [self setAircraftDownHolderImgView:nil];
    [self setAircraftLeftHolderImgView:nil];
    [self setAircraftRightHolderImgView:nil];
    [self setSwipeGestureRecognizerUp:nil];
    [self setSwipeGestureRecognizerDown:nil];
    [super viewDidUnload];
}

#define kAlertViewTagExitLoseWarning        60

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewTagExitLoseWarning)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                // canceled, do nothing
            }
                break;
            case 1:
            {
                if ([self.operationDelegate respondsToSelector:@selector(userWantsToExit)])
                    [self.operationDelegate userWantsToExit];
                if ([self.viewDelegate respondsToSelector:@selector(userWantsToExit)])
                    [self.viewDelegate userWantsToExit];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - setup aircraft holders

- (void)setupAircraftHolders
{
    self.aircraftUpHolderImgView.direction = AircraftDirectionUp;
    self.aircraftDownHolderImgView.direction = AircraftDirectionDown;
    self.aircraftLeftHolderImgView.direction = AircraftDirectionLeft;
    self.aircraftRightHolderImgView.direction = AircraftDirectionRight;
    
    [self.aircraftUpHolderImgView setupRecognizersWithTarget:self pressSelector:@selector(pressedAircraftHolderImg:) panSelector:@selector(aircraftHolderDraging:)];
    [self.aircraftDownHolderImgView setupRecognizersWithTarget:self pressSelector:@selector(pressedAircraftHolderImg:) panSelector:@selector(aircraftHolderDraging:)];
    [self.aircraftLeftHolderImgView setupRecognizersWithTarget:self pressSelector:@selector(pressedAircraftHolderImg:) panSelector:@selector(aircraftHolderDraging:)];
    [self.aircraftRightHolderImgView setupRecognizersWithTarget:self pressSelector:@selector(pressedAircraftHolderImg:) panSelector:@selector(aircraftHolderDraging:)];
    
    self.aircraftUpHolderImgView.userInteractionEnabled = YES;
    self.aircraftDownHolderImgView.userInteractionEnabled = YES;
    self.aircraftLeftHolderImgView.userInteractionEnabled = YES;
    self.aircraftRightHolderImgView.userInteractionEnabled = YES;
}

#pragma mark - actions

- (void)pressedAircraftHolderImg:(UILongPressGestureRecognizer *)sender
{
    if ([self.viewDelegate respondsToSelector:@selector(pressedAircraftHolderImg:)])
        [self.viewDelegate pressedAircraftHolderImg:sender];
}

- (void)aircraftHolderDraging:(UIPanGestureRecognizer *)sender
{
    if ([self.viewDelegate respondsToSelector:@selector(aircraftHolderDraging:)])
        [self.viewDelegate aircraftHolderDraging:sender];
}

- (IBAction)actionReadyBtnClicked:(id)sender
{
//    AGameOrganizer *organizer = [AGameOrganizer sharedInstance];
//    NSNumber *nbrOfAircraftPlaced = [organizer.gameStatus valueForKey:kGameStatusAircraftPlaced];
//    if ([nbrOfAircraftPlaced intValue] >= 3)
//    {
        if ([self.operationDelegate respondsToSelector:@selector(userReadyPlacingAircrafts)])
            if ([self.operationDelegate userReadyPlacingAircrafts])
                [self switchViews];
//    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.swipeGestureRecognizerUp ||
        gestureRecognizer == self.swipeGestureRecognizerDown ||
        otherGestureRecognizer == self.swipeGestureRecognizerUp ||
        otherGestureRecognizer == self.swipeGestureRecognizerDown)
    {
        return NO;
    }
    return YES;
}

- (IBAction)actionExitBtnClicked:(id)sender
{
    AGameOrganizer *organizer = [AGameOrganizer sharedInstance];
    NSDictionary *beginEndStatus = nil;
    DICT_GET_OBJECT(organizer.gameStatus, beginEndStatus, kGameStatusBeginEndGame);
    if (beginEndStatus)
    {
        NSNumber *isGameOn = [beginEndStatus valueForKey:@"isGameOn"];
        if ([isGameOn boolValue])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALocalisedString(@"operation_panel_are_u_sure_exit")
                                                            message:ALocalisedString(@"operation_panel_exit_warning_lost_game")
                                                           delegate:self
                                                  cancelButtonTitle:ALocalisedString(@"cancel")
                                                  otherButtonTitles:ALocalisedString(@"yes"), nil];
            alert.tag = kAlertViewTagExitLoseWarning;
            [alert show];
            return;
        }
    }
    
    if ([self.operationDelegate respondsToSelector:@selector(userWantsToExit)])
        [self.operationDelegate userWantsToExit];
    if ([self.viewDelegate respondsToSelector:@selector(userWantsToExit)])
        [self.viewDelegate userWantsToExit];
}

- (IBAction)actionAttackBtnClicked:(id)sender
{
    if ([self.operationDelegate respondsToSelector:@selector(userPressedAttackButton)])
        [self.operationDelegate userPressedAttackButton];
}

- (IBAction)actionTool1BtnClicked:(id)sender
{
    if ([self.operationDelegate respondsToSelector:@selector(userPressedTool1Button)])
        [self.operationDelegate userPressedTool1Button];
}

- (IBAction)actionTool2BtnClicked:(id)sender
{
    if ([self.operationDelegate respondsToSelector:@selector(userPressedTool2Button)])
        [self.operationDelegate userPressedTool2Button];
}

- (IBAction)actionSwitchButtonClicked:(id)sender
{
    [self switchViews];
}

- (IBAction)actionSwipeView:(UISwipeGestureRecognizer *)sender
{
    AGameOrganizer *organizer = [AGameOrganizer sharedInstance];
    NSNumber *nbrOfAircraftPlaced = [organizer.gameStatus valueForKey:kGameStatusAircraftPlaced];
    if ([nbrOfAircraftPlaced intValue] >= 3)
    {
        if ([[self.view subviews] containsObject:self.aircraftHolderView])
        {
            if (sender.direction == UISwipeGestureRecognizerDirectionUp)
            {
                [self switchViews];
            }
        }
        else if ([[self.view subviews] containsObject:self.operationPanelView])
        {
            if (sender.direction == UISwipeGestureRecognizerDirectionDown)
            {
                [self switchViews];
            }
        }
        else
        {
            
        }
    }
}

- (void)switchViews
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4;
    animation.delegate = self;

    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"default"];
    animation.type = @"cube";

    if ([[self.view subviews] containsObject:self.aircraftHolderView])
    {
        animation.subtype = kCATransitionFromTop;
        
        [self.aircraftHolderView removeFromSuperview];
        [self.view addSubview:self.operationPanelView];
        
        [self.switchButton removeFromSuperview];
        self.switchButton.frame = CGRectMake(270, 0, 50, 50);
        [self.operationPanelView addSubview:self.switchButton];
    }
    else if ([[self.view subviews] containsObject:self.operationPanelView])
    {
        animation.subtype = kCATransitionFromBottom;
        
        [self.operationPanelView removeFromSuperview];
        [self.view addSubview:self.aircraftHolderView];
        
        if ([[self.aircraftHolderView subviews] containsObject:self.readyButton])
            [self.readyButton removeFromSuperview];
        
        [self.switchButton removeFromSuperview];
        self.switchButton.frame = CGRectMake(270, 0, 50, 50);
        [self.aircraftHolderView addSubview:self.switchButton];
        
        // adjust exit button
        self.exitButton.frame = CGRectMake(200, 0, 70, 50);
    }
    else
    {
        return;
    }
    
    [[self.view layer] addAnimation:animation forKey:@"switchView"];
}

/* Called when the animation begins its active duration. */
- (void)animationDidStart:(CAAnimation *)anim
{
    
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}
@end
