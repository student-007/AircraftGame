//
//  AChattingMessageItem.h
//  Aircraft
//
//  Created by Yufei Lang on 1/20/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATableViewAdapter.h"

typedef enum
{
    AChattingMsgTypeNone                = 0,
    AChattingMsgTypeUserSent            = 1,    // this means right margin message
    AChattingMsgTypeCompetitorSent      = 2     // left margin
}AChattingMsgType;

@interface AChattingMessageItem : NSObject <ATableViewAdapterViewDelegate>
{
    CGRect _cellFrame;
    NSString *_message;
    AChattingMsgType _type;
}

//+ (AChattingMessageItem *)chattingItemWithMsg:(NSString *)msg type:(AChattingMsgType)type;
- (id)initWithMsg:(NSString *)message andType:(AChattingMsgType)type;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIImageView *backGroundImgView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@end
