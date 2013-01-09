//
//  ABattleFieldViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 1/1/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "ABattleFieldViewController.h"

@interface ABattleFieldViewController ()
{
    CGRect _tempAircraftImgViewFrame;
}

@end

@implementation ABattleFieldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _battleFldModel = [[ABattleFieldModel alloc] init];
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

- (void)viewDidUnload
{
    [self setView:nil];
    [self setBattleFieldImgView:nil];
    [super viewDidUnload];
}

- (IBAction)switchBattleFieldBtnClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(userWantsToSwitchFieldFrom:)])
    {
        [self.delegate userWantsToSwitchFieldFrom:self];
    }
}

- (void)addTapGestureToView:(UIView *)view
{
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedBattleField:)];
    [view addGestureRecognizer:tapGesture];
}

- (void)addPanGestureToView:(UIView *)view
{
    view.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDragingAircraft:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    [view addGestureRecognizer:panGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && _battleFldModel.type == BattleFieldSelf)
    {
        AAircraftImageView *aircraftImgView = (AAircraftImageView *)gestureRecognizer.view;
        CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
        if ([aircraftImgView isTouchingAircraftBodyForPoint:touchPoint])
        {
            _tempAircraftImgViewFrame = aircraftImgView.frame;
            return YES;
        }
        else
        {
            _tempAircraftImgViewFrame = CGRectNull;
            return NO;
        }
    }
    else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && _battleFldModel.type == BattleFieldEnemy)
    {
        return YES;
    }
    else
        return NO;
}

- (void)userTappedBattleField:(UITapGestureRecognizer *)tapGesture
{
#warning TODO:show a target image, waiting for user to comfirm attack
    // _battleFldModel.attackPoint = tappedPoint;
    // call this when confirm [_battleFldModel addAttackRecordPoint];
    // then send an attack message and wait for reply
}

- (void)userDragingAircraft:(UIPanGestureRecognizer *)panGesture
{
    // is touching aircraft body will be checked in delegate method gestureRecognizer:shouldReceiveTouch
    // only deal with draging event
    
    AAircraftImageView *aircraftImgView = (AAircraftImageView *)panGesture.view;
    
    if (panGesture.state == UIGestureRecognizerStateBegan ||
        panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panGesture translationInView:self.battleFieldImgView];
        
        [aircraftImgView setCenter:CGPointMake(aircraftImgView.center.x + translation.x,
                                               aircraftImgView.center.y + translation.y)];
        [panGesture setTranslation:CGPointZero inView:self.battleFieldImgView];
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        CGRect newFrame = aircraftImgView.frame;
        CGPoint newOrgin = newFrame.origin;
        CGRect targetFrame = CGRectMake(-1, -1, newFrame.size.width, newFrame.size.height);
        
        if (newOrgin.x >= -5 && newOrgin.y >= -5 &&
            newOrgin.x + newFrame.size.width <= 10 * kMappingFactor + 5 &&
            newOrgin.y + newFrame.size.height <= 10 * kMappingFactor + 5)
        {
            if ((targetFrame.origin.x = (int)newOrgin.x % kMappingFactor) > kMappingFactor / 2)
                targetFrame.origin.x += kMappingFactor;
            if ((targetFrame.origin.y = (int)newOrgin.y % kMappingFactor) > kMappingFactor / 2)
                targetFrame.origin.y += kMappingFactor;
            
            CGPoint newAircraftOrginPos = CGPointMake(targetFrame.origin.x / kMappingFactor,
                                                      targetFrame.origin.y / kMappingFactor);
            AAircraftModel *newAircraft = [AAircraftModel aircraftWithOrgin:newAircraftOrginPos direction:aircraftImgView.aircraft.direction];
            if ([self checkPositionForAircraft:newAircraft])
            {
                aircraftImgView.frame = targetFrame;
                aircraftImgView.aircraft.orginPos = newAircraftOrginPos;
            }
            else
            {
                aircraftImgView.frame = _tempAircraftImgViewFrame;
            }
        }
        // if user wants to remove this aircraft [Yufei Lang 4/14/2012]
        else if (aircraftImgView.center.y > 10 * kMappingFactor)
        {
            if ([self.delegate respondsToSelector:@selector(userWantsToRemoveAircraft:)])
                if ([self.delegate userWantsToRemoveAircraft:aircraftImgView.aircraft])
                {
                    [_battleFldModel removeAircraft:aircraftImgView.aircraft];
                    [aircraftImgView removeFromSuperview];
                }
        }
        else
        {
            aircraftImgView.frame = _tempAircraftImgViewFrame;
        }
    }
}

- (BOOL)checkPositionForAircraft:(AAircraftModel *)aircraft
{
    return [_battleFldModel checkPositionForAircraft:aircraft];
}

- (BOOL)addAircraft:(AAircraftModel *)aircraft
{
    if ([_battleFldModel checkPositionForAircraft:aircraft])
    {
        // add aircraft model to battle field model
        [_battleFldModel addAircraft:aircraft];
        
        // add the aircraft image view to battle field
        AAircraftImageView *aircraftImgView = [[AAircraftImageView alloc] initWithAircraftModel:aircraft];
        [self addPanGestureToView:aircraftImgView];
        [self.battleFieldImgView addSubview:aircraftImgView];
        
        return YES;
    }
    else
    {
        return NO;
    }
}

/*!
 @discussion return the defined string: kAttackRMiss kAttackRHit kAttackRDestroy. points are row and col(intgers value)
 */
- (NSString *)attackResultInGridAtPoint:(CGPoint)point
{
    return [_battleFldModel attackResultInGridAtPoint:point];
}
@end
