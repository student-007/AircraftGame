//
//  AGuideViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 13-2-6.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AGuideViewControllerDelegate;

typedef enum
{
    AGuideTypeNone              = 0,
    AGuideTypePlaceAircraft     = 1,
    AGuideTypePlayScreen        = 2
}AGuideType;

@interface AGuideViewController : UIViewController

@property (assign, nonatomic) id<AGuideViewControllerDelegate> delegate;
@property (nonatomic) AGuideType type;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;

@end


@protocol AGuideViewControllerDelegate <NSObject>

- (void)dismissTheGuideView;

@end