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

@property (strong, nonatomic) UIImageView *attackMarkerImgView;

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
    
    self.battleFieldImgView.userInteractionEnabled = YES;
    [self addTapGestureToView:self.battleFieldImgView];
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

- (void)setFaction:(BattleFieldType)faction
{
    _battleFldModel.type = faction;
}

- (BattleFieldType)faction
{
    return _battleFldModel.type;
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
    tapGesture.delegate = self;
    [view addGestureRecognizer:tapGesture];
}

- (void)addPanGestureToView:(UIView *)view
{
    view.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDragingAircraft:)];
    panGesture.delegate = self;
    panGesture.maximumNumberOfTouches = 1;
    [view addGestureRecognizer:panGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && _battleFldModel.type == BattleFieldSelf)
    {
        AAircraftImageView *aircraftImgView = (AAircraftImageView *)gestureRecognizer.view;
        CGPoint touchPoint = [touch locationInView:gestureRecognizer.view];
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
    else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] /*&& _battleFldModel.type == BattleFieldEnemy*/)
    {
        return YES;
    }
    else
        return NO;
}

- (void)userTappedBattleField:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:tapGesture.view];
    CGPoint gridPoint = CGPointMake((int)(tapPoint.x / kMappingFactor), (int)(tapPoint.y / kMappingFactor));
    
    if (_battleFldModel.type == BattleFieldEnemy)
    {
        if (!self.attackMarkerImgView)
        {
            self.attackMarkerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            self.attackMarkerImgView.backgroundColor = [UIColor orangeColor];
        }
        
        CGPoint targetPoint = CGPointMake((int)gridPoint.x * kMappingFactor,
                                          (int)gridPoint.y * kMappingFactor);
        
        CGRect markerFrame = CGRectMake(targetPoint.x, targetPoint.y, kMappingFactor, kMappingFactor);
        self.attackMarkerImgView.frame = markerFrame;
        [self.attackMarkerImgView removeFromSuperview];
        [self.battleFieldImgView addSubview:self.attackMarkerImgView];
        
        _battleFldModel.attackPoint = gridPoint;
    }

    if ([self.delegate respondsToSelector:@selector(userTappedBattleField:atGridPoint:)])
        [self.delegate userTappedBattleField:self atGridPoint:gridPoint];
}

- (void)userDragingAircraft:(UIPanGestureRecognizer *)panGesture
{
    // is touching aircraft body will be checked in delegate method gestureRecognizer:shouldReceiveTouch
    // only deal with draging event
//    CGPoint touchPoint = [panGesture locationInView:panGesture.view];
    
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
            targetFrame.origin.x = (int)(newOrgin.x / kMappingFactor) * kMappingFactor;
            targetFrame.origin.y = (int)(newOrgin.y / kMappingFactor) * kMappingFactor;
//            targetFrame.origin.x = (int)roundf(newOrgin.x > 0 ? newOrgin.x : newOrgin.x * -1);
//            targetFrame.origin.y = (int)roundf(newOrgin.y > 0 ? newOrgin.y : newOrgin.y * -1);
            
            if (((int)newOrgin.x % kMappingFactor) > kMappingFactor / 2)
                targetFrame.origin.x += kMappingFactor;
            if (((int)newOrgin.y % kMappingFactor) > kMappingFactor / 2)
                targetFrame.origin.y += kMappingFactor;
            
            CGPoint newAircraftOrginPos = CGPointMake((int)(targetFrame.origin.x / kMappingFactor),
                                                      (int)(targetFrame.origin.y / kMappingFactor));
            AAircraftModel *newAircraft = [AAircraftModel aircraftWithOrgin:newAircraftOrginPos direction:aircraftImgView.aircraft.direction];
            
            [_battleFldModel clearGridForAircraft:aircraftImgView.aircraft];
            
            if ([self checkPositionForAircraft:newAircraft])
            {
                aircraftImgView.frame = targetFrame;
                aircraftImgView.aircraft.orginPos = newAircraftOrginPos;
            }
            else
            {
                aircraftImgView.frame = _tempAircraftImgViewFrame;
            }
            
            [_battleFldModel fillGridForAircraft:aircraftImgView.aircraft];
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

- (CGPoint)attackedBasedOnPreviousMark
{
    [self.attackMarkerImgView removeFromSuperview];
    CGPoint previousMarkerPt = CGPointMake(_battleFldModel.attackPoint.x, _battleFldModel.attackPoint.y);
    [_battleFldModel addAttackRecordPoint];
    
    return previousMarkerPt;
}

/*!
 @discussion return the defined string: kAttackRMiss kAttackRHit kAttackRDestroy. points are row and col(intgers value)
 */
- (NSString *)attackResultInGridAtPoint:(CGPoint)point
{
    return [_battleFldModel attackResultInGridAtPoint:point];
}
@end
