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
        _type = ConnectionTypeNone;
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

- (void)closeConnection
{
    [_Conn closeConnection];
    _type = ConnectionTypeNone;
    _Conn = nil;
}

- (void)makeConnWithType:(ConnectionType)type
{
    _type = type;
    
    switch (type)
    {
        case ConnectionTypeNone:
        {
            
        }
            break;
        case ConnectionTypeBluetooth:
        {
            _Conn = [[ANetConnBluetooth alloc] init];
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
    {
        switch (_type)
        {
            case ConnectionTypeNone:
            {
                return NO;
            }
                break;
            case ConnectionTypeBluetooth:
            {
                return [((ANetConnBluetooth *)_Conn) sendData:[_msgParser prepareMessage:message]];
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
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
        NSAssert(NO, [AErrorFacade errorMessageFromKnownErrorCode:kECConnCanceledByUser]);
    }
}

@end
