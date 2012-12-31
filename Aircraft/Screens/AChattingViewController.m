//
//  AChattingViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 12/29/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AChattingViewController.h"

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
        
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLocalizedInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_chatTxtFld];

    // add a pencil icon at left of the chatting text field
    [_chatTxtFld setLeftViewWithImageNamed:@"pencil_image"];
    [_chatTxtFld setDelegate:self];
    
}

- (void)viewDidUnload
{
    [self setChatTxtFld:nil];
    [self setBackgroundImgView:nil];
    [self setSendHideBtn:nil];
    [super viewDidUnload];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self adjustSendHideBtnStatus];
    [self signTxtFldFirstResponder];
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

- (IBAction)sendMsgOrHideKeyBoard:(AUIButton *)sender
{
    if (self.isEmptyMsg)
    {
        [self resignTxtFldFirstResponder];
    }
    else
    {
#warning TODO: call a delegate to send out the message
    }
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

- (void)signTxtFldFirstResponder
{
    CGRect txtFldFrame = self.chatTxtFld.frame;
    CGRect btnFrame = self.sendHideBtn.frame;
    
    [UIView beginAnimations:@"showSendHideButton" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    txtFldFrame.size.width = 227.0f;
    float centerX = txtFldFrame.origin.x + txtFldFrame.size.width + 12.0f + btnFrame.size.width / 2.0f;
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
    
    txtFldFrame.size.width = 280.0f;
    float centerX = txtFldFrame.origin.x + txtFldFrame.size.width + 12.0f + btnFrame.size.width / 2.0f;
    float centerY = self.chatTxtFld.center.y;
    self.sendHideBtn.center = CGPointMake(centerX, centerY);
    
    self.sendHideBtn.alpha = 0;
    self.chatTxtFld.frame = txtFldFrame;
    
    [UIView commitAnimations];
    
    self.sendHideBtn.hidden = YES;
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
    selfViewRect.origin.y = keyboardRect.origin.y - selfViewRect.size.height;
    [self.view setFrame:selfViewRect];
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
