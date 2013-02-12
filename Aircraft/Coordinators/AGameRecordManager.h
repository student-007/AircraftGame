//
//  AGameRecordManager.h
//  Aircraft
//
//  Created by Yufei Lang on 13-2-7.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGameRecordManager : NSObject

@property (nonatomic, strong) NSArray *selfAircrafts;
@property (nonatomic, strong) NSArray *enemyAircrafts;

@property (nonatomic, strong) NSArray *selfAttackRecords;
@property (nonatomic, strong) NSArray *enemyAttackRecords;

@property (nonatomic, strong) NSMutableDictionary *playTime;    //keys: startTime, totalTime, selfTotalTime, enemyTotalTime

@property (nonatomic, strong) NSNumber *isMyTurn;

+ (AGameRecordManager *)sharedInstance;

- (void)saveGameToFile;

@end
 