//
//  AChattingViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 12/29/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANetMessage.h"
#import "AChattingMessageItem.h"


@protocol ChatViewDelegate;

@interface AChattingViewController : UIViewController<UITextFieldDelegate>
{
    NSString *_userName;            // default: Me
    NSString *_competitorName;      // default: Competitor
    NSMutableArray *_chattingRecordsArray; // dictionary inside, keys are :sender and message
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet ATableViewAdapter *tableViewAdapter;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgView;
@property (weak, nonatomic) IBOutlet AUITextField *chatTxtFld;
@property (strong, nonatomic) IBOutlet AUIButton *sendHideBtn;

@property (nonatomic, readonly, getter = isEmptyMsg) BOOL emptyMsg; // if the chatting field is empty
@property (weak, nonatomic) id<ChatViewDelegate> delegate;

- (void)setNickNameForUser:(NSString *)userName andCompetitor:(NSString *)competitorName;
- (void)resignTxtFldFirstResponder;
- (void)receivedNewChattingMsg:(ANetMessageChat *)message;

@end


#pragma mark - chat view protocol/delegate

@protocol ChatViewDelegate <NSObject>
@required
- (void)userWantsToSendChatMsg:(ANetMessageChat *)message;

@optional
- (void)userInputCheatCode:(NSString *)cheatCode;
@end
