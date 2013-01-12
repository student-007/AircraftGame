//
//  ABattleFieldModel.m
//  Aircraft
//
//  Created by Yufei Lang on 1/8/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "ABattleFieldModel.h"

@interface ABattleFieldModel()

// array of [NSNumber, NSNumber]
@property (nonatomic, strong) NSMutableArray *attackRecord;

@end

@implementation ABattleFieldModel

- (id)init
{
    if (self = [super init])
    {
        _type = BattleFieldNone;
        _attackPoint = CGPointMake(-1, -1);
        
        for (int i = 0; i < 10; i++)
            for (int j = 0; j < 10; j++)
                _battleFieldGrid[i][j] = AircraftNone;
        
    }
    return self;
}

- (void)addAttackRecordPoint//:(CGPoint)attackPoint
{
    NSAssert(_attackPoint.x != -1 && _attackPoint.y != -1, @"[error]: set 'attackPoint' before calling method 'addAttackRecordPoint'");
    
    NSArray *pointArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:_attackPoint.x],
                           [NSNumber numberWithInt:_attackPoint.y], nil];
    
    if (!self.attackRecord)
        self.attackRecord = [NSMutableArray arrayWithObject:pointArray];
    else
        [self.attackRecord addObject:pointArray];
    
    _attackPoint = CGPointMake(-1, -1);
}

- (NSString *)attackResultInGridAtPoint:(CGPoint)point
{
    AircraftPart part = _battleFieldGrid[(int)point.x][(int)point.y];
    switch (part)
    {
        case AircraftNone:
        {
            return kAttackRMiss;
        }
            break;
        case AircraftHead:
        {
            return kAttackRDestroy;
        }
            break;
        case AircraftBody:
        {
            return kAttackRHit;
        }
            break;
            
        default:
            break;
    }
}

- (void)addAircraft:(AAircraftModel *)aircraft
{
    if (_aircraftModelAry)
    {
        [_aircraftModelAry addObject:aircraft];
        
        [self fillGridForAircraft:aircraft];
    }
    else
    {
        _aircraftModelAry = [NSMutableArray arrayWithObject:aircraft];
    }
}

- (void)removeAircraft:(AAircraftModel *)aircraft
{
    if (_aircraftModelAry)
    {
        if ([_aircraftModelAry containsObject:aircraft])
        {
            [_aircraftModelAry removeObject:aircraft];
            
            [self clearGridForAircraft:aircraft];
        }
    }
}

- (void)clearGridForAircraft:(AAircraftModel *)aircraft
{
    // remove from gird
    int offsetY = aircraft.orginPos.x;
    int offsetX = aircraft.orginPos.y;
    
    for (int row = offsetX, aRow = 0; row < offsetX + 5; row++, aRow++)
        for (int col = offsetY, aCol = 0; col < offsetY + 5; col++, aCol++)
        {
            if ([aircraft elementAtRow:aRow col:aCol] != AircraftNone)
                _battleFieldGrid[row][col] = AircraftNone;
        }
}

- (void)fillGridForAircraft:(AAircraftModel *)aircraft
{
    // add to gird
    int offsetY = aircraft.orginPos.x;
    int offsetX = aircraft.orginPos.y;
    
    for (int row = offsetX, aRow = 0; row < offsetX + 5; row++, aRow++)
        for (int col = offsetY, aCol = 0; col < offsetY + 5; col++, aCol++)
        {
            _battleFieldGrid[row][col] = [aircraft elementAtRow:aRow col:aCol];
        }
}

- (BOOL)checkPositionForAircraft:(AAircraftModel *)aircraft
{
    if (_aircraftModelAry)
    {
        if (_aircraftModelAry.count != 0)
        {
            int offsetY = aircraft.orginPos.x;
            int offsetX = aircraft.orginPos.y;
            
            for (int row = offsetX, aRow = 0; row < offsetX + 5; row++, aRow++)
            {
                for (int col = offsetY, aCol = 0; col < offsetY + 5; col++, aCol++)
                {
                    if ([aircraft elementAtRow:aRow col:aCol] != AircraftNone &&
                        _battleFieldGrid[row][col] != AircraftNone)
                        return NO;
                }
            }
            return YES;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        _aircraftModelAry = [NSMutableArray array];
        return YES;
    }
}

@end
