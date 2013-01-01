//
//  AGameOrganizer.h
//  Aircraft
//
//  Created by Yufei Lang on 1/1/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACommunicator.h"
#import "AChattingViewController.h"

@interface AGameOrganizer : NSObject<ChatViewDelegate, communicatorListenerDelegate>

@property (strong, nonatomic) ACommunicator *communicator;

- (AChattingViewController *)getChatVC;

- (void)reset;

- (void)makeConnectionWithType:(ConnectionType)type;

@end
