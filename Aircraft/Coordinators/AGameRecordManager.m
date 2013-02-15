//
//  AGameRecordManager.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-7.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "AGameRecordManager.h"

@interface AGameRecordManager()
{
}

@end

@implementation AGameRecordManager

@synthesize selfAircrafts = _selfAircrafts;
@synthesize enemyAircrafts = _enemyAircrafts;
@synthesize selfAttackRecords = _selfAttackRecords;
@synthesize enemyAttackRecords = _enemyAttackRecords;
@synthesize playTime = _playTime;    //keys: startTime, totalTime, selfTotalTime, enemyTotalTime
@synthesize isMyTurn = _isMyTurn;
@synthesize competitorName = _competitorName;

+ (AGameRecordManager *)sharedInstance
{
    static AGameRecordManager *sharedInstance = nil;
    if (sharedInstance == nil) 
    {
        sharedInstance = [[AGameRecordManager alloc] init];
    }
    return sharedInstance;
}

- (void)saveGameToFile
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *savedGameDirPath = [documentPath stringByAppendingPathComponent:@"savedGame"];
    NSNumber *startTime = [self.playTime valueForKey:@"startTime"];// use start time (seconds since 1970) as saved game file name
    savedGameDirPath = [savedGameDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%.fwith%@.sav", [startTime floatValue], self.competitorName]];
    
    NSDictionary *gameRecord = [NSDictionary dictionary];
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(gameRecord, self.selfAircrafts, @"selfAircrafts");
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(gameRecord, self.enemyAircrafts, @"enemyAircrafts");
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(gameRecord, self.selfAttackRecords, @"selfAttackRecords");
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(gameRecord, self.enemyAttackRecords, @"enemyAttackRecords");
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(gameRecord, self.playTime, @"playTime");
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(gameRecord, self.isMyTurn, @"isMyTurn");
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(gameRecord, self.competitorName, @"competitorName");
    
    BOOL isSaved = [gameRecord writeToFile:savedGameDirPath atomically:YES];
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
}

@end
