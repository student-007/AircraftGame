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

@protocol ABattleFieldVCDelegate;
@protocol ABattleFieldOrganizerDelegate;

@interface ABattleFieldViewController : UIViewController <UIGestureRecognizerDelegate>
{
    ABattleFieldModel *_battleFldModel;
}

@property (nonatomic, readonly) NSMutableArray *aircraftModelAry;

@property (nonatomic) BattleFieldType faction;
@property (assign, nonatomic) id<ABattleFieldVCDelegate> delegate;
@property (assign, nonatomic) id<ABattleFieldOrganizerDelegate> organizerDelegate;
@property (strong, nonatomic) IBOutlet AUIBattleFieldView *view;
@property (strong, nonatomic) IBOutlet UIImageView *battleFieldImgView;


- (BOOL)addAircraft:(AAircraftModel *)aircraft;

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
 @discussion display the result in enemy field based on last object of attack record array
 */
- (BOOL)displayPreviousAttackResultForString:(NSString *)resString;

@end


#pragma mark - Battle field view controller protocol/delegate

@protocol ABattleFieldVCDelegate <NSObject>

@required
- (void)userWantsToSwitchFieldFrom:(ABattleFieldViewController *)currentBattleField;

@optional
/*!
 @discussion this point is the row and col in grid(intgers value)
 */
- (void)userTappedBattleField:(ABattleFieldViewController *)battleFld atGridPoint:(CGPoint)point;
@end

@protocol ABattleFieldOrganizerDelegate <NSObject>

@required
- (BOOL)userWantsToRemoveAircraft:(AAircraftModel *)aircraft;
- (BOOL)userWantsToAddAircraft:(AAircraftModel *)aircraft;
- (void)aircraftAdded;
- (void)aircraftRemoved;
@end
