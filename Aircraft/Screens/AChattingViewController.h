//
//  AChattingViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 12/29/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AChattingViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgView;
@property (weak, nonatomic) IBOutlet AUITextField *chatTxtFld;
@property (strong, nonatomic) IBOutlet AUIButton *sendHideBtn;

@property (nonatomic, readonly, getter = isEmptyMsg) BOOL emptyMsg;

- (void)resignTxtFldFirstResponder;

@end
