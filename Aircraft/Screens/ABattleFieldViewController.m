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
    
    UIImage *_attackResImgHit;
    UIImage *_attackResImgMiss;
    UIImage *_attackResImgDestroy;
}
@property (nonatomic, readonly) BOOL isGameOn;
@property (strong, nonatomic) UIImageView *attackMarkerImgView;
- (void)addTapGestureToView:(UIView *)view;
- (void)addPanGestureToView:(UIView *)view;
- (BOOL)checkPositionForAircraft:(AAircraftModel *)aircraft;
- (IBAction)switchBattleFieldBtnClicked:(UIButton *)sender;
@end

@implementation ABattleFieldViewController

@synthesize attackMarkerImgView = _attackMarkerImgView;
@synthesize delegate = _delegate;
@synthesize organizerDelegate = _organizerDelegate;
@synthesize switchBarButton = _switchBarButton;
@synthesize battleFieldImgView = _battleFieldImgView;

#define kAttackResultHitImgName     @""
#define kAttackResultMissImgName    @""
#define kAttackResultDestroyImgName @""
#define kAttackMarkerImgName        @"attackMark.png"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _battleFldModel = [[ABattleFieldModel alloc] init];
        _attackResImgHit = [UIImage imageNamed:kAttackResultHitImgName];
        _attackResImgMiss = [UIImage imageNamed:kAttackResultMissImgName];
        _attackResImgDestroy = [UIImage imageNamed:kAttackResultDestroyImgName];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.battleFieldImgView.userInteractionEnabled = YES;
    [self addTapGestureToView:self.battleFieldImgView];
    
    switch (_battleFldModel.type)
    {
        case BattleFieldSelf:
        {
            [self.battleFieldImgView setImage:[UIImage imageNamed:@"battleField_self.png"]];
            [self.switchBarButton setBackgroundImage:[UIImage imageNamed:@"battleFieldBar_self.png"] forState:UIControlStateNormal];
            [self.switchBarButton setBackgroundImage:[UIImage imageNamed:@"battleFieldBarHighlighted_self.png"] forState:UIControlStateHighlighted];
        }
            break;
        case BattleFieldEnemy:
        {
            [self.battleFieldImgView setImage:[UIImage imageNamed:@"battleField_enemy.png"]];
            [self.switchBarButton setBackgroundImage:[UIImage imageNamed:@"battleFieldBar_enemy.png"] forState:UIControlStateNormal];
            [self.switchBarButton setBackgroundImage:[UIImage imageNamed:@"battleFieldBarHighlighted_enemy.png"] forState:UIControlStateHighlighted];
        }
            break;
        default:
            break;
    }
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
    [self setSwitchBarButton:nil];
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

- (NSMutableArray *)aircraftModelAry
{
    return _battleFldModel.aircraftModelAry;
}

- (void)displayBattleField
{
    if ([self.delegate respondsToSelector:@selector(displayBattleField:)])
        [self.delegate displayBattleField:self];
}

- (IBAction)switchBattleFieldBtnClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(userWantsToSwitchFieldFrom:)])
    {
        [self.delegate userWantsToSwitchFieldFrom:self];
    }
}

- (BOOL)isGameOn
{
    AGameOrganizer *organizer = [AGameOrganizer sharedInstance];
    NSDictionary *gameStatus = nil;
    DICT_GET_OBJECT(organizer.gameStatus, gameStatus, kGameStatusBeginEndGame);
    if (gameStatus)
    {
        NSNumber *isGameOn = [gameStatus valueForKey:@"isGameOn"];
        if (isGameOn)
            return [isGameOn boolValue];
        else
            return NO;
    }
    else
        return NO;
}

#pragma mark - gestures

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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && _battleFldModel.type == BattleFieldSelf)
    {
        // only allow draging before game starts
        if (!self.isGameOn)
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
        else
            return NO;
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
        if (self.isGameOn)
        {
            if (!self.attackMarkerImgView)
            {
                self.attackMarkerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kAttackMarkerImgName]];
                [self.attackMarkerImgView setBackgroundColor:[UIColor clearColor]];
            }
            
            CGPoint targetPoint = CGPointMake((int)gridPoint.x * kMappingFactor,
                                              (int)gridPoint.y * kMappingFactor);
            
            CGRect markerFrame = CGRectMake(targetPoint.x, targetPoint.y, kMappingFactor, kMappingFactor);
            self.attackMarkerImgView.frame = markerFrame;
            [self.attackMarkerImgView removeFromSuperview];
            [self.battleFieldImgView addSubview:self.attackMarkerImgView];
            
            _battleFldModel.attackPoint = gridPoint;
            if ([self.organizerDelegate respondsToSelector:@selector(attackPositionMarked:)])
            {
                [self.organizerDelegate attackPositionMarked:[_battleFldModel checkIfAttackedAtPoint:gridPoint]];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(userTappedBattleField:atGridPoint:)])
        [self.delegate userTappedBattleField:self atGridPoint:gridPoint];
}

- (void)userDragingAircraft:(UIPanGestureRecognizer *)panGesture
{
    // is touching aircraft body will be checked in delegate method gestureRecognizer:shouldReceiveTouch
    // only deal with draging event. PS: disallow draging durning game will also be checked in the same delegate
    
    AAircraftImageView *aircraftImgView = (AAircraftImageView *)panGesture.view;
    
    if (panGesture.state == UIGestureRecognizerStateBegan ||
        panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panGesture translationInView:self.battleFieldImgView];
        
        [aircraftImgView setCenter:CGPointMake(aircraftImgView.center.x + translation.x,
                                               aircraftImgView.center.y + translation.y)];
        [panGesture setTranslation:CGPointZero inView:self.battleFieldImgView];
        
        CGPoint imgCenterPt = aircraftImgView.center;
        if (imgCenterPt.y > 10 * kMappingFactor)
            aircraftImgView.alpha = 0.7;
        else
            aircraftImgView.alpha = 1.0;
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
            NSAssert([self.organizerDelegate respondsToSelector:@selector(userWantsToRemoveAircraft:)], @"[error]: Delegate method userWantsToRemoveAircraft: not implenment.");
            if ([self.organizerDelegate userWantsToRemoveAircraft:aircraftImgView.aircraft])
            {
                [_battleFldModel removeAircraft:aircraftImgView.aircraft];
                [aircraftImgView removeFromSuperview];
                if ([self.organizerDelegate respondsToSelector:@selector(aircraftRemoved)])
                    [self.organizerDelegate aircraftRemoved];
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
    if ([self.organizerDelegate userWantsToAddAircraft:aircraft])
    {
        if ([_battleFldModel checkPositionForAircraft:aircraft])
        {
            // add aircraft model to battle field model
            [_battleFldModel addAircraft:aircraft];
            
            // add the aircraft image view to battle field
            AAircraftImageView *aircraftImgView = [[AAircraftImageView alloc] initWithAircraftModel:aircraft];
            [self addPanGestureToView:aircraftImgView];
            [self.battleFieldImgView addSubview:aircraftImgView];
            if ([self.organizerDelegate respondsToSelector:@selector(aircraftAdded)])
                [self.organizerDelegate aircraftAdded];
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
        return NO;
}

- (CGPoint)attackedBasedOnPreviousMark
{
    CGPoint previousMarkerPt = CGPointMake(_battleFldModel.attackPoint.x, _battleFldModel.attackPoint.y);
    if ([_battleFldModel addAttackRecordPoint])
    {
        [self.attackMarkerImgView removeFromSuperview];
        if ([self.organizerDelegate respondsToSelector:@selector(attackPositionUnmarked)])
            [self.organizerDelegate attackPositionUnmarked];
        return previousMarkerPt;
    }
    else
        return CGPointMake(-1, -1);
}

/*!
 @discussion return the defined string: kAttackRMiss kAttackRHit kAttackRDestroy. points are row and col(intgers value)
 */
- (NSString *)attackResultInGridAtPoint:(CGPoint)point
{
    return [_battleFldModel attackResultInGridAtPoint:point];
}

/*!
 @discussion display the result in self/enemy field based on the resString at given point
 */
- (BOOL)displayAttackResultAtPoint:(CGPoint)point resultString:(NSString *)resString
{
    if (point.x >= 0 && point.x <= 9 &&
        point.y >= 0 && point.y <= 9)
    {        
        CGPoint targetPoint = CGPointMake((int)point.x * kMappingFactor,
                                          (int)point.y * kMappingFactor);
        
        CGRect markerFrame = CGRectMake(targetPoint.x, targetPoint.y, kMappingFactor, kMappingFactor);
        
        if ([resString caseInsensitiveCompare:kAttackRMiss] == NSOrderedSame)
        {
            UIImageView *resultImgView = [[UIImageView alloc] initWithImage:_attackResImgMiss];
            resultImgView.frame = markerFrame;
            [resultImgView setBackgroundColor:[UIColor whiteColor]];
            [self.battleFieldImgView addSubview:resultImgView];
        }
        else if ([resString caseInsensitiveCompare:kAttackRHit] == NSOrderedSame)
        {
            UIImageView *resultImgView = [[UIImageView alloc] initWithImage:_attackResImgHit];
            resultImgView.frame = markerFrame;
            [resultImgView setBackgroundColor:[UIColor yellowColor]];
            [self.battleFieldImgView addSubview:resultImgView];
        }
        else if ([resString caseInsensitiveCompare:kAttackRDestroy] == NSOrderedSame)
        {
            UIImageView *resultImgView = [[UIImageView alloc] initWithImage:_attackResImgDestroy];
            resultImgView.frame = markerFrame;
            [resultImgView setBackgroundColor:[UIColor redColor]];
            [self.battleFieldImgView addSubview:resultImgView];
        }
        else
            return NO;
        
        return YES;
    }
    return NO;
}

/*!
 @discussion display the result in enemy field based on last object of attack record array
 */
- (BOOL)displayPreviousAttackResultForString:(NSString *)resString
{
    CGPoint lastAttackPt = [_battleFldModel lastAttackPoint];
    if (lastAttackPt.x != -1 && lastAttackPt.y != -1)
    {
        return [self displayAttackResultAtPoint:lastAttackPt resultString:resString];
    }
    else
        return NO;
}
@end
