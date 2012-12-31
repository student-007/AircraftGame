//
//  ANetMessage.m
//  Aircraft
//
//  Created by Yufei Lang on 12/25/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "ANetMessage.h"

@implementation ANetMessage

@synthesize sender = _sender;
@synthesize flag = _flag;
@synthesize message = _message;
@synthesize count = _count;
@synthesize timestamp = _timestamp;

+ (ANetMessage *)messageWithFlag:(NSString *)flag message:(id)message
{
    ANetMessage *msg = [[ANetMessage alloc] init];
    msg.flag = flag;
    msg.message = message;
    return msg;
}

@end






#pragma mark - base request/reply message

@implementation ANetMessageBaseMessage
@end

@implementation ANetMessageBaseReply
@synthesize isDelivered = _isDelivered;
@end

#pragma mark - initial message

@implementation ANetMessageInitial
@synthesize isHost = _isHost;
@synthesize aircrafts = _aircrafts;
@end

@implementation ANetMessageInitialR
@synthesize isHost = _isHost;
@synthesize aircrafts = _aircrafts;
@end

#pragma mark - attack message

@implementation ANetMessageAttack
@synthesize row = _row;
@synthesize col = _col;
@synthesize tools = _tools;
@end

@implementation ANetMessageAttackR
@synthesize attackResult = _attackResult;
@synthesize toolsResult = _toolsResult;
@end


#pragma mark - chat message

@implementation ANetMessageChat
@synthesize sender = _sender;
@synthesize message = _message;

+ (ANetMessageChat *)message:(NSString *)message andSenderName:(NSString *)senderName
{
    ANetMessageChat *msg = [[ANetMessageChat alloc] init];
    msg.message = message;
    msg.sender = senderName;
    return msg;
}
@end

@implementation ANetMessageChatR
@end

#pragma mark - surrender message

@implementation ANetMessageSurrender
@end

@implementation ANetMessageSurrenderR
@end

#pragma mark - save message

@implementation ANetMessageSave
@synthesize isMyTurn = _isMyTurn;
@synthesize gameId = _gameId;
@synthesize attackRecords = _attackRecords;
@end

@implementation ANetMessageSaveR
@synthesize isMyTurn = _isMyTurn;
@synthesize gameId = _gameId;
@synthesize attackRecords = _attackRecords;
@end


