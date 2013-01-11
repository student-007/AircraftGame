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
#import "ABattleFieldViewController.h"

@interface AViewController : UIViewController <UIScrollViewDelegate>
{
    AAircraftImageView *_aircraftImgView;
    AChattingViewController *_chatVC;
}
@property (strong, nonatomic) AGameOrganizer *organizer;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) ABattleFieldViewController *battleFldEnemy;
@property (strong, nonatomic) ABattleFieldViewController *battleFldSelf;
@end
