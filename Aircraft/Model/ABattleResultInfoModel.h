//
//  ABattleResultInfoModel.h
//  Aircraft
//
//  Created by Yufei Lang on 2/25/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABattleResultInfoModel : NSObject

@property (strong, nonatomic) NSString *gameId; // battle start time. seconds from year 1970
@property (strong, nonatomic) NSString *competitorName;
@property (strong, nonatomic) NSString *resultString;
@property (strong, nonatomic) NSDate *battleBeginDate;
@property (strong, nonatomic) NSDate *battleEndDate;

@property (nonatomic) NSInteger selfNumberOfAttacks;
@property (nonatomic) NSInteger selfNumberOfHits;
@property (nonatomic) NSInteger enemyNumberOfAttacks;
@property (nonatomic) NSInteger enemyNumberOfHits;

@end
