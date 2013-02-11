//
//  AGuideViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 13-2-6.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIButton.h"
#import "UIImage+AUITheme.h"

@protocol AGuideViewControllerDelegate;

typedef enum
{
    AGuideTypeNone              = 0,
    AGuideTypePlaceAircraft     = 1,
    AGuideTypePlayScreen        = 2,
    AGuideTypeAttackPlayTip     = 3
}AGuideType;

@interface AGuideViewController : UIViewController

@property (assign, nonatomic) id<AGuideViewControllerDelegate> delegate;
@property (nonatomic) AGuideType type;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *descPressReady;
@property (strong, nonatomic) IBOutlet UILabel *doNotShowAgainLabel;
@property (strong, nonatomic) IBOutlet UILabel *battleBeginsTryShootLabel;
@property (strong, nonatomic) IBOutlet UILabel *destoryToWinLabel;
//battle_begins_try_shoot
@property (strong, nonatomic) IBOutlet AUICheckBoxButton *doNotShowAgainCheckBoxBtn;
@property (strong, nonatomic) IBOutlet UIImageView *doNotShowAgainBkgImageView;
@property (strong, nonatomic) IBOutlet UIView *doNotShowAgainView;
@end


@protocol AGuideViewControllerDelegate <NSObject>

- (void)dismissTheGuideView;

@end