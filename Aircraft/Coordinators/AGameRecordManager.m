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
    
    NSDictionary *gameRecord = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.selfAircrafts, @"selfAircrafts",
                                self.enemyAircrafts, @"enemyAircrafts",
                                self.selfAttackRecords, @"selfAttackRecords",
                                self.enemyAttackRecords, @"enemyAttackRecords",
                                self.playTime, @"playTime",
                                self.isMyTurn, @"isMyTurn", 
                                self.competitorName, @"competitorName", nil];
    
    BOOL isSaved = [gameRecord writeToFile:savedGameDirPath atomically:YES];
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
}

@end
