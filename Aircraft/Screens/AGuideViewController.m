//
//  AGuideViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-6.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "AGuideViewController.h"
#import "ASetting.h"

@interface AGuideViewController()
{
    UIImageView *_handImgView;
    CGRect _handFrameA;
    CGRect _handFrameB;
    NSTimer *_handMovingTimer;
}

- (void)addDotNotShowAgainView;
- (void)loadViewBasedOnType;
- (void)startHandMovingAnimation;
- (void)moveHandAnimation;
@end

@implementation AGuideViewController

#define kPlayScreenGuideImgName         @"playScreenGuideBkg.png"
#define kPlaceAircraftGuideImgName      @"placeAircraftGuideBkg.png"
#define kHandImgName                    @"hand.png"
#define kHandMovingTime                 1.8

@synthesize delegate = _delegate;
@synthesize type = _type;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize descLabel = _descLabel;
@synthesize descPressReady = _descPressReady;
@synthesize doNotShowAgainLabel = _doNotShowAgainLabel;
@synthesize battleBeginsTryShootLabel = _battleBeginsTryShootLabel;
@synthesize destoryToWinLabel = _destoryToWinLabel;
@synthesize doNotShowAgainCheckBoxBtn = _doNotShowAgainCheckBoxBtn;
@synthesize doNotShowAgainBkgImageView = _doNotShowAgainBkgImageView;
@synthesize doNotShowAgainView = _doNotShowAgainView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        _type = AGuideTypeNone;
        _handFrameA = CGRectMake(110.0f, 160.0f, 88.0f, 70.0f);
        _handFrameB = CGRectMake(110.0f, 325.0f, 88.0f, 70.0f);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [self loadViewBasedOnType];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    [self.doNotShowAgainBkgImageView setImage:[UIImage imageForBlackRectBackground]];
    self.doNotShowAgainLabel.text = ALocalisedString(@"do_not_show_this_again");
}

- (void)viewDidUnload
{
    [self setTapGestureRecognizer:nil];
    [self setDescLabel:nil];
    [self setDescPressReady:nil];
    [self setDoNotShowAgainView:nil];
    [self setDoNotShowAgainLabel:nil];
    [self setDoNotShowAgainCheckBoxBtn:nil];
    [self setDoNotShowAgainBkgImageView:nil];
    [self setBattleBeginsTryShootLabel:nil];
    [self setDestoryToWinLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - load guide views

- (void)loadViewBasedOnType
{
    switch (_type) 
    {
        case AGuideTypeNone:
        {
            if ([self.delegate respondsToSelector:@selector(dismissTheGuideView)]) 
                [self.delegate dismissTheGuideView];
        }
            break;
        case AGuideTypePlaceAircraft:
        {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kPlaceAircraftGuideImgName]];
            imgView.backgroundColor = [UIColor clearColor];
            imgView.frame = self.view.frame;
            
            CGRect tempFrame = self.descLabel.frame;
            tempFrame.origin = CGPointMake(29.0f, 50.0f);
            self.descLabel.frame = tempFrame;
            self.descLabel.text = ALocalisedString(@"drag_to_place_aircraft_tip");
            
            tempFrame = self.descPressReady.frame;
            tempFrame.origin.x = 150.0;
            tempFrame.origin.y = 300.0;
            self.descPressReady.frame = tempFrame;
            self.descPressReady.alpha = 0;
            self.descPressReady.text = ALocalisedString(@"press_done_after_placing_aircraft_tip");
            
            
            
            [self.view addSubview:imgView];
            [self.view addSubview:_descLabel];
            [self.view addSubview:self.descPressReady];
            [self addDotNotShowAgainView];
            
            [self startHandMovingAnimation];
        }
            break;
        case AGuideTypePlayScreen:
        {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kPlayScreenGuideImgName]];
            imgView.backgroundColor = [UIColor clearColor];
            imgView.frame = self.view.frame;
            
            [self.view addSubview:imgView];
        }
            break;
        case AGuideTypeAttackPlayTip:
        {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageForDarkGuideBackground]];
            imgView.backgroundColor = [UIColor clearColor];
            imgView.frame = self.view.frame;
            
            self.battleBeginsTryShootLabel.text = ALocalisedString(@"battle_begins_try_shoot");
            self.battleBeginsTryShootLabel.center = CGPointMake(self.view.center.x, 100);
            
            self.destoryToWinLabel.text = ALocalisedString(@"destory_to_win");
            self.destoryToWinLabel.center = CGPointMake(self.view.center.x, 220);
            
            [self.view addSubview:imgView];
            [self.view addSubview:self.battleBeginsTryShootLabel];
            [self.view addSubview:self.destoryToWinLabel];
            [self addDotNotShowAgainView];
        }
            break;
        default:
            break;
    }
}

- (void)startHandMovingAnimation
{
    [UIView beginAnimations:@"showPressReadyTipLabel" context:nil];
    [UIView setAnimationDuration:kHandMovingTime];
    self.descPressReady.alpha = 1;
    [UIView commitAnimations];
    
    if (!_handImgView) 
        _handImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kHandImgName]];
    _handImgView.frame = _handFrameB;
    
    [self.view addSubview:_handImgView];
    
    _handMovingTimer = [NSTimer scheduledTimerWithTimeInterval:kHandMovingTime target:self selector:@selector(moveHandAnimation) userInfo:nil repeats:YES];
    [_handMovingTimer fire];
}

- (void)moveHandAnimation
{
    [UIView beginAnimations:@"moveHand" context:nil];
    [UIView setAnimationDuration:kHandMovingTime];
    if (_handImgView.frame.origin.y == _handFrameA.origin.y)
        _handImgView.frame = _handFrameB;
    else
        _handImgView.frame = _handFrameA;
    
    [UIView commitAnimations];
}

- (void)addDotNotShowAgainView
{
    self.doNotShowAgainView.center = CGPointMake(self.view.center.x,
                                                 self.view.frame.size.height - self.doNotShowAgainView.bounds.size.height);
    [self.view addSubview:self.doNotShowAgainView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch 
{ 
    // disallow recognition of tap gestures in the check box or check box view
    id touchingView = touch.view;
    if (touchingView == self.doNotShowAgainView || 
        touchingView == self.doNotShowAgainCheckBoxBtn || 
        touchingView == self.doNotShowAgainLabel) 
    {
        return NO;
    }
    return YES;
}

- (IBAction)actionUserTappedGuideView:(UIGestureRecognizer *)sender 
{
    if (_handMovingTimer)
        [_handMovingTimer invalidate];
    [ASetting setValue:self.doNotShowAgainCheckBoxBtn.isChecked forGuideType:_type];
    if ([self.delegate respondsToSelector:@selector(dismissTheGuideView)]) 
        [self.delegate dismissTheGuideView];
}


@end
