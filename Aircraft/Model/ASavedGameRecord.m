//
//  ASavedGameRecord.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-21.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "ASavedGameRecord.h"

@implementation ASavedGameRecord

@synthesize selfAircrafts = _selfAircrafts;
@synthesize enemyAircrafts = _enemyAircrafts;
@synthesize selfAttackRecords = _selfAttackRecords;
@synthesize enemyAttackRecords = _enemyAttackRecords;
@synthesize chattingRecords = _chattingRecords;
@synthesize startTimeSec = _startTimeSec;
@synthesize totalTimeSec = _totalTimeSec;
@synthesize selfTotalTimeSec = _selfTotalTimeSec;
@synthesize enemyTotalTimeSec = _enemyTotalTimeSec;
@synthesize isMyTurn = _isMyTurn;
@synthesize competitorName = _competitorName;
@synthesize gameId = _gameId;
@synthesize isFavorite = _isFavorite;

- (NSDictionary *)savableDictionaryRecord
{
    NSMutableDictionary *gameRecord = [NSMutableDictionary dictionary];
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.selfAircrafts, @"selfAircrafts");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.enemyAircrafts, @"enemyAircrafts");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.selfAttackRecords, @"selfAttackRecords");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.enemyAttackRecords, @"enemyAttackRecords");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.chattingRecords, @"chattingRecords");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.startTimeSec, @"startTimeSec");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.totalTimeSec, @"totalTimeSec");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.selfTotalTimeSec, @"selfTotalTimeSec");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.enemyTotalTimeSec, @"enemyTotalTimeSec");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.isMyTurn, @"isMyTurn");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.competitorName, @"competitorName");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.gameId, @"gameId");
    return gameRecord;
}

- (void)fillWithDictionaryRecord:(NSDictionary *)gameRecord
{
    DICT_GET_OBJECT(gameRecord, self.selfAircrafts, @"selfAircrafts");
    DICT_GET_OBJECT(gameRecord, self.enemyAircrafts, @"enemyAircrafts");
    DICT_GET_OBJECT(gameRecord, self.selfAttackRecords, @"selfAttackRecords");
    DICT_GET_OBJECT(gameRecord, self.enemyAttackRecords, @"enemyAttackRecords");
    DICT_GET_OBJECT(gameRecord, self.chattingRecords, @"chattingRecords");
    DICT_GET_OBJECT(gameRecord, self.startTimeSec, @"startTimeSec");
    DICT_GET_OBJECT(gameRecord, self.totalTimeSec, @"totalTimeSec");
    DICT_GET_OBJECT(gameRecord, self.selfTotalTimeSec, @"selfTotalTimeSec");
    DICT_GET_OBJECT(gameRecord, self.enemyTotalTimeSec, @"enemyTotalTimeSec");
    DICT_GET_OBJECT(gameRecord, self.isMyTurn, @"isMyTurn");
    DICT_GET_OBJECT(gameRecord, self.competitorName, @"competitorName");
    DICT_GET_OBJECT(gameRecord, self.gameId, @"gameId");
}

@end
