//
//  APlayScreenViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 1/10/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGameOrganizer.h"
#import "ABattleFieldViewController.h"
#import "AChattingViewController.h"
#import "ABattleFieldViewController.h"
#import "AOperationPanelViewController.h"
#import "AAircraftHolderImageView.h"

@interface APlayScreenViewController : UIViewController <UIScrollViewDelegate, ABattleFieldVCDelegate, AOperationPanelViewControllerViewDelegate>

// organizer
@property (strong, nonatomic) AGameOrganizer *organizer;

// battle fields
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) ABattleFieldViewController *battleFldEnemy;
@property (strong, nonatomic) ABattleFieldViewController *battleFldSelf;

// operation panel
@property (strong, nonatomic) AOperationPanelViewController *opPanel;

// chatting
@property (nonatomic, strong) AChattingViewController *chatVC;

@end
