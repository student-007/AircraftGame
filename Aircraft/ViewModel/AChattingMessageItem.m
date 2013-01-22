//
//  AChattingMessageItem.m
//  Aircraft
//
//  Created by Yufei Lang on 1/20/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "AChattingMessageItem.h"

@implementation AChattingMessageItem

@synthesize target = _target;
@synthesize selectionAction = _selectionAction;

- (id)initWithMsg:(NSString *)message andType:(AChattingMsgType)type
{
    if (self = [super init])
    {
        _cellFrame = CGRectZero;
        _type = type;
        _message = message;
    }
    return self;
}

//+ (AChattingMessageItem *)chattingItemWithMsg:(NSString *)msg type:(AChattingMsgType)type


- (UIView *)getView
{
    [[NSBundle mainBundle] loadNibNamed:@"AChattingMessageItem" owner:self options:nil];
    
    self.messageLabel.text = _message;
    CGSize lblSize = [_message sizeWithFont:self.messageLabel.font constrainedToSize:CGSizeMake(250.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect backgroundImgViewFrame;
    CGRect viewFrame = self.view.frame;
    
    switch (_type)
    {
        case AChattingMsgTypeUserSent:
        {
            UIEdgeInsets inset = UIEdgeInsetsMake(35, 30, 25, 35);
            UIImage *img = [[UIImage imageNamed:@"blueBubble"] resizableImageWithCapInsets:inset];
            [self.backGroundImgView setImage:img];
            backgroundImgViewFrame = CGRectMake(320.0f - (lblSize.width + 28.0f),
                                                2.0f,
                                                lblSize.width + 28.0f,
                                                lblSize.height + 10.0f);
            self.backGroundImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        }
            break;
        case AChattingMsgTypeCompetitorSent:
        {
            UIEdgeInsets inset = UIEdgeInsetsMake(25, 35, 25, 35);
            UIImage *img = [[UIImage imageNamed:@"greyBubble"] resizableImageWithCapInsets:inset];
            [self.backGroundImgView setImage:img];
            backgroundImgViewFrame = CGRectMake(0.0f,
                                                2.0f,
                                                lblSize.width + 28.0f,
                                                lblSize.height + 10.0f);
            self.backGroundImgView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        }
            break;
        default:
            break;
    }
    
    self.backGroundImgView.frame = backgroundImgViewFrame;
//    self.messageLabel.center = self.backGroundImgView.center;
    viewFrame.size.width = 320;
    viewFrame.size.height = backgroundImgViewFrame.size.height + 4.0f;
    self.view.frame = viewFrame;
    _cellFrame = viewFrame;
    
    return self.view;
}

- (CGRect) getViewFrame
{
    if (_cellFrame.size.width != 0 &&
        _cellFrame.size.height != 0 &&
        _cellFrame.origin.x != 0 &&
        _cellFrame.origin.y != 0)
    {
        return _cellFrame;
    }
    else
        return [self getView].frame;
}

@end
