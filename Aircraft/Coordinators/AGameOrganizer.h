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
#import "ABattleFieldViewController.h"

@interface AGameOrganizer : NSObject<ChatViewDelegate, communicatorListenerDelegate, ABattleFieldVCDelegate>

@property (nonatomic) ConnectionType connectionType;
@property (strong, nonatomic) ACommunicator *communicator;

+ (AGameOrganizer *)sharedInstance;

- (AChattingViewController *)getChatVC;
- (ABattleFieldViewController *)getBattleFieldVCFaction:(BattleFieldType)faction;

- (void)reset;

- (void)makeConnectionWithType:(ConnectionType)type;

@end
