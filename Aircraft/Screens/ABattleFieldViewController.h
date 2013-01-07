//
//  ABattleFieldViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 1/1/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIBattleFieldView.h"
#import "AAircraftModel.h"

@protocol ABattleFieldVCDelegate;

@interface ABattleFieldViewController : UIViewController

@property (assign, nonatomic) id<ABattleFieldVCDelegate> delegate;
@property (strong, nonatomic) IBOutlet AUIBattleFieldView *view;
@property (nonatomic) CGPoint attackPoint;

- (BOOL)addAircraft:(AAircraftModel *)aircraft error:(NSError **)error; // error: aircraft cant fit 
- (BOOL)removeAircraft:(AAircraftModel *)aircraft error:(NSError **)error; // error: no such aircraft at position

/*!
 @discussion return the defined string: kAttackRMiss kAttackRHit kAttackRDestroy. points are row and col(intgers value)
 */
- (NSString *)attackResultInGridAtPoint:(CGPoint)point;

@end


#pragma mark - Battle field view controller protocol/delegate

@protocol ABattleFieldVCDelegate <NSObject>

@required
- (void)userWantsToSwitchFieldFrom:(ABattleFieldViewController *)currentBattleField;

/*!
 @discussion this point is the row and col in grid(intgers value)
 */
- (void)userTappedBattleFieldGridAtPoint:(CGPoint)point;
@end
