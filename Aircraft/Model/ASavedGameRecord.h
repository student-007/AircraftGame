//
//  ASavedGameRecord.h
//  Aircraft
//
//  Created by Yufei Lang on 13-2-21.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASavedGameRecord : NSObject

@property (nonatomic, strong) NSArray *selfAircrafts;
@property (nonatomic, strong) NSArray *enemyAircrafts;

@property (nonatomic, strong) NSArray *selfAttackRecords;
@property (nonatomic, strong) NSArray *enemyAttackRecords;

@property (nonatomic, strong) NSArray *chattingRecords;

@property (nonatomic, strong) NSNumber *startTimeSec; // seconds since 1970
@property (nonatomic, strong) NSNumber *totalTimeSec;
@property (nonatomic, strong) NSNumber *selfTotalTimeSec;
@property (nonatomic, strong) NSNumber *enemyTotalTimeSec;

@property (nonatomic, strong) NSNumber *isMyTurn;
@property (nonatomic, strong) NSNumber *isFavorite;
@property (nonatomic, strong) NSString *competitorName;
@property (nonatomic, strong) NSString *gameId;

- (NSDictionary *)savableDictionaryRecord;
- (void)fillWithDictionaryRecord:(NSDictionary *)gameRecord;

@end
