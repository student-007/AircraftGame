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

#define kAttackRMiss        @"miss"
#define kAttackRHit         @"hit"
#define kAttackRDestroy     @"destroy"

#define kSurrenderTypeLost  @"surrenderTypeLost"
#define kSurrenderTypeEscape  @"surrenderTypeEscape"

@interface ANetMessage : NSObject

@property (strong, nonatomic) NSString *sender;
@property (strong, nonatomic) NSString *flag;
@property (strong, nonatomic) id message;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSDate *timestamp;

+ (ANetMessage *)messageWithFlag:(NSString *)flag message:(id)message;

@end

#pragma mark - base request/reply message

@interface ANetMessageBaseMessage : NSObject
@end

@interface ANetMessageBaseReply : NSObject
@property (nonatomic) BOOL isDelivered;
@end

#pragma mark - initial message
@interface ANetMessageInitial : ANetMessageBaseMessage
@property (nonatomic) BOOL isHost;
@property (strong, nonatomic) NSArray *aircrafts;
@property (strong, nonatomic) NSString *gameId;
@end

@interface ANetMessageInitialR : ANetMessageBaseReply
@property (nonatomic) BOOL isHost;
@property (strong, nonatomic) NSArray *aircrafts;
@end

#pragma mark - attack message

@interface ANetMessageAttack : ANetMessageBaseMessage
@property (strong, nonatomic) NSNumber *row;
@property (strong, nonatomic) NSNumber *col;
@property (strong, nonatomic) NSArray *tools;
@end

@interface ANetMessageAttackR : ANetMessageBaseReply
@property (strong, nonatomic) NSString *attackResult;
@property (strong, nonatomic) NSArray *toolsResult;
@end


#pragma mark - chat message

@interface ANetMessageChat : ANetMessageBaseMessage
@property (strong, nonatomic) NSString *sender;         // can be NULL
@property (strong, nonatomic) NSString *message;

+ (ANetMessageChat *)message:(NSString *)message andSenderName:(NSString *)senderName;
@end

@interface ANetMessageChatR : ANetMessageBaseReply
@end

#pragma mark - surrender message

@interface ANetMessageSurrender : ANetMessageBaseMessage
@property (strong, nonatomic) NSString *type;           // lose, escape
@end

@interface ANetMessageSurrenderR : ANetMessageBaseReply
@end

#pragma mark - save message

@interface ANetMessageSave : ANetMessageBaseMessage
@property (nonatomic) BOOL isMyTurn;
@property (strong, nonatomic) NSString *gameId;
@property (strong, nonatomic) NSArray *attackRecords;   // [[NSNumber, NSNumber],[NSNumber, NSNumber]...]
@end

@interface ANetMessageSaveR : ANetMessageBaseReply
@property (nonatomic) BOOL isMyTurn;
@property (strong, nonatomic) NSString *gameId;
@property (strong, nonatomic) NSArray *attackRecords;
@end
