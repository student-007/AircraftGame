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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLocalizedInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];

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

/*
 - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
 - (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
 - (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
 - (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
 - (BOOL)textFieldShouldReturn:(UITextField *)textField;
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
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
    [UIView setAnimationDuration:0.1f];
    
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
