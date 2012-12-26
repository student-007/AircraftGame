//
//  ANetMessage.h
//  Aircraft
//
//  Created by Yufei Lang on 12/25/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFlagInitial        @"initial"
#define kFlagInitialR       @"initialR"
#define kFlagAttack         @"attack"
#define kFlagAttackR        @"attackR"
#define kFlagChat           @"chat"
#define kFlagChatR          @"chatR"
#define kFlagSurrender      @"surrender"
#define kFlagSurrenderR     @"surrenderR"
#define kFlagSave           @"save"
#define kFlagSaveR          @"saveR"
#define kFlagLoad           @"load"
#define kFlagLoadR          @"loadR"

@interface ANetMessage : NSObject

@property (strong, nonatomic) NSString *flag;
@property (strong, nonatomic) NSDictionary *message;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSDate *timestamp;

@end
