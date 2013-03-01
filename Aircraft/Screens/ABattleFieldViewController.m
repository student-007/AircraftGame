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

#define kAttackResultHitImgName     @"explosion.png"
#define kAttackResultMissImgName    @""
#define kAttackResultDestroyImgName @"explosionDestroy.png"
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


- (NSMutableArray *)attackRecordAry
{
    return _battleFldModel.attackRecord ? _battleFldModel.attackRecord : nil;
}

- (void)setAttackRecordAry:(NSMutableArray *)attackRecordAry
{
    _battleFldModel.attackRecord = [NSMutableArray arrayWithArray:attackRecordAry];
}

- (NSInteger)numberOfHits
{
    return _battleFldModel.numberOfHits;
}

- (NSInteger)numberOfAircraftDestroyed
{
    return _battleFldModel.numberOfAircraftDestroyed;
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
    else if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && _battleFldModel.type == BattleFieldEnemy)
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
        {
            switch (aircraftImgView.imgType)
            {
                case AAircraftImgRegularType:
                    aircraftImgView.alpha = 0.5;
                    break;
                case AAircraftImgDottedType:
                    aircraftImgView.alpha = 0.2;
                    break;
                default:
                    break;
            }
        }
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
            if (aircraftImgView.imgType == AAircraftImgDottedType)
            {
                [aircraftImgView removeFromSuperview];
            }
            else
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

- (void)loadDataFromGameRecord:(ASavedGameRecord *)gameRecord sentBy:(AUserType)userType
{
    switch (userType)
    {
        case AUserTypeUser:
        {
            switch (self.faction)
            {
                case BattleFieldSelf:
                {
                    // self battle field setup
                    NSArray *selfAircrafts = gameRecord.selfAircrafts;
                    for (NSDictionary *aircraftDic in selfAircrafts)
                    {
                        AAircraftModel *aircraftModel = [AAircraftModel aircraftFromSavableDictionary:aircraftDic];
                        [self addAircraft:aircraftModel];
                    }
                    NSArray *enemyAttackRecords = gameRecord.enemyAttackRecords;
                    self.attackRecordAry = [enemyAttackRecords mutableCopy];
                }
                    break;
                case BattleFieldEnemy:
                {
                    // enemy battle field setup
                    NSArray *enemyAircrafts = gameRecord.enemyAircrafts;
                    for (NSDictionary *aircraftDic in enemyAircrafts)
                    {
                        AAircraftModel *aircraftModel = [AAircraftModel aircraftFromSavableDictionary:aircraftDic];
                        [self addAircraftModelToBattleFieldModel:aircraftModel];
                    }
                    NSArray *selfAttackRecords = gameRecord.selfAttackRecords;
                    self.attackRecordAry = [selfAttackRecords mutableCopy];
                }
                    break;
                default:
                    break;
            } 
        }
            break;
        case AUserTypeOpponent:
        {
            switch (self.faction)
            {
                case BattleFieldEnemy:
                {
                    // self battle field setup
                    NSArray *selfAircrafts = gameRecord.selfAircrafts;
                    for (NSDictionary *aircraftDic in selfAircrafts)
                    {
                        AAircraftModel *aircraftModel = [AAircraftModel aircraftFromSavableDictionary:aircraftDic];
                        [self addAircraft:aircraftModel];
                    }
                    NSArray *enemyAttackRecords = gameRecord.enemyAttackRecords;
                    self.attackRecordAry = [enemyAttackRecords mutableCopy];
                }
                    break;
                case BattleFieldSelf:
                {
                    // enemy battle field setup
                    NSArray *enemyAircrafts = gameRecord.enemyAircrafts;
                    for (NSDictionary *aircraftDic in enemyAircrafts)
                    {
                        AAircraftModel *aircraftModel = [AAircraftModel aircraftFromSavableDictionary:aircraftDic];
                        [self addAircraftModelToBattleFieldModel:aircraftModel];
                    }
                    NSArray *selfAttackRecords = gameRecord.selfAttackRecords;
                    self.attackRecordAry = [selfAttackRecords mutableCopy];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case AUserTypeNone:
        {
        }
            break;
        default:
            break;
    }
}

- (void)addAircraft:(AAircraftModel *)aircraft toFieldAsType:(AAircraftImgType)type withGesture:(BOOL)withGesture onBottom:(BOOL)onBottom;
{
    switch (type)
    {
        case AAircraftImgRegularType:
        {
            // add the aircraft image view to battle field
            AAircraftImageView *aircraftImgView = [[AAircraftImageView alloc] initWithAircraftModel:aircraft];
            if (withGesture)
                [self addPanGestureToView:aircraftImgView];
            if (onBottom)
                [self.battleFieldImgView insertSubview:aircraftImgView atIndex:0];
            else
                [self.battleFieldImgView addSubview:aircraftImgView];
        }
            break;
        case AAircraftImgDottedType:
        {
            // add the aircraft image view to battle field
            AAircraftImageView *aircraftImgView = [[AAircraftImageView alloc] initWithAircraftModel:aircraft imageType:AAircraftImgDottedType ];
            if (withGesture)
                [self addPanGestureToView:aircraftImgView];
            if (onBottom)
                [self.battleFieldImgView insertSubview:aircraftImgView atIndex:0];
            else
                [self.battleFieldImgView addSubview:aircraftImgView];
        }
            break;
        default:
            break;
    }
}

- (BOOL)addAircraft:(AAircraftModel *)aircraft
{
    if ([self.organizerDelegate userWantsToAddAircraft:aircraft])
    {
        if ([_battleFldModel checkPositionForAircraft:aircraft])
        {
            // add aircraft model to battle field model
            [_battleFldModel addAircraft:aircraft];
            [self addAircraft:aircraft toFieldAsType:AAircraftImgRegularType withGesture:YES onBottom:YES];
//            // add the aircraft image view to battle field
//            AAircraftImageView *aircraftImgView = [[AAircraftImageView alloc] initWithAircraftModel:aircraft];
//            [self addPanGestureToView:aircraftImgView];
//            [self.battleFieldImgView addSubview:aircraftImgView];
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

- (void)addAircraftModelToBattleFieldModel:(AAircraftModel *)aircraft
{
    if (_battleFldModel)
        [_battleFldModel addAircraft:aircraft];
}

- (void)addEnemyAttackRecord:(CGPoint)attPt
{
    NSArray *attRecord = [NSArray arrayWithObjects:[NSNumber numberWithInt:(int)attPt.x], [NSNumber numberWithInt:(int)attPt.y], nil];
    
    if (!_battleFldModel.attackRecord)  _battleFldModel.attackRecord = [NSMutableArray array];
    [_battleFldModel.attackRecord addObject:attRecord];
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

- (void)removeFromSuperView:(NSTimer *)timer
{
    UIView *theView = (UIView *)timer.userInfo;
    if (theView.superview)
        [theView removeFromSuperview];
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
            UIImageView *bkgImgView = [[UIImageView alloc] initWithImage:[UIImage imageForBlackRectBackground]];
            bkgImgView.frame = markerFrame;
            [bkgImgView setBackgroundColor:[UIColor clearColor]];
            bkgImgView.alpha = 0.4;
            [self.battleFieldImgView addSubview:bkgImgView];
            
            UILabel *resultLabel = [[UILabel alloc] initWithFrame:markerFrame];
            resultLabel.textAlignment = UITextAlignmentCenter;
            resultLabel.text = @"\uE049";
            resultLabel.backgroundColor = [UIColor clearColor];
            [self.battleFieldImgView addSubview:resultLabel];
            
            if (self.faction == BattleFieldSelf) 
            {
                AUIPopView *popView = [AUIPopView popViewWithText:[NSString stringWithFormat:@"%@\n%@: %d %@: %d\n%@", ALocalisedString(@"hit_missed_at"),
                                                                   ALocalisedString(@"row"), (int)point.x + 1, ALocalisedString(@"column"), (int)point.y + 1, 
                                                                   ALocalisedString(@"your_turn_now")] 
                                                            image:[UIImage imageForBlueRectBackground] 
                                                             size:CGSizeMake(260, 110) 
                                                 dissmissDuration:3.5];
                [popView show];
            }
        }
        else if ([resString caseInsensitiveCompare:kAttackRHit] == NSOrderedSame)
        {
            UIImageView *resultImgView = [[UIImageView alloc] initWithImage:_attackResImgHit];
            resultImgView.frame = markerFrame;
            resultImgView.alpha = 0;
            [self.battleFieldImgView addSubview:resultImgView];
            
            UIImageView *animationImgView = [[UIImageView alloc] initWithImage:[UIImage imageWithExplosionAnimation]];
            CGRect animatedImgViewFrame = CGRectMake(0, 0, 32, 24);
            animationImgView.frame = animatedImgViewFrame;
            animationImgView.center = resultImgView.center;
            [self.battleFieldImgView addSubview:animationImgView];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(removeFromSuperView:) userInfo:animationImgView repeats:NO];
            
            [UIView beginAnimations:@"addAttackRHit" context:nil];
            [UIView setAnimationDuration:1.5f];
            resultImgView.alpha = 1;
            [UIView commitAnimations];
            
            if (self.faction == BattleFieldSelf) 
            {
                AUIPopView *popView = [AUIPopView popViewWithText:[NSString stringWithFormat:@"%@\n%@: %d %@: %d\n%@", ALocalisedString(@"hit_at"),
                                                                   ALocalisedString(@"row"), (int)point.x + 1, ALocalisedString(@"column"), (int)point.y + 1, 
                                                                   ALocalisedString(@"your_turn_now")] 
                                                            image:[UIImage imageForOrangeRectBackground] 
                                                             size:CGSizeMake(260, 110) 
                                                 dissmissDuration:4];
                [popView show];
            }
        }
        else if ([resString caseInsensitiveCompare:kAttackRDestroy] == NSOrderedSame)
        {
            UIImageView *resultImgView = [[UIImageView alloc] initWithImage:_attackResImgDestroy];
            resultImgView.frame = markerFrame;
            resultImgView.alpha = 0;
            [self.battleFieldImgView addSubview:resultImgView];
            
            UIImageView *animationImgView = [[UIImageView alloc] initWithImage:[UIImage imageWithExplosionAnimation]];
            CGRect animatedImgViewFrame = CGRectMake(0, 0, 32, 24);
            animationImgView.frame = animatedImgViewFrame;
            animationImgView.center = resultImgView.center;
            [self.battleFieldImgView addSubview:animationImgView];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(removeFromSuperView:) userInfo:animationImgView repeats:NO];
            
            [UIView beginAnimations:@"addAttackRDestroy" context:nil];
            [UIView setAnimationDuration:1.5f];
            resultImgView.alpha = 1;
            [UIView commitAnimations];
            
            if ([self.organizerDelegate respondsToSelector:@selector(aircraftDestroyedAtField:)])
                [self.organizerDelegate aircraftDestroyedAtField:self.faction];
            
//            UIImageView *resultImgView = [[UIImageView alloc] initWithImage:_attackResImgDestroy];
//            resultImgView.frame = markerFrame;
////            [resultImgView setBackgroundColor:[UIColor redColor]];
//            [self.battleFieldImgView addSubview:resultImgView];
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
