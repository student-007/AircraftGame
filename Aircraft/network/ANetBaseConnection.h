//
//  ANetBaseConnection.h
//  Aircraft
//
//  Created by Yufei Lang on 12/25/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol connectionListenerDelegate <NSObject>
@required
- (void)connectionEstablishedWith:(NSString *)name;
- (void)connectionDisconnected:(NSError *)errorOrNil;
- (void)receivedData:(NSData *)data;
@optional
- (void)connectionCanceled:(NSError *)errorOrNil;
- (void)connectionFailedWithError:(NSError *)errorOrNil;
@end

@protocol connectionOperationProtocol <NSObject>
@required
@property (nonatomic, readonly) BOOL isConnect;
- (void)makeConnection;
- (void)closeConnection;
- (BOOL)sendData:(NSData *)data;
@optional
- (void)setListener:(id<connectionListenerDelegate>)listener;
@end

@interface ANetBaseConnection : NSObject<connectionOperationProtocol>
{
    BOOL _isConnect;
}

@property (nonatomic, weak) id<connectionListenerDelegate> listener;

- (void)makeConnection;
- (void)closeConnection;
- (BOOL)sendData:(NSData *)data;
@end
