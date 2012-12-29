//
//  AMessageParser.m
//  Aircraft
//
//  Created by Yufei Lang on 12/26/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AMessageParser.h"

@implementation AMessageParser

- (ANetMessage *)parseData:(NSData *)data
{
    ANetMessage *msg = [[ANetMessage alloc] init];
    
    NSError *error = nil;
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (!error)
    {
        NSDictionary *internalMsgDic = nil;
        NSString *timestampStr = nil;
        DICT_GET_OBJECT(dicData, msg.flag, kKeyFlag);
        DICT_GET_OBJECT(dicData, internalMsgDic, kKeyValue);
        DICT_GET_OBJECT(dicData, msg.sender, kKeySender);
        DICT_GET_OBJECT(dicData, msg.count, kKeyCount);
        DICT_GET_OBJECT(dicData, timestampStr, kKeyTimestamp);
        
        if ([msg.flag isEqualToString:kFlagInitial])
            msg.message = CREATE_INTERNAL_MSG(ANetMessageInitial, internalMsgDic);
        else if ([msg.flag isEqualToString:kFlagInitialR])
            msg.message = CREATE_INTERNAL_MSG(ANetMessageInitialR, internalMsgDic);
        else if ([msg.flag isEqualToString:kFlagAttack])
            msg.message = CREATE_INTERNAL_MSG(ANetMessageAttack, internalMsgDic);
        else if ([msg.flag isEqualToString:kFlagAttackR])
            msg.message = CREATE_INTERNAL_MSG(ANetMessageAttackR, internalMsgDic);
        else if ([msg.flag isEqualToString:kFlagChat])
            msg.message = CREATE_INTERNAL_MSG(ANetMessageChat, internalMsgDic);
        else if ([msg.flag isEqualToString:kFlagChatR])
            msg.message = CREATE_INTERNAL_MSG(ANetMessageChatR, internalMsgDic);
        else if ([msg.flag isEqualToString:kFlagSurrender])
            msg.message = CREATE_INTERNAL_MSG(ANetMessageSurrender, internalMsgDic);
        else if ([msg.flag isEqualToString:kFlagSurrenderR])
            msg.message = CREATE_INTERNAL_MSG(ANetMessageSurrenderR, internalMsgDic);
        else if ([msg.flag isEqualToString:kFlagSave])
            msg.message = CREATE_INTERNAL_MSG(ANetMessageSave, internalMsgDic);
        else if ([msg.flag isEqualToString:kFlagSaveR])
            msg.message = CREATE_INTERNAL_MSG(ANetMessageSaveR, internalMsgDic);
        else if ([msg.flag isEqualToString:kFlagLoad])
            msg.message = [NSNull null];//CREATE_INTERNAL_MSG(ANetMessageLoad, internalMsgDic);
        else if ([msg.flag isEqualToString:kFlagLoadR])
            msg.message = [NSNull null];//CREATE_INTERNAL_MSG(ANetMessageLoadR, internalMsgDic);
        else
            NSAssert(NO, [AErrorFacade errorMessageFromKnownErrorCode:kECParserCantFindFlag]);
        
        msg.timestamp = [NSDate dateWithTimeIntervalSince1970:[timestampStr doubleValue]];
        
        return msg;
    }
    else
    {
//        NSLog(@"[error]: error while parsing JSON data. reason: %@", error.description);
        [AErrorFacade LogError:error];
        return nil;
    }
}

- (NSData *)prepareDictionaryMessage:(NSDictionary *)message
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:message options:0 error:&error];
    if (!error)
        return data;
    else
    {
//        NSLog(@"[error]: error while preparing JSON dictionary message. reason: %@", error.description);
        [AErrorFacade LogError:error];
        return nil;
    }
}

- (NSData *)prepareMessage:(ANetMessage *)message
{
    NSError *error = nil;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    message.timestamp = [NSDate date];
    NSString *timestampStr = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSDictionary *msgDic = [AMessageParser prepareInternalMsg:message.message];
    
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(dic, message.flag, kKeyFlag);
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(dic, message.sender, kKeySender);
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(dic, msgDic, kKeyValue);
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(dic, message.count, kKeyCount);
    DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(dic, timestampStr, kKeyTimestamp);
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (!error)
        return data;
    else
    {
//        NSLog(@"[error]: error while preparing JSON message. reason: %@", error.description);
        [AErrorFacade LogError:error];
        return nil;
    }
}

+ (NSDictionary *)prepareInternalMsg:(id)InternalMsg
{
    NSMutableDictionary *resDic = nil;
    if ([InternalMsg isKindOfClass:[ANetMessageInitial class]])
    {
        resDic = [NSMutableDictionary dictionary];
        ANetMessageInitial *msg = InternalMsg;
        NSNumber *isHost = [NSNumber numberWithBool:msg.isHost];
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, isHost, @"IS_HOST");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.aircrafts, @"AIRCRAFTS");
        return resDic;
    }
    else if ([InternalMsg isKindOfClass:[ANetMessageInitialR class]])
    {
        resDic = [NSMutableDictionary dictionary];
        ANetMessageInitialR *msg = InternalMsg;
        NSNumber *isHost = [NSNumber numberWithBool:msg.isHost];
        NSNumber *isDelivered = [NSNumber numberWithBool:msg.isDelivered];
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, isHost, @"IS_HOST");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, isDelivered, @"IS_DELIVERED");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.aircrafts, @"AIRCRAFTS");
        return resDic;
    }
    else if ([InternalMsg isKindOfClass:[ANetMessageAttack class]])
    {
        resDic = [NSMutableDictionary dictionary];
        ANetMessageAttack *msg = InternalMsg;
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.row, @"ROW");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.col, @"COL");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.tools, @"TOOLS");
        return resDic;
    }
    else if ([InternalMsg isKindOfClass:[ANetMessageAttackR class]])
    {
        resDic = [NSMutableDictionary dictionary];
        ANetMessageAttackR *msg = InternalMsg;
        NSNumber *isDelivered = [NSNumber numberWithBool:msg.isDelivered];
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.attackResult, @"ATTACK_RESULT");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.toolsResult, @"TOOLS_RESULT");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, isDelivered, @"IS_DELIVERED");
        return resDic;
    }
    else if ([InternalMsg isKindOfClass:[ANetMessageChat class]])
    {
        resDic = [NSMutableDictionary dictionary];
        ANetMessageChat *msg = InternalMsg;
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.sender, @"SENDER");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.message, @"MESSAGE");
        return resDic;
    }
    else if ([InternalMsg isKindOfClass:[ANetMessageChatR class]])
    {
        resDic = [NSMutableDictionary dictionary];
        ANetMessageChatR *msg = InternalMsg;
        NSNumber *isDelivered = [NSNumber numberWithBool:msg.isDelivered];
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, isDelivered, @"IS_DELIVERED");
        return resDic;
    }
    else if ([InternalMsg isKindOfClass:[ANetMessageSurrender class]])
    {
        resDic = [NSMutableDictionary dictionary];
//        ANetMessageSurrender *msg = InternalMsg;
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, [NSNull null], @"EMPTY");
        return resDic;
    }
    else if ([InternalMsg isKindOfClass:[ANetMessageSurrenderR class]])
    {
        resDic = [NSMutableDictionary dictionary];
        ANetMessageSurrenderR *msg = InternalMsg;
        NSNumber *isDelivered = [NSNumber numberWithBool:msg.isDelivered];
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, isDelivered, @"IS_DELIVERED");
        return resDic;
    }
    else if ([InternalMsg isKindOfClass:[ANetMessageSave class]])
    {
        resDic = [NSMutableDictionary dictionary];
        ANetMessageSave *msg = InternalMsg;
        NSNumber *isMyTurn = [NSNumber numberWithBool:msg.isMyTurn];
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.gameId, @"GAME_ID");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.attackRecords, @"ATTACK_RECORDS");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, isMyTurn, @"IS_MY_TURN");
        return resDic;
    }
    else if ([InternalMsg isKindOfClass:[ANetMessageSaveR class]])
    {
        resDic = [NSMutableDictionary dictionary];
        ANetMessageSaveR *msg = InternalMsg;
        NSNumber *isMyTurn = [NSNumber numberWithBool:msg.isMyTurn];
        NSNumber *isDelivered = [NSNumber numberWithBool:msg.isDelivered];
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, isMyTurn, @"IS_MY_TURN");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, isDelivered, @"IS_DELIVERED");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.gameId, @"GAME_ID");
        DICT_SET_OBJECT_NULL_IFNOTAVAILABLE(resDic, msg.attackRecords, @"ATTACK_RECORDS");
        return resDic;
    }
    else
    {
        NSAssert(NO, [AErrorFacade errorMessageFromKnownErrorCode:kECParserCantFindInternalClass]);
        return nil;
    }
}

+ (id)createInternalMsgClass:(Class)msgClass filledWithSource:(id)source
{
    NSString *className = NSStringFromClass(msgClass);
    if ([className isEqualToString:@"ANetMessageInitial"])
    {
        ANetMessageInitial *msg = [[msgClass alloc] init];
        NSNumber *isHost = nil;
        DICT_GET_OBJECT(source, isHost, @"IS_HOST");
        msg.isHost = isHost ? [isHost boolValue] : NO;
        DICT_GET_OBJECT(source, msg.aircrafts, @"AIRCRAFTS");
        return msg;
    }
    else if ([className isEqualToString:@"ANetMessageInitialR"])
    {
        ANetMessageInitialR *msg = [[msgClass alloc] init];
        NSNumber *isHost = nil;
        DICT_GET_OBJECT(source, isHost, @"IS_HOST");
        msg.isHost = isHost ? [isHost boolValue] : NO;
        DICT_GET_OBJECT(source, msg.aircrafts, @"AIRCRAFTS");
        NSNumber *isDelivered = nil;
        DICT_GET_OBJECT(source, isDelivered, @"IS_DELIVERED");
        msg.isDelivered = isDelivered ? [isDelivered boolValue] : NO;
        return msg;
    }
    else if ([className isEqualToString:@"ANetMessageAttack"])
    {
        ANetMessageAttack *msg = [[msgClass alloc] init];
        DICT_GET_OBJECT(source, msg.row, @"ROW");
        DICT_GET_OBJECT(source, msg.col, @"COL");
        DICT_GET_OBJECT(source, msg.tools, @"TOOLS");
        return msg;
    }
    else if ([className isEqualToString:@"ANetMessageAttackR"])
    {
        ANetMessageAttackR *msg = [[msgClass alloc] init];
        DICT_GET_OBJECT(source, msg.attackResult, @"ATTACK_RESULT");
        DICT_GET_OBJECT(source, msg.toolsResult, @"TOOLS_RESULT");
        NSNumber *isDelivered = nil;
        DICT_GET_OBJECT(source, isDelivered, @"IS_DELIVERED");
        msg.isDelivered = isDelivered ? [isDelivered boolValue] : NO;
        return msg;
    }
    else if ([className isEqualToString:@"ANetMessageChat"])
    {
        ANetMessageChat *msg = [[msgClass alloc] init];
        DICT_GET_OBJECT(source, msg.sender, @"SENDER");
        DICT_GET_OBJECT(source, msg.message, @"MESSAGE");
        return msg;
    }
    else if ([className isEqualToString:@"ANetMessageChatR"])
    {
        ANetMessageChatR *msg = [[msgClass alloc] init];
        NSNumber *isDelivered = nil;
        DICT_GET_OBJECT(source, isDelivered, @"IS_DELIVERED");
        msg.isDelivered = isDelivered ? [isDelivered boolValue] : NO;
        return msg;
    }
    else if ([className isEqualToString:@"ANetMessageSurrender"])
    {
        ANetMessageSurrender *msg = [[msgClass alloc] init];
        return msg;
    }
    else if ([className isEqualToString:@"ANetMessageSurrenderR"])
    {
        ANetMessageSurrenderR *msg = [[msgClass alloc] init];
        NSNumber *isDelivered = nil;
        DICT_GET_OBJECT(source, isDelivered, @"IS_DELIVERED");
        msg.isDelivered = isDelivered ? [isDelivered boolValue] : NO;
        return msg;
    }
    else if ([className isEqualToString:@"ANetMessageSave"])
    {
        ANetMessageSave *msg = [[msgClass alloc] init];
        DICT_GET_OBJECT(source, msg.gameId, @"GAME_ID");
        DICT_GET_OBJECT(source, msg.attackRecords, @"ATTACK_RECORDS");
        NSNumber *isMyTurn = nil;
        DICT_GET_OBJECT(source, isMyTurn, @"IS_MY_TURN");
        msg.isMyTurn = isMyTurn ? [isMyTurn boolValue] : NO;
        return msg;
    }
    else if ([className isEqualToString:@"ANetMessageSaveR"])
    {
        ANetMessageSaveR *msg = [[msgClass alloc] init];
        NSNumber *isMyTurn = nil;
        DICT_GET_OBJECT(source, isMyTurn, @"IS_MY_TURN");
        msg.isMyTurn = isMyTurn ? [isMyTurn boolValue] : NO;
        NSNumber *isDelivered = nil;
        DICT_GET_OBJECT(source, isDelivered, @"IS_DELIVERED");
        msg.isDelivered = isDelivered ? [isDelivered boolValue] : NO;
        DICT_GET_OBJECT(source, msg.gameId, @"GAME_ID");
        DICT_GET_OBJECT(source, msg.attackRecords, @"ATTACK_RECORDS");
        return msg;
    }
    else
    {
        NSAssert(NO, [AErrorFacade errorMessageFromKnownErrorCode:kECParserCantFindInternalClass]);
        return nil;
    }
}

@end
