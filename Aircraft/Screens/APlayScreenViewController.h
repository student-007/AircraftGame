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
#import "ASavedGameRecord.h"

@interface APlayScreenViewController : UIViewController <UIScrollViewDelegate, ABattleFieldVCDelegate, AOperationPanelViewControllerViewDelegate>

// view controller will try to load the unfinished game if this property is NOT nil
@property (strong, nonatomic) ASavedGameRecord *gameRecord;

@property (nonatomic) ConnectionType connectionType; // this will be ingored if property gameRecord is provided

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
