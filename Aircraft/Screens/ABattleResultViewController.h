//
//  ABattleResultViewController.h
//  Aircraft
//
//  Created by J on 13-2-13.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABattleResultInfoModel.h"
#import "NSString+Format.h"

@protocol ABattleResultViewControllerDelegate;

@interface ABattleResultViewController : UIViewController

//@property (strong, nonatomic) IBOutlet UILabel *playTime;			//游戏所用时间。
//@property (strong, nonatomic) IBOutlet UILabel *fireTimes;			//攻击总次数。
//@property (strong, nonatomic) IBOutlet UILabel *hits;				//击中次数（包含击中机身和机头）
//@property (strong, nonatomic) IBOutlet UILabel *winTimes;			//连胜次数。
//@property (strong, nonatomic) IBOutlet UILabel *resultTitle;		//比赛结果的标题。

@property (strong, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondaryTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPlayTimeTipLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeSpentMeTipLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeSpentOpponentTipLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberAttackTipLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberHitTipLabel;
@property (strong, nonatomic) IBOutlet UILabel *hitRateMeTipLabel;
@property (strong, nonatomic) IBOutlet UILabel *hitRateOpponentTipLabel;

@property (strong, nonatomic) IBOutlet UILabel *totalPlayTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeSpentMeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeSpentOpponentLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberAttackLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberHitLabel;
@property (strong, nonatomic) IBOutlet UILabel *hitRateMeLabel;
@property (strong, nonatomic) IBOutlet UILabel *hitRateOpponentLabel;

@property (assign, nonatomic) id<ABattleResultViewControllerDelegate> delegate;
@property (strong, nonatomic) ABattleResultInfoModel *resultModel;

- (id)initWithResultModel:(ABattleResultInfoModel *)resultModel;

///*
//	此函数用来控制比赛显示的结果信息。
//	其中前四项无法从现有的类里面获得，所以暂时这么实现。
//	等有空咱俩讨论一下ANetMessage那个类。或者有其他什么方法可以解决这个信息的传递。
// */
//- (void)displayBattleResultwithPlayTime: (NSDate *) pTime
//							  fireTimes: (NSInteger) fTimes
//								   hits: (NSInteger) hits
//							   winTimes: (NSInteger) wTimes
//							resultTitle: (NSString *) resTitle;

@end

@protocol ABattleResultViewControllerDelegate <NSObject>

- (void)resultViewController:(ABattleResultViewController *)resultVC userPressOkBtnForResult:(ABattleResultInfoModel *)resultModel;
- (void)resultViewController:(ABattleResultViewController *)resultVC userPressRematchBtnForResult:(ABattleResultInfoModel *)resultModel;

@end