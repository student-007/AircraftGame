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
        _delegate = nil;
    }
    return self;
}

+ (ACommunicator *)sharedInstance
{
    static ACommunicator *communicator = nil;
    
    if (!communicator)
    {
        communicator = [[ACommunicator alloc] init];
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
    if ([self.delegate respondsToSelector:@selector(connectionEstablished)])
    {
        [self.delegate connectionEstablished];
    }
}

- (void)connectionDisconnected:(NSError *)errorOrNil
{
    if ([self.delegate respondsToSelector:@selector(connectionDisconnected:)])
    {
        [self.delegate connectionDisconnected:errorOrNil];
    }
    else
    {
        
    }
}

- (void)receivedData:(NSData *)data
{
    if ([self.delegate respondsToSelector:@selector(receivedData:)])
    {
        ANetMessage *msg = [_msgParser parseData:data];
        [self.delegate receivedNetMessage:msg];
    }
    else
    {
        
    }
}

- (void)connectionCanceled:(NSError *)errorOrNil
{
    if ([self.delegate respondsToSelector:@selector(connectionCanceled:)])
    {
        [self.delegate connectionCanceled:errorOrNil];
    }
    else
    {
        
    }
}

@end
