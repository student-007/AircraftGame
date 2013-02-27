//
//  ABattleResultInfoModel.m
//  Aircraft
//
//  Created by Yufei Lang on 2/25/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "ABattleResultInfoModel.h"

@implementation ABattleResultInfoModel

@synthesize gameId = _gameId;
@synthesize competitorName = _competitorName;
@synthesize resultString = _resultString;
@synthesize battleBeginDate = _battleBeginDate;
@synthesize battleEndDate = _battleEndDate;
@synthesize selfNumberOfAttacks = _selfNumberOfAttacks;
@synthesize selfNumberOfHits = _selfNumberOfHits;
@synthesize enemyNumberOfAttacks = _enemyNumberOfAttacks;
@synthesize enemyNumberOfHits = _enemyNumberOfHits;
@synthesize timeSpentUser = _timeSpentUser;
@synthesize timeSpentOpponent = _timeSpentOpponent;

@end
