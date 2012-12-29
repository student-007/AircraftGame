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

typedef enum
{
    ConnectionTypeBluetooth     = 1
}ConnectionType;

@interface ACommunicator : NSObject<connectionListener>
{
    id _Conn;
    AMessageParser *_msgParser;
}

+ (ACommunicator *)sharedInstance;

- (void)makeConnWithType:(ConnectionType)type;
- (BOOL)sendMessage:(id)message;

@end
