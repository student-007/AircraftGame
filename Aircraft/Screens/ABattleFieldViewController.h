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

@interface ABattleFieldViewController : UIViewController <UIGestureRecognizerDelegate>
{
    ABattleFieldModel *_battleFldModel;
}

@property (assign, nonatomic) id<ABattleFieldVCDelegate> delegate;
@property (strong, nonatomic) IBOutlet AUIBattleFieldView *view;
@property (strong, nonatomic) IBOutlet UIImageView *battleFieldImgView;


- (BOOL)addAircraft:(AAircraftModel *)aircraft;

/*!
 @discussion return the defined string: kAttackRMiss kAttackRHit kAttackRDestroy. points are row and col(intgers value)
 */
- (NSString *)attackResultInGridAtPoint:(CGPoint)point;

@end


#pragma mark - Battle field view controller protocol/delegate

@protocol ABattleFieldVCDelegate <NSObject>

@required
- (void)userWantsToSwitchFieldFrom:(ABattleFieldViewController *)currentBattleField;
- (BOOL)userWantsToRemoveAircraft:(AAircraftModel *)aircraft;
/*!
 @discussion this point is the row and col in grid(intgers value)
 */
- (void)userTappedBattleFieldGridAtPoint:(CGPoint)point;
@end
