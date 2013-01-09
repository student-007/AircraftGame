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

@interface ABattleFieldModel : NSObject

@property (nonatomic) CGPoint attackPoint;
@property (nonatomic) BattleFieldType type;     // default: BattleFieldNone

- (void)addAttackRecordPoint;//:(CGPoint)attackPoint;

@end
