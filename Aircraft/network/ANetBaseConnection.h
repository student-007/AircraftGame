//
//  ANetBaseConnection.h
//  Aircraft
//
//  Created by Yufei Lang on 12/25/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface ANetBaseConnection : NSObject

@property (nonatomic, readonly) BOOL isConnect;

// base class functions [Yufei Lang]
- (void)makeConnection;
- (void)closeConnection;
- (BOOL)sendData:(NSData *)data;

@end
