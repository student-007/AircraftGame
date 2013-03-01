//
//  AOperationPanelViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 1/14/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "AOperationPanelViewController.h"

#define kAircraftUpInHolderImgName      @"aircraftUpInHolder.png"
#define kAircraftDownInHolderImgName    @"aircraftDownInHolder.png"
#define kAircraftLeftInHolderImgName    @"aircraftLeftInHolder.png"
#define kAircraftRightInHolderImgName   @"aircraftRightInHolder.png"
#define kAircraftDottedImgName          @"aircraftDotted.png"

#define kTurnIndicatorCompetitorTurnImgName     @"turnIndicator_coffee.png"
#define kTurnIndicatorMyTurnImgName             @"turnIndicator_target.png"

@interface AOperationPanelViewController ()
{
    NSDate *_turnBeginTime;
    NSTimeInterval _userSpendTime;
    NSTimeInterval _competitorSpendTime;
    NSTimer *_updatePanelTimer;
    NSTimer *_blinkTimer;
}

- (void)setupAircraftHolders;
- (void)switchViews;
- (void)blinkTurnIndicator;
- (void)stopBlinkingTurnIndicator;
- (void)executeBlinkAnimation;

@end

@implementation AOperationPanelViewController

@synthesize viewDelegate = _viewDelegate;
@synthesize operationDelegate = _operationDelegate;

@synthesize aircraftHolderView = _aircraftHolderView;
@synthesize aircraftHolderBkgd = _aircraftHolderBkgd;
@synthesize operationPanelView = _operationPanelView;
@synthesize operationPanelBkgd = _operationPanelBkgd;
@synthesize statusView = _statusView;
@synthesize turnIndicatorImgView = _turnIndicatorImgView;
@synthesize timeIndicatorImgView = _timeIndicatorImgView;
@synthesize turnLabel = _turnLabel;
@synthesize turnTimeLabel = _turnTimeLabel;
@synthesize playTotalTimeLabel = _playTotalTimeLabel;

@synthesize swipeGestureRecognizerUp = _swipeGestureRecognizerUp;
@synthesize swipeGestureRecognizerDown = _swipeGestureRecognizerDown;
// aircraft holders
@synthesize aircraftUpHolderImgView = _aircraftUpHolderImgView;
@synthesize aircraftDownHolderImgView = _aircraftDownHolderImgView;
@synthesize aircraftLeftHolderImgView = _aircraftLeftHolderImgView;
@synthesize aircraftRightHolderImgView = _aircraftRightHolderImgView;

@synthesize readyButton = _readyButton;
@synthesize exitButton = _exitButton;
@synthesize switchButton = _switchButton;
@synthesize tool1Button = _tool1Button;
@synthesize tool2Button = _tool2Button;
@synthesize attackButton = _attackButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userSpendTime = 0;
        _competitorSpendTime = 0;
    }
    return self;
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupAircraftHolders];

    [self.view addSubview:self.aircraftHolderView];   
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
    [self setReadyButton:nil];
    [self setAircraftUpHolderImgView:nil];
    [self setAircraftDownHolderImgView:nil];
    [self setAircraftLeftHolderImgView:nil];
    [self setAircraftRightHolderImgView:nil];
    [self setSwipeGestureRecognizerUp:nil];
    [self setSwipeGestureRecognizerDown:nil];
    [self setPlayTotalTimeLabel:nil];
    [super viewDidUnload];
}

- (NSTimeInterval)userSpendTime
{
    return _userSpendTime;
}

- (NSTimeInterval)competitorSpendTime
{
    return _competitorSpendTime;
}

- (void)startTheGame
{
//    _userSpendTime = 0;
//    _competitorSpendTime = 0;
    [self switchTurn];
    _updatePanelTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateStatusPanel) userInfo:nil repeats:YES];
}

/*!
 @discussion stop timeing the time
 */
- (void)endTheGame
{
    [_updatePanelTimer invalidate];
#warning TODO: collect timing information and save them to a dictionary
}

- (void)switchTurn
{
    AWhosTurn who = [AGameOrganizer sharedInstance].whosTurn;
    _turnBeginTime = [NSDate date];
    
    switch (who)
    {
        case AWhosTurnCompetitor:
        {
            [self stopBlinkingTurnIndicator];
            [self.turnIndicatorImgView setImage:[UIImage imageNamed:kTurnIndicatorCompetitorTurnImgName]];
            self.turnLabel.text = ALocalisedString(@"operation_panel_competitor_turn_to_attack");
        }
            break;
        case AWhosTurnUser:
        {
            [self.turnIndicatorImgView setImage:[UIImage imageNamed:kTurnIndicatorMyTurnImgName]];
            [self blinkTurnIndicator];
            self.turnLabel.text = ALocalisedString(@"operation_panel_my_turn_to_attack");
        }
            break;
        case AWhosTurnNone:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)loadDataFromGameRecord:(ASavedGameRecord *)gameRecord sentBy:(AUserType)userType
{
    switch (userType)
    {
        case AUserTypeUser:
        {
            _userSpendTime = [gameRecord.selfTotalTimeSec doubleValue];
            _competitorSpendTime = [gameRecord.enemyTotalTimeSec doubleValue];
        }
            break;
        case AUserTypeOpponent:
        {
            _userSpendTime = [gameRecord.enemyTotalTimeSec doubleValue];
            _competitorSpendTime = [gameRecord.selfTotalTimeSec doubleValue];
        }
            break;
        case AUserTypeNone:
        {
            _userSpendTime = 0;
            _competitorSpendTime = 0;
        }
            break;
        default:
            break;
    }
}

- (void)blinkTurnIndicator
{
    _blinkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(executeBlinkAnimation) userInfo:nil repeats:YES];
}

- (void)stopBlinkingTurnIndicator
{
    [_blinkTimer invalidate];
    [self.turnIndicatorImgView.layer removeAnimationForKey:@"blinkTarget"];
    self.turnIndicatorImgView.alpha = 1;
}

- (void)executeBlinkAnimation
{
    [UIView beginAnimations:@"blinkTarget" context:NULL];
    [UIView setAnimationDuration:1.0f];
    self.turnIndicatorImgView.alpha = self.turnIndicatorImgView.alpha > 0 ? 0 : 1;
    [UIView commitAnimations];
}

- (void)updateStatusPanel
{
    AWhosTurn who = [AGameOrganizer sharedInstance].whosTurn;
    
    NSString *turnTimeString = [NSString timeFormatStringFromTimeInterval:[_turnBeginTime timeIntervalSinceNow]];
    NSString *playerTimeString;
    switch (who)
    {
        case AWhosTurnCompetitor:
        {
            _competitorSpendTime ++;
            playerTimeString = [NSString timeFormatStringFromTimeInterval:_competitorSpendTime];
        }
            break;
        case AWhosTurnUser:
        {
            _userSpendTime++;
            playerTimeString = [NSString timeFormatStringFromTimeInterval:_userSpendTime];
        }
            break;
        case AWhosTurnNone:
        {
            
        }
            break;
        default:
            break;
    }
    
    self.turnTimeLabel.text = [NSString stringWithFormat:@"%@", turnTimeString];
    self.playTotalTimeLabel.text = [NSString stringWithFormat:@"%@", playerTimeString];
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
    [self.aircraftUpHolderImgView setImage:[UIImage imageNamed:kAircraftUpInHolderImgName]];
    [self.aircraftDownHolderImgView setImage:[UIImage imageNamed:kAircraftDownInHolderImgName]];
    [self.aircraftLeftHolderImgView setImage:[UIImage imageNamed:kAircraftLeftInHolderImgName]];
    [self.aircraftRightHolderImgView setImage:[UIImage imageNamed:kAircraftRightInHolderImgName]];
    
    self.aircraftDownHolderImgView.transform = CGAffineTransformMakeRotation(M_PI);
    self.aircraftLeftHolderImgView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.aircraftRightHolderImgView.transform = CGAffineTransformMakeRotation(M_PI_2);
    
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
        self.switchButton.frame = CGRectMake(294, 10, 30, 30);
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
        self.switchButton.frame = CGRectMake(294, 10, 30, 30);
        [self.aircraftHolderView addSubview:self.switchButton];
        
        // adjust exit button
        self.exitButton.frame = CGRectMake(200, 0, 50, 50);
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
