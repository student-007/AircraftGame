//
//  ABattleFieldViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 1/1/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIBattleFieldView.h"

@protocol ABattleFieldVCDelegate;

@interface ABattleFieldViewController : UIViewController

@property (strong, nonatomic) IBOutlet AUIBattleFieldView *view;

@end


#pragma mark - Battle field view controller protocol/delegate

@protocol ABattleFieldVCDelegate <NSObject>

@required
- (void)userWantsToSwitchFieldFrom:(ABattleFieldViewController *)currentBattleField;

@end
