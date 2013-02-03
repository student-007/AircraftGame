//
//  ACommunicator.m
//  Aircraft
//
//  Created by Yufei Lang on 12/28/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "ACommunicator.h"

@interface ACommunicator ()

@property (strong, nonatomic) id<connectionOperationProtocol> conn;

@end

@implementation ACommunicator

@synthesize conn = _conn;
@synthesize delegate = _delegate;
@synthesize type = _type;

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

- (BOOL)isConnect
{
    return self.conn.isConnect;
}

- (void)closeConnection
{
    [self.conn closeConnection];
    _type = ConnectionTypeNone;
    self.conn = nil;
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
            self.conn = [[ANetConnBluetooth alloc] init];
            [self.conn setListener:self];
            [self.conn makeConnection];
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
                return [((ANetConnBluetooth *)self.conn) sendData:[_msgParser prepareMessage:message]];
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

- (void)connectionEstablishedWith:(NSString *)name
{
    if ([self.delegate respondsToSelector:@selector(connectionEstablishedWith:)])
    {
        [self.delegate connectionEstablishedWith:name];
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
    if ([self.delegate respondsToSelector:@selector(receivedNetMessage:)])
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

- (void)connectionFailedWithError:(NSError *)errorOrNil
{
    if (errorOrNil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALocalisedString(@"connection_failed")
                                                        message:[NSString stringWithFormat:@"%@. %@", errorOrNil.localizedFailureReason, ALocalisedString(@"please_try_again")]
                                                       delegate:nil
                                              cancelButtonTitle:ALocalisedString(@"ok")
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALocalisedString(@"connection_failed")
                                                        message:[NSString stringWithFormat:@"%@", ALocalisedString(@"please_try_again")]
                                                       delegate:nil
                                              cancelButtonTitle:ALocalisedString(@"ok")
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
