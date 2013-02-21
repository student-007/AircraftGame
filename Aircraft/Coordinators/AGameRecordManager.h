//
//  AGameRecordManager.h
//  Aircraft
//
//  Created by Yufei Lang on 13-2-7.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASavedGameRecord.h"

typedef enum
{
    AActionTypeNone         = 0,
    AActionTypeUserAction   = 1,
    AActionTypeCompetitorAction = 2
}ASaveGameActionType;

@interface AGameRecordManager : NSObject
{
    ASaveGameActionType _actionType; // Default: AActionTypeNone
}

#define kNotificationGameSaved          @"gameRecordSaved"
#define kNotificationSaveGameFailed     @"saveGameFailed"

// if saving game is user's will or response the save message. Default: AActionTypeNone
@property (nonatomic) ASaveGameActionType actionType;

@property (nonatomic, strong) ASavedGameRecord *sharedGameRecord;

+ (AGameRecordManager *)sharedInstance;

- (void)saveGameToFile;

@end
 