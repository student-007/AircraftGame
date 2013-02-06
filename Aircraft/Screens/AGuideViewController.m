//
//  AGuideViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-6.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "AGuideViewController.h"

@interface AGuideViewController()
{
    UIImageView *_handImgView;
    CGRect _handFrameA;
    CGRect _handFrameB;
    NSTimer *_handMovingTimer;
}

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        _type = AGuideTypeNone;
        _handFrameA = CGRectMake(130.0f, 160.0f, 88.0f, 70.0f);
        _handFrameB = CGRectMake(130.0f, 325.0f, 88.0f, 70.0f);
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
}

- (void)viewDidUnload
{
    [self setTapGestureRecognizer:nil];
    [self setDescLabel:nil];
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
            
            CGRect labelFrame = _descLabel.frame;
            labelFrame.origin = CGPointMake(29.0f, 50.0f);
            _descLabel.frame = labelFrame;
            
            [self.view addSubview:imgView];
            [self.view addSubview:_descLabel];
            
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
        default:
            break;
    }
}

- (void)startHandMovingAnimation
{
    if (!_handImgView) 
        _handImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kHandImgName]];
    _handImgView.frame = _handFrameB;
    
    [self.view addSubview:_handImgView];
    
    _handMovingTimer = [NSTimer scheduledTimerWithTimeInterval:kHandMovingTime target:self selector:@selector(moveHandAnimation) userInfo:nil repeats:YES];
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

- (IBAction)actionUserTappedGuideView:(UIGestureRecognizer *)sender 
{
    if (_handMovingTimer)
        [_handMovingTimer invalidate];
    if ([self.delegate respondsToSelector:@selector(dismissTheGuideView)]) 
        [self.delegate dismissTheGuideView];
}


@end
