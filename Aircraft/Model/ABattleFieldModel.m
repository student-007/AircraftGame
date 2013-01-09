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

@end
