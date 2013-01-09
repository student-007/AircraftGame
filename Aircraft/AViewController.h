//
//  AViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 12/21/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAircraftModel.h"
#import "AAircraftImageView.h"
#import "AChattingViewController.h"
#import "AGameOrganizer.h"

@interface AViewController : UIViewController <UIGestureRecognizerDelegate>
{
    AAircraftImageView *_aircraftImgView;
    AChattingViewController *_chatVC;
}
@property (strong, nonatomic) IBOutlet UILabel *testLabel;
@property (strong, nonatomic) IBOutlet UIImageView *testImageView;
@property (strong, nonatomic) AGameOrganizer *organizer;

@end
