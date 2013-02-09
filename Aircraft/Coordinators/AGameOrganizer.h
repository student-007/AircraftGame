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
#import "AChattingMessageItem.h"
#import "AGuideViewController.h"

typedef enum
{
    AWhosTurnNone           = 0,
    AWhosTurnUser           = 1,
    AWhosTurnCompetitor     = 2
}AWhosTurn;

@interface AGameOrganizer : NSObject<ChatViewDelegate, communicatorListenerDelegate, AOperationPanelViewControllerOperationDelegate, ABattleFieldOrganizerDelegate, AGuideViewControllerDelegate>
{
    // game status data
    NSNumber *_numberOfAircraftPlaced;
    
    BOOL _isGameBegin;  // default is NO
    NSDate *_dateWhenGameBegin;
    NSDate *_dateWhenGameEnd;
    
    NSMutableDictionary *_userStatus;
    NSMutableDictionary *_competitorStatus;
}

#define kGameStatusNetWork          @"netWorkStatus"            // (NSNumber)type(ConnectionType), (NSNumber)isConnect
#define kGameStatusAircraftPlaced   @"aircraftPlacingStatus"    // no key, NSNumber object for how may aircraft placed
#define kGameStatusBeginEndGame     @"beginGameStatus"          // keys: isGameOn, beginDate, endDate
#define kGameStatusPlayer           @"playerStatus"             // keys: user(isReady, date), competitor(isReady, date)
@property (strong, nonatomic, readonly) NSDictionary *gameStatus;

@property (nonatomic, readonly) AWhosTurn whosTurn;             // default: AWhosTurnNone

@property (nonatomic) ConnectionType connectionType;
@property (strong, nonatomic) ACommunicator *communicator;

+ (AGameOrganizer *)sharedInstance;

- (AChattingViewController *)getChatVC;
- (ABattleFieldViewController *)getBattleFieldVCFaction:(BattleFieldType)faction;
- (AOperationPanelViewController *)getOperationPanelVC;

- (void)reset;

- (void)makeConnectionWithType:(ConnectionType)type;

@end
