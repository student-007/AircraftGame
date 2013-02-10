//
//  AUIPopView.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-9.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "AUIPopView.h"

#define kFadeInOutTime    0.3

@interface AUIPopView() 
{
    UIView *_popView;
//    UILabel *_textLabel;
}
@end

@implementation AUIPopView

@synthesize backgroundImage = _backgroundImage;
@synthesize image = _image;
@synthesize size = _size;
@synthesize dissmissDuration = _dissmissDuration;
@synthesize text = _text;
@synthesize textLabel = _textLabel;

- (id)init
{
    if (self = [super init]) 
    {
        _backgroundImage = nil;          // default: nil
        _image = nil;                    // default: nil
        _size = CGSizeZero;              // default: 0,0
        _dissmissDuration = 1.0f;
        _text = nil;
    }
    return self;
}

+ (AUIPopView *)popViewWithText:(NSString *)text image:(UIImage *)image size:(CGSize)size dissmissDuration:(NSTimeInterval)dissmissDuration
{
    AUIPopView *popView = [[AUIPopView alloc] init];
    popView.image = image;
    popView.size = size;
    popView.text = text;
    
    popView.textLabel = [[UILabel alloc] init];
    popView.textLabel.backgroundColor = [UIColor clearColor];
    popView.textLabel.textAlignment = UITextAlignmentCenter;
    popView.textLabel.font = [UIFont boldSystemFontOfSize:17];
    popView.textLabel.textColor = [UIColor whiteColor];
    popView.textLabel.minimumFontSize = 10;
    popView.textLabel.numberOfLines = 0;
    
    popView.dissmissDuration = dissmissDuration;
    return popView;
}

- (void)show
{
    UIView *currentView = [AAppDelegate sharedInstance].navigationController.view;
    _popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _size.width, _size.height)];
    _popView.center = CGPointMake(currentView.center.x, 100);
    _popView.alpha = 0;
    if (self.backgroundImage)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:self.backgroundImage];
        imgView.frame = CGRectMake(0, 0, _size.width, _size.height);
        [_popView addSubview:imgView];
    }
    if (self.image)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:self.image];
        imgView.frame = CGRectMake(0, 0, _size.width, _size.height);
        [_popView addSubview:imgView];
    }
    if (self.text && ![self.text isEqualToString:@""]) 
    {
        self.textLabel.text = self.text;
        self.textLabel.frame = CGRectMake(0, 0, _size.width, _size.height);
        [_popView addSubview:self.textLabel];
    }
    
    [currentView addSubview:_popView];
    
    [UIView beginAnimations:@"addPopView" context:nil];
    [UIView setAnimationDuration:kFadeInOutTime];
    _popView.alpha = 1;
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:self.dissmissDuration - kFadeInOutTime target:self selector:@selector(fadeOutPopView) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:self.dissmissDuration target:self selector:@selector(dissmissPopView) userInfo:nil repeats:NO];
}

- (void)fadeOutPopView
{
    [UIView beginAnimations:@"fadeOutPopView" context:nil];
    [UIView setAnimationDuration:kFadeInOutTime];
    _popView.alpha = 0;
    [UIView commitAnimations];
}

- (void)dissmissPopView
{
    [_popView removeFromSuperview];
}

@end
