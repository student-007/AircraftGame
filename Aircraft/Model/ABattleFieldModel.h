//
//  ABattleFieldModel.h
//  Aircraft
//
//  Created by Yufei Lang on 1/8/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

typedef enum
{
    BattleFieldNone     = -1,
    BattleFieldEnemy    = 1,
    BattleFieldSelf     = 2
}BattleFieldType;

#import <Foundation/Foundation.h>
#import "AAircraftModel.h"
#import "ANetMessage.h"

@interface ABattleFieldModel : NSObject
{
    BattleFieldType _type;
    int _battleFieldGrid[10][10];
}

@property (nonatomic) CGPoint attackPoint;
@property (nonatomic, readonly) CGPoint lastAttackPoint;
@property (nonatomic) BattleFieldType type;     // default: BattleFieldNone
@property (strong, nonatomic, readonly) NSMutableArray *aircraftModelAry;
@property (nonatomic, readonly) NSInteger numberOfHits; // number of time for hit amount attacks

// array of [NSNumber, NSNumber]
@property (nonatomic, strong) NSMutableArray *attackRecord;

/*!
 @discussion ONLY call this method after setting up the property 'attackPoint', then attack will be recoreded for saving game.
 */
- (BOOL)addAttackRecordPoint;//:(CGPoint)attackPoint;

/*!
 @discussion return the defined string: kAttackRMiss kAttackRHit kAttackRDestroy. points are row and col(intgers value)
 */
- (NSString *)attackResultInGridAtPoint:(CGPoint)point;

/*!
 @discussion add aircraft model to array and update the gird. This method does not check if the aircraft can fit into the gird.
 */
- (void)addAircraft:(AAircraftModel *)aircraft;

/*!
 @discussion delete aircraft model from array(if the array contains it) and update the gird.
 */
- (void)removeAircraft:(AAircraftModel *)aircraft;

/*!
 @discussion delete the existing aircraft in grid, this is used for replacing/adjusting aircrafts.
 */
- (void)clearGridForAircraft:(AAircraftModel *)aircraft;

/*!
 @discussion fill the grid for aircraft, this is used for replacing/adjusting aircrafts.
 */
- (void)fillGridForAircraft:(AAircraftModel *)aircraft;

/*!
 @discussion check if the point was previous attacked
 */
- (BOOL)checkIfAttackedAtPoint:(CGPoint)point;

/*!
 @discussion check if an aircraft model can fit into the _battleFieldGrid.
 */
- (BOOL)checkPositionForAircraft:(AAircraftModel *)aircraft;

@end
