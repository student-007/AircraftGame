//
//  ABattleFieldViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 1/1/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIBattleFieldView.h"
#import "AAircraftImageView.h"
#import "ABattleFieldModel.h"
#import "UIImage+AUITheme.h"

@protocol ABattleFieldVCDelegate;
@protocol ABattleFieldOrganizerDelegate;

@interface ABattleFieldViewController : UIViewController <UIGestureRecognizerDelegate>
{
    ABattleFieldModel *_battleFldModel;
}

@property (nonatomic, readonly) NSMutableArray *aircraftModelAry;
@property (nonatomic, readonly) NSMutableArray *attackRecordAry;

@property (nonatomic) BattleFieldType faction;
@property (assign, nonatomic) id<ABattleFieldVCDelegate> delegate;
@property (assign, nonatomic) id<ABattleFieldOrganizerDelegate> organizerDelegate;
@property (strong, nonatomic) IBOutlet UIButton *switchBarButton;
@property (strong, nonatomic) IBOutlet UIImageView *battleFieldImgView;
@property (nonatomic, readonly) NSInteger numberOfHits; // number of time for hit amount attacks

/*!
 @discussion add aircraft image (based on type) to field, no condition will be checked
 */
- (void)addAircraft:(AAircraftModel *)aircraft toFieldAsType:(AAircraftImgType)type withGesture:(BOOL)withGesture onBottom:(BOOL)onBottom;

/*!
 @discussion add aircraft image to field, conditions will be checked, delegate methods will also be called
 */
- (BOOL)addAircraft:(AAircraftModel *)aircraft;

/*!
 @discussion call this method for self field only, this can save enemy attack records
 */
- (void)addEnemyAttackRecord:(CGPoint)attPt;

/*!
 @discussion set to display the battle field(self/enemy) in scroll view
 */
- (void)displayBattleField;

/*!
 @discussion call this method after user making an attack marker. return which point was previous marked.
 if no marker was made, return (-1, -1)
 */
- (CGPoint)attackedBasedOnPreviousMark;

/*!
 @discussion return the defined string: kAttackRMiss kAttackRHit kAttackRDestroy. points are row and col(intgers value)
 */
- (NSString *)attackResultInGridAtPoint:(CGPoint)point;

/*!
 @discussion display the result in self/enemy field based on the resString at given point(grid point, 0-9)
 */
- (BOOL)displayAttackResultAtPoint:(CGPoint)point resultString:(NSString *)resString;

/*!
 @discussion display the result in enemy field based on last object of attack record array, if can not find previous attack mark, return NO
 */
- (BOOL)displayPreviousAttackResultForString:(NSString *)resString;

@end


#pragma mark - Battle field view controller protocol/delegate

@protocol ABattleFieldVCDelegate <NSObject>

@required
- (void)userWantsToSwitchFieldFrom:(ABattleFieldViewController *)currentBattleField;

/*!
 @discussion set to display the battle field(self/enemy) in scroll view
 */
- (void)displayBattleField:(ABattleFieldViewController *)battleFieldVC;

@optional

/*!
 @discussion this point is the row and col in grid(intgers value)
 */
- (void)userTappedBattleField:(ABattleFieldViewController *)battleFld atGridPoint:(CGPoint)point;
@end

@protocol ABattleFieldOrganizerDelegate <NSObject>
@optional
- (void)attackPositionMarked:(BOOL)onPreviousAttackedPos;
- (void)attackPositionUnmarked;
- (void)aircraftDestroyedAtField:(BattleFieldType)fieldType;
/*!
 @discussion this will be called when display a destroy result of an attack.
 */
//- (void)aircraftDestroyed;

@required
- (BOOL)userWantsToRemoveAircraft:(AAircraftModel *)aircraft;
- (BOOL)userWantsToAddAircraft:(AAircraftModel *)aircraft;
- (void)aircraftAdded;
- (void)aircraftRemoved;
@end
