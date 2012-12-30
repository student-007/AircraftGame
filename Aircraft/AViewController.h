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

@interface AViewController : UIViewController
{
    AAircraftImageView *_aircraftImgView;
    AChattingViewController *_chatVC;
}
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end
