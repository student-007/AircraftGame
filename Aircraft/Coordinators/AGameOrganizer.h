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
#import "AOperationPanelViewController.h"

@interface AGameOrganizer : NSObject<ChatViewDelegate, communicatorListenerDelegate, ABattleFieldVCDelegate, AOperationPanelViewControllerOperationDelegate, ABattleFieldOrganizerDelegate>
{
    NSNumber *_numberOfAircraftPlaced;
}

#define kGameStatusNetWork  @"netWorkStatus"
#define kGameStatusAircraftPlaced  @"aircraftPlacingStatus"
@property (strong, nonatomic, readonly) NSDictionary *gameStatus;

@property (nonatomic) ConnectionType connectionType;
@property (strong, nonatomic) ACommunicator *communicator;

+ (AGameOrganizer *)sharedInstance;

- (AChattingViewController *)getChatVC;
- (ABattleFieldViewController *)getBattleFieldVCFaction:(BattleFieldType)faction;
- (AOperationPanelViewController *)getOperationPanelVC;

- (void)reset;

- (void)makeConnectionWithType:(ConnectionType)type;

@end
