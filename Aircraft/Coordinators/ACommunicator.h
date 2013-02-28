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
#import "ACommunicationDetail.h"

@protocol communicatorListenerDelegate;

@interface ACommunicator : NSObject<connectionListenerDelegate>
{
    id<connectionOperationProtocol> _conn;
    ConnectionType _type;
    AMessageParser *_msgParser;
}

@property (assign, nonatomic) id<communicatorListenerDelegate> delegate;
@property (nonatomic, readonly) ConnectionType type;
@property (nonatomic, readonly) BOOL isConnect;

+ (ACommunicator *)sharedInstance;

- (void)makeConnWithType:(ConnectionType)type;
- (void)closeConnection;
- (BOOL)sendMessage:(id)message;

@end



@protocol communicatorListenerDelegate <NSObject>
@optional
- (void)connectionEstablishedWith:(NSString *)name;
- (void)connectionDisconnected:(NSError *)errorOrNil;
- (void)connectionCanceled:(NSError *)errorOrNil;

@required
- (void)receivedNetMessage:(ANetMessage *)netMessage;
@end
