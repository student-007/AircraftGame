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
@synthesize view = _view;
@synthesize backGroundImgView = _backGroundImgView;
@synthesize messageLabel = _messageLabel;

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
    CGSize lblSize = [_message sizeWithFont:[UIFont fontWithName:@"Noteworthy-Bold" size:13.0f]
                          constrainedToSize:CGSizeMake(250.0f, MAXFLOAT)
                              lineBreakMode:UILineBreakModeWordWrap/*NSLineBreakByWordWrapping*/];
    CGRect backgroundImgViewFrame;
    CGRect viewFrame = self.view.frame;
    
    switch (_type)
    {
        case AChattingMsgTypeUserSent:
        {
            UIImage *img = [UIImage imageNamed:@"chatBubbleUser"];
            UIEdgeInsets inset = UIEdgeInsetsMake(10.0f,
                                                  img.size.width - 14.0f - 1.0f,
                                                  img.size.height - 10.0f - 1.0f,
                                                  14.0f);
            img = [img resizableImageWithCapInsets:inset];
            [self.backGroundImgView setImage:img];
            backgroundImgViewFrame = CGRectMake(320.0f - (lblSize.width + 12.0f),
                                                1.0f,
                                                lblSize.width + 12.0f,
                                                lblSize.height + 2.0f);
            self.backGroundImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            CGRect labFrame = backgroundImgViewFrame;
            labFrame.origin.x += 5.0f;
            labFrame.size.height = lblSize.height;
            labFrame.size.width = lblSize.width;
            self.messageLabel.frame = labFrame;
        }
            break;
        case AChattingMsgTypeCompetitorSent:
        {
            UIImage *img = [UIImage imageNamed:@"chatBubbleOther"];
            UIEdgeInsets inset = UIEdgeInsetsMake(10.0f,
                                                  14.0f,
                                                  img.size.height - 10.0f - 1.0f,
                                                  img.size.width - 14.0f - 1.0f);
            img = [img resizableImageWithCapInsets:inset];
            [self.backGroundImgView setImage:img];
            backgroundImgViewFrame = CGRectMake(0.0f,
                                                1.0f,
                                                lblSize.width + 20.0f,
                                                lblSize.height + 2.0f);
            self.backGroundImgView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            CGRect labFrame = backgroundImgViewFrame;
            labFrame.origin.x += 13.0f;
            labFrame.size.height = lblSize.height;
            labFrame.size.width = lblSize.width;
            self.messageLabel.frame = labFrame;
        }
            break;
        case AChattingMsgTypeHelpMsg:
        {
#warning TODO: a different color bubble for help msg
            UIImage *img = [UIImage imageNamed:@"chatBubbleSystem"];
            UIEdgeInsets inset = UIEdgeInsetsMake(10.0f,
                                                  14.0f,
                                                  img.size.height - 10.0f - 1.0f,
                                                  img.size.width - 14.0f - 1.0f);
            img = [img resizableImageWithCapInsets:inset];
            [self.backGroundImgView setImage:img];
            backgroundImgViewFrame = CGRectMake(0.0f,
                                                1.0f,
                                                lblSize.width + 20.0f,
                                                lblSize.height + 2.0f);
            self.backGroundImgView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            CGRect labFrame = backgroundImgViewFrame;
            labFrame.origin.x += 13.0f;
            labFrame.size.height = lblSize.height;
            labFrame.size.width = lblSize.width;
            self.messageLabel.frame = labFrame;
        }
            break;
        case AChattingMsgTypeSystemMsg:
        {
#warning TODO: a different color bubble for system msg
            UIImage *img = [UIImage imageNamed:@"chatBubbleSystem"];
            UIEdgeInsets inset = UIEdgeInsetsMake(10.0f,
                                                  14.0f,
                                                  img.size.height - 10.0f - 1.0f,
                                                  img.size.width - 14.0f - 1.0f);
            img = [img resizableImageWithCapInsets:inset];
            [self.backGroundImgView setImage:img];
            backgroundImgViewFrame = CGRectMake(0.0f,
                                                1.0f,
                                                lblSize.width + 20.0f,
                                                lblSize.height + 2.0f);
            self.backGroundImgView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            CGRect labFrame = backgroundImgViewFrame;
            labFrame.origin.x += 13.0f;
            labFrame.size.height = lblSize.height;
            labFrame.size.width = lblSize.width;
            self.messageLabel.frame = labFrame;
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
