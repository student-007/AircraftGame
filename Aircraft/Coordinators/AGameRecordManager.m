//
//  AGameRecordManager.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-7.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "AGameRecordManager.h"

#define kSavedFileNameSeparator     @"$with$"

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
@synthesize gameId = _gameId;
@synthesize actionType = _actionType;

+ (AGameRecordManager *)sharedInstance
{
    static AGameRecordManager *sharedInstance = nil;
    if (sharedInstance == nil) 
    {
        sharedInstance = [[AGameRecordManager alloc] init];
    }
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) 
    {
        _actionType = AActionTypeNone;
    }
    
    return self;
}

- (void)saveGameToFile
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *savedGameDirPath = [documentPath stringByAppendingPathComponent:@"savedGame"];
    BOOL isDirectory = NO;
    if (![fileMgr fileExistsAtPath:savedGameDirPath isDirectory:&isDirectory]) 
    {
        NSError *error = nil;
        if (![fileMgr createDirectoryAtPath:savedGameDirPath withIntermediateDirectories:YES attributes:nil error:&error])
        {
            [AErrorFacade LogError:error];
            return;
        }
    }
    else
    {
        if (!isDirectory) // in case it is a normal file but directory
        {
            NSError *error = nil;
            if (![fileMgr createDirectoryAtPath:savedGameDirPath withIntermediateDirectories:YES attributes:nil error:&error])
            {
                [AErrorFacade LogError:error];
                return;
            }
        }
    }
    
    savedGameDirPath = [savedGameDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@.sav", 
                                                                         self.gameId, kSavedFileNameSeparator, self.competitorName]];
    
    NSMutableDictionary *gameRecord = [NSMutableDictionary dictionary];
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.selfAircrafts, @"selfAircrafts");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.enemyAircrafts, @"enemyAircrafts");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.selfAttackRecords, @"selfAttackRecords");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.enemyAttackRecords, @"enemyAttackRecords");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.playTime, @"playTime");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.isMyTurn, @"isMyTurn");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.competitorName, @"competitorName");
    DICT_SETOBJECT_IFAVAILABLE(gameRecord, self.gameId, @"gameId");
    
    BOOL isSaved = [gameRecord writeToFile:savedGameDirPath atomically:YES];
    if (isSaved) 
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGameSaved object:self userInfo:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSaveGameFailed object:self userInfo:nil];
    }
}

@end
