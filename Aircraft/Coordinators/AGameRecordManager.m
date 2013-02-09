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

+ (AGameRecordManager *)sharedInstance
{
    static AGameRecordManager *sharedInstance = nil;
    if (sharedInstance == nil) 
    {
        sharedInstance = [[AGameRecordManager alloc] init];
    }
    return sharedInstance;
}

@end
