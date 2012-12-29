//
//  ACommunicator.m
//  Aircraft
//
//  Created by Yufei Lang on 12/28/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "ACommunicator.h"

@implementation ACommunicator

- (id)init
{
    if (self = [super init])
    {
        _msgParser = [[AMessageParser alloc] init];
    }
    return self;
}

+ (ACommunicator *)sharedInstance
{
    static ACommunicator *communicator = nil;
    
    if (!communicator)
    {
        communicator = [[ACommunicator alloc]init];
    }
    return  communicator;
}

- (void)makeConnWithType:(ConnectionType)type
{
    switch (type) {
        case ConnectionTypeBluetooth:
        {
            _Conn = [[ANetConnBluetooth alloc] init];
//            ((ANetConnBluetooth *)_Conn).listener = self;
            [_Conn setListener:self];
            [_Conn makeConnection];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)sendMessage:(id)message
{
    if (_msgParser)
        return [((ANetConnBluetooth *)_Conn) sendData:[_msgParser prepareMessage:message]];
    else
    {
        NSAssert(NO, [AErrorFacade errorMessageFromKnownErrorCode:kECConnCanceledByUser]);
        return NO;
    }
}

#pragma mark - connectionListener protocol/delegate

- (void)connectionEstablished
{
    ANetMessageChat *interalMsg = [[ANetMessageChat alloc] init];
    interalMsg.message = @"let us talk!";
    
    ANetMessage *msg = [ANetMessage messageWithFlag:kFlagChat message:interalMsg];
    [self sendMessage:msg];
}

- (void)connectionDisconnected:(NSError *)errorOrNil
{
    
}

- (void)receivedData:(NSData *)data
{
    ANetMessage *msg = [_msgParser parseData:data];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg.flag
                                                    message:((ANetMessageChat *)msg.message).message
                                                   delegate:nil
                                          cancelButtonTitle:@"cancel"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)connectionCanceled:(NSError *)errorOrNil
{
    
}

@end
