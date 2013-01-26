//
//  AChattingViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 12/29/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AChattingViewController.h"

#define kChatTxtFldWidthEditing     227.0f
#define kChatTxtFldWidthNormal      280.0f
#define kPadOfTxtFldAndSendBtn      12.0f

@interface AChattingViewController ()

@end

@implementation AChattingViewController

- (void)loadLocalizedInfo
{
    self.chatTxtFld.placeholder = ALocalisedString(@"chat_view_txtFld_holder");
    [self.sendHideBtn setTitleForAllState:ALocalisedString(@"chat_view_send_btn")];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _competitorName = ALocalisedString(@"chat_view_user_name");
        _competitorName = ALocalisedString(@"chat_view_competitor_name");
        _chattingRecordsArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLocalizedInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.chatTxtFld];

    // add a pencil icon at left of the chatting text field
    [self.chatTxtFld setLeftViewWithImageNamed:@"pencil_image"];
    [self.chatTxtFld setDelegate:self];
    
    
    AChattingMessageItem *msgItem = [[AChattingMessageItem alloc] initWithMsg:@"chatting message here" andType:AChattingMsgTypeCompetitorSent];
    [self.tableViewAdapter addView:msgItem forKey:[NSString stringWithFormat:@"chatMsg%d",1] withStyle:ATableViewAdapterPanelStyleGrouped];
    
    AChattingMessageItem *msgItem2 = [[AChattingMessageItem alloc] initWithMsg:@"chatting message2 here" andType:AChattingMsgTypeUserSent];
    [self.tableViewAdapter addView:msgItem2 forKey:[NSString stringWithFormat:@"chatMsg%d",2] withStyle:ATableViewAdapterPanelStyleGrouped];
    
}

- (void)viewDidUnload
{
    [self setChatTxtFld:nil];
    [self setBackgroundImgView:nil];
    [self setSendHideBtn:nil];
    [self setTableView:nil];
    [self setTableViewAdapter:nil];
    [super viewDidUnload];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self adjustSendHideBtnStatus];
    [self signTxtFldToFirstResponder];
}

- (IBAction)textFieldDidChange:(NSNotification*)aNotification
{
//    UITextField *textField = aNotification.object;
    [self adjustSendHideBtnStatus];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMsgOrHideKeyBoard:_sendHideBtn];
    return YES;
}

- (void)receivedNewChattingMsg:(ANetMessageChat *)message
{
#warning TODO: deal with the new coming message, display them. be noticed, "sender" in ANetMessageChat may be nil
    if (!_chattingRecordsArray) _chattingRecordsArray = [NSMutableArray array];
    
    NSNumber *msgIdx = [NSNumber numberWithInt:_chattingRecordsArray.count];
    NSDictionary *chatMsg = [NSDictionary dictionaryWithObjectsAndKeys:
                             msgIdx, @"index",
                             message.sender ? message.sender : [NSNull null], @"sender",
                             message.message, @"message", nil];
    [_chattingRecordsArray addObject:chatMsg];
    
    [self addNewMessage:message.message toChattingTableWithType:AChattingMsgTypeCompetitorSent];
    
//    AChattingMessageItem *msgItem = [[AChattingMessageItem alloc] initWithMsg:message.message andType:AChattingMsgTypeCompetitorSent];
//    [self.tableViewAdapter addView:msgItem forKey:[NSString stringWithFormat:@"chatMsg%d",[msgIdx integerValue]] withStyle:ATableViewAdapterPanelStylePlain];
}

- (IBAction)sendMsgOrHideKeyBoard:(AUIButton *)sender
{
    if (self.isEmptyMsg)
    {
        [self resignTxtFldFirstResponder];
    }
    else
    {
        NSString *inputStr = self.chatTxtFld.text;
        
        if ([inputStr compare:@"$CheatCode" options:NSLiteralSearch range:NSMakeRange(4, 10)] == NSOrderedSame)
        {
            NSRange cheatCoderange = NSMakeRange(14, 3);
            NSString *cheatCode = [inputStr substringWithRange:cheatCoderange];
            // if user(most likely developer or QA) wants to input a cheat code
            if ([self.delegate respondsToSelector:@selector(userInputCheatCode:)])
                [self.delegate userInputCheatCode:cheatCode];
        }
        else
        {
            // if user wants to send a message to competitor
            if ([self.delegate respondsToSelector:@selector(userWantsToSendChatMsg:)])
                [self.delegate userWantsToSendChatMsg:[ANetMessageChat message:inputStr andSenderName:_userName]];
            
            if (!_chattingRecordsArray) _chattingRecordsArray = [NSMutableArray array];
            NSDictionary *chatMsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                     _userName, @"sender",
                                     inputStr, @"message", nil];
            [_chattingRecordsArray addObject:chatMsg];
            
            [self addNewMessage:inputStr toChattingTableWithType:AChattingMsgTypeUserSent];
        }
        
        self.chatTxtFld.text = @"";
    }
}

- (void)addNewMessage:(NSString *)message toChattingTableWithType:(AChattingMsgType)type
{
    NSNumber *msgIdx = [NSNumber numberWithInt:_chattingRecordsArray.count];
    AChattingMessageItem *msgItem = [[AChattingMessageItem alloc] initWithMsg:message andType:type];
    [self.tableViewAdapter addView:msgItem forKey:[NSString stringWithFormat:@"chatMsg%d",[msgIdx integerValue]] withStyle:ATableViewAdapterPanelStylePlain];
    
    // scroll to the bottom
    NSUInteger lastSection = [self.tableView numberOfSections] - 1;
    NSUInteger lastSectionRow = [self.tableView numberOfRowsInSection:lastSection] - 1;
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:lastSectionRow inSection:lastSection];
    [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)adjustSendHideBtnStatus
{
    if (self.isEmptyMsg)
    {
#warning TODO: comment below and set button background image to "hide keyboard" image
        self.sendHideBtn.backgroundColor = [UIColor grayColor];
        [self.sendHideBtn setTitleForAllState:ALocalisedString(@"chat_view_send_btn_hide")];
    }
    else
    {
#warning TODO: comment below and set button background image to "send" image
        self.sendHideBtn.backgroundColor = [UIColor greenColor];
        [self.sendHideBtn setTitleForAllState:ALocalisedString(@"chat_view_send_btn")];
    }
}

- (void)signTxtFldToFirstResponder
{
    CGRect txtFldFrame = self.chatTxtFld.frame;
    CGRect btnFrame = self.sendHideBtn.frame;
    
    [UIView beginAnimations:@"showSendHideButton" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    txtFldFrame.size.width = kChatTxtFldWidthEditing;
    float centerX = txtFldFrame.origin.x + txtFldFrame.size.width + kPadOfTxtFldAndSendBtn + btnFrame.size.width / 2.0f;
    float centerY = self.chatTxtFld.center.y;
    self.sendHideBtn.center = CGPointMake(centerX, centerY);
    
    self.chatTxtFld.frame = txtFldFrame;
    self.sendHideBtn.hidden = NO;
    self.sendHideBtn.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (void)resignTxtFldFirstResponder
{
    [self.chatTxtFld resignFirstResponder];
    
    CGRect txtFldFrame = self.chatTxtFld.frame;
    CGRect btnFrame = self.sendHideBtn.frame;
    [UIView beginAnimations:@"hideSendHideButton" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    txtFldFrame.size.width = kChatTxtFldWidthNormal;
    float centerX = txtFldFrame.origin.x + txtFldFrame.size.width + kPadOfTxtFldAndSendBtn + btnFrame.size.width / 2.0f;
    float centerY = self.chatTxtFld.center.y;
    self.sendHideBtn.center = CGPointMake(centerX, centerY);
    
    self.chatTxtFld.frame = txtFldFrame;
    
    [UIView commitAnimations];
    
    self.sendHideBtn.alpha = 0;
    self.sendHideBtn.hidden = YES;
}

- (void)setNickNameForUser:(NSString *)userName andCompetitor:(NSString *)competitorName
{
    if (_userName != userName)
        _userName = userName;
    if (_competitorName != competitorName)
        _competitorName = competitorName;
}

- (BOOL)isEmptyMsg
{
    return [self.chatTxtFld.text isEqualToString:@""] ? YES : NO;
}

#pragma mark - keyboard frame change operation

/*!
 @discussion this method will be trigered not only when changing the input method(eg. from english to chinese), but also called when keyboard will show up or hide.
 */
- (void)keyboardFrameChanged:(NSNotification*)aNotification
{
    // Get the size of the keyboard.
    NSDictionary* info = [aNotification userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Reset self frame within an animation block
    [UIView beginAnimations:@"ResizeForKeyboardFrameChanges" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    // be noticed, the original keyboard is 216 tall [Yufei Lang 4/10/2012]
    CGRect selfViewRect = self.view.frame;
    selfViewRect.origin.y = keyboardRect.origin.y - 20.0f - selfViewRect.size.height;
    [self.view setFrame:selfViewRect];
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
