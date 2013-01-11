//
//  AGameOrganizer.m
//  Aircraft
//
//  Created by Yufei Lang on 1/1/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "AGameOrganizer.h"

@interface AGameOrganizer ()

@property (strong, nonatomic) AChattingViewController *chatVC;
@property (strong, nonatomic) ABattleFieldViewController *BattleFldVCEnemy;
@property (strong, nonatomic) ABattleFieldViewController *BattleFldVCSelf;

@end

@implementation AGameOrganizer

- (void)reset
{
    [self.communicator closeConnection];
    self.chatVC = nil;
    
}

#pragma mark - communication controls

- (void)makeConnectionWithType:(ConnectionType)type;
{
    if (!self.communicator)
    {
        self.communicator = [ACommunicator sharedInstance];
        self.communicator.delegate = self;
    }
    
    switch (type)
    {
        case ConnectionTypeNone:
        {
            
        }
            break;
        case ConnectionTypeBluetooth:
        {
            [self.communicator makeConnWithType:ConnectionTypeBluetooth];
        }
            break;
//        case AConnectionBluetooth:
//        {
//        }
//            break;
        default:
            break;
    }
}

// connection delegates

- (void)connectionEstablished
{
    
}

- (void)connectionDisconnected:(NSError *)errorOrNil
{
    
}

- (void)receivedNetMessage:(ANetMessage *)netMessage
{
    if ([netMessage.flag isEqualToString:kFlagInitial])
    {
        
    }
    else if ([netMessage.flag isEqualToString:kFlagInitialR])
    {
        
    }
    else if ([netMessage.flag isEqualToString:kFlagAttack])
    {
        
    }
    else if ([netMessage.flag isEqualToString:kFlagAttackR])
    {
        
    }
    else if ([netMessage.flag isEqualToString:kFlagChat])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chatting Message"
                                                        message:((ANetMessageChat *)netMessage.message).message
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([netMessage.flag isEqualToString:kFlagChatR])
    {
        
    }
    else if ([netMessage.flag isEqualToString:kFlagSurrender])
    {
        
    }
    else if ([netMessage.flag isEqualToString:kFlagSurrenderR])
    {
        
    }
    else if ([netMessage.flag isEqualToString:kFlagSave])
    {
        
    }
    else if ([netMessage.flag isEqualToString:kFlagSaveR])
    {
        
    }
    else if ([netMessage.flag isEqualToString:kFlagLoad])
    {
        // netMessage.message is nil here
    }
    else if ([netMessage.flag isEqualToString:kFlagLoadR])
    {
        // netMessage.message is nil here
    }
//    else
//        NSAssert(NO, [AErrorFacade errorMessageFromKnownErrorCode:kECParserCantFindFlag]);
}

- (void)connectionCanceled:(NSError *)errorOrNil
{
    self.chatVC = nil;
    
}

#pragma mark - battle field view controls

- (ABattleFieldViewController *)getBattleFieldVCFaction:(BattleFieldType)faction
{
    if (faction == BattleFieldEnemy)
    {
        if (!self.BattleFldVCEnemy)
        {
            self.BattleFldVCEnemy = [[ABattleFieldViewController alloc] initWithNibName:@"ABattleFieldViewController" bundle:nil];
            self.BattleFldVCEnemy.faction = faction;
            self.BattleFldVCEnemy.delegate = self;
        }
        
        return self.BattleFldVCEnemy;
    }
    else if (faction == BattleFieldSelf)
    {
        if (!self.BattleFldVCSelf)
        {
            self.BattleFldVCSelf = [[ABattleFieldViewController alloc] initWithNibName:@"ABattleFieldViewController" bundle:nil];
            self.BattleFldVCSelf.faction = faction;
            self.BattleFldVCSelf.delegate = self;
        }
        
        return self.BattleFldVCSelf;
    }
    else
        return nil;
}

- (void)userWantsToSwitchFieldFrom:(ABattleFieldViewController *)currentBattleField
{
#warning TODO: implemention required
}

/*!
 @discussion this method will be called when user drag aircraft off the field and try to removed the aircraft, return YES to allow this operation, otherwize aircraft won't be removed.
 */
- (BOOL)userWantsToRemoveAircraft:(AAircraftModel *)aircraft
{
#warning TODO: implemention required
}

/*!
 @discussion this point is the row and col in grid(intgers value)
 */
- (void)userTappedBattleFieldGridAtPoint:(CGPoint)point
{
#warning TODO: implemention required
}

#pragma mark - chatting view controls

- (AChattingViewController *)getChatVC
{
    if (!self.chatVC)
    {
        self.chatVC = [[AChattingViewController alloc] initWithNibName:@"AChattingViewController" bundle:nil];
        self.chatVC.delegate = self;
    }
    
    return self.chatVC;
}

/*
 - (void)setNickNameForUser:(NSString *)userName andCompetitor:(NSString *)competitorName;
 - (void)resignTxtFldFirstResponder;
 - (void)receivedNewChattingMsg:(ANetMessageChat *)message;
 */

#pragma mark - chat view protocol/delegate

- (void)userWantsToSendChatMsg:(ANetMessageChat *)message
{
    ANetMessage *msg = [ANetMessage messageWithFlag:kFlagChat message:message];
    if (self.communicator)
        [self.communicator sendMessage:msg];
    else
        [AErrorFacade errorWithDomain:kErrorDomainOrganizer knownCode:kECOrganizerCommunicatorNotFoundOrEnpty];
}

- (void)userInputCheatCode:(NSString *)cheatCode
{
#warning TODO: handle the cheat code
}

@end
