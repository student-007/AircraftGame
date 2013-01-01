//
//  ACommunicator.h
//  Aircraft
//
//  Created by Yufei Lang on 12/28/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANetConnBluetooth.h"
#import "AMessageParser.h"
#import "ANetMessage.h"

typedef enum
{
    ConnectionTypeNone          = 0,
    ConnectionTypeBluetooth     = 1
}ConnectionType;

@protocol communicatorListenerDelegate;

@interface ACommunicator : NSObject<connectionListenerDelegate>
{
    id<connectionOperationProtocol> _Conn;
    ConnectionType _type;
    AMessageParser *_msgParser;
}

@property (assign, nonatomic) id<communicatorListenerDelegate> delegate;

+ (ACommunicator *)sharedInstance;

- (void)makeConnWithType:(ConnectionType)type;
- (void)closeConnection;
- (BOOL)sendMessage:(id)message;
@end



@protocol communicatorListenerDelegate <NSObject>
@optional
- (void)connectionEstablished;
- (void)connectionDisconnected:(NSError *)errorOrNil;
- (void)connectionCanceled:(NSError *)errorOrNil;

@required
- (void)receivedNetMessage:(ANetMessage *)netMessage;
@end
