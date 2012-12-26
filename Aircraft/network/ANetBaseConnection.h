//
//  ANetBaseConnection.h
//  Aircraft
//
//  Created by Yufei Lang on 12/25/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol connectionListener <NSObject>
- (void)connectionEstablished;
- (void)connectionDisconnected;
- (void)receivedData:(NSData *)data;
@end

@interface ANetBaseConnection : NSObject
{
    BOOL _isConnect;
}

@property (nonatomic, readonly) BOOL isConnect;
@property (nonatomic, weak) id<connectionListener> listener;

// base class functions [Yufei Lang]
- (void)makeConnection;
- (void)closeConnection;
- (BOOL)sendData:(NSData *)data;

@end
