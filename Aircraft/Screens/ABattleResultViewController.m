//
//  ABattleResultViewController.m
//  Aircraft
//
//  Created by J on 13-2-13.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "ABattleResultViewController.h"

@interface ABattleResultViewController ()

@end

@implementation ABattleResultViewController
//@synthesize playTime;
//@synthesize fireTimes;
//@synthesize hits;
//@synthesize winTimes;
//@synthesize resultTitle;
@synthesize resultModel = _resultModel;
@synthesize delegate = _delegate;

- (void)loadLocalizedInfo
{
    self.totalPlayTimeTipLabel.text = ALocalisedString(@"total_play_time");
    self.timeSpentMeTipLabel.text = ALocalisedString(@"time_spent_for_me");
    self.timeSpentOpponentTipLabel.text = ALocalisedString(@"time_spent_for_opponent");
    self.numberAttackTipLabel.text = ALocalisedString(@"number_of_attacks");
    self.numberHitTipLabel.text = ALocalisedString(@"number_of_hits");
    self.hitRateMeTipLabel.text = ALocalisedString(@"hit_rate");
    self.hitRateOpponentTipLabel.text = ALocalisedString(@"oppoents_hit_rate");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithResultModel:(ABattleResultInfoModel *)resultModel
{
    if (self = [super initWithNibName:@"ABattleResultViewController" bundle:nil])
    {
        self.resultModel = resultModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadLocalizedInfo];
    
    // load or clear out the info on screen
    if (self.resultModel)
        [self displayInfoBasedOnResultModel:self.resultModel];
    else
    {
        self.mainTitleLabel.text = @"Unknow result";
        self.secondaryTitleLabel.text = @"An error has occured";
        self.totalPlayTimeLabel.text = @"";
        self.timeSpentMeLabel.text = @"";
        self.timeSpentOpponentLabel.text = @"";
        self.numberAttackLabel.text = @"";
        self.numberHitLabel.text = @"";
        self.hitRateMeLabel.text = @"";
        self.hitRateOpponentLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
//	[self setPlayTime:nil];
//	[self setFireTimes:nil];
//	[self setHits:nil];
//	[self setWinTimes:nil];
//	[self setTitle:nil];
    [self setMainTitleLabel:nil];
    [self setSecondaryTitleLabel:nil];
    [self setTotalPlayTimeTipLabel:nil];
    [self setTimeSpentMeTipLabel:nil];
    [self setTimeSpentOpponentTipLabel:nil];
    [self setNumberAttackTipLabel:nil];
    [self setNumberHitTipLabel:nil];
    [self setHitRateMeTipLabel:nil];
    [self setHitRateOpponentTipLabel:nil];
    [self setTotalPlayTimeLabel:nil];
    [self setTimeSpentMeLabel:nil];
    [self setTimeSpentOpponentLabel:nil];
    [self setNumberAttackLabel:nil];
    [self setNumberHitLabel:nil];
    [self setHitRateMeLabel:nil];
    [self setHitRateOpponentLabel:nil];
	[super viewDidUnload];
}

- (void)displayInfoBasedOnResultModel:(ABattleResultInfoModel *)resultModel
{
    if ([resultModel.resultString caseInsensitiveCompare:kBattleEndResultWon] == NSOrderedSame)
    {
        self.mainTitleLabel.text = ALocalisedString(@"you_won");
        self.secondaryTitleLabel.text = ALocalisedString(@"awesome");
    }
    else if ([resultModel.resultString caseInsensitiveCompare:kBattleEndResultWonEnemyEscape] == NSOrderedSame)
    {
        self.mainTitleLabel.text = ALocalisedString(@"you_won");
        self.secondaryTitleLabel.text = ALocalisedString(@"opponent_escaped");
    }
    else if ([resultModel.resultString caseInsensitiveCompare:kBattleEndResultLost] == NSOrderedSame)
    {
        self.mainTitleLabel.text = ALocalisedString(@"you_lost");
        self.secondaryTitleLabel.text = ALocalisedString(@"sorry_dont_be_sad");
    }
    
    NSTimeInterval playTimeSec = [self.resultModel.battleBeginDate timeIntervalSinceDate:self.resultModel.battleEndDate];
    self.totalPlayTimeLabel.text = [NSString timeFormatStringFromTimeInterval:playTimeSec];
    self.timeSpentMeLabel.text = [NSString timeFormatStringFromTimeInterval:self.resultModel.timeSpentUser];
    self.timeSpentOpponentLabel.text = [NSString timeFormatStringFromTimeInterval:self.resultModel.timeSpentOpponent];
    self.numberAttackLabel.text = [NSString stringWithFormat:@"%d", self.resultModel.selfNumberOfAttacks];
    self.numberHitLabel.text = [NSString stringWithFormat:@"%d", self.resultModel.selfNumberOfHits];
    self.hitRateMeLabel.text = [NSString stringWithFormat:@"%.2f%%",
                                ((float)self.resultModel.selfNumberOfHits / (float)self.resultModel.selfNumberOfAttacks * 100)];
    self.hitRateOpponentLabel.text = [NSString stringWithFormat:@"%.2f%%",
                                      ((float)self.resultModel.enemyNumberOfHits / (float)self.resultModel.enemyNumberOfAttacks * 100)];
}
- (IBAction)actionOkBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(resultViewController:userPressOkBtnForResult:)])
        [self.delegate resultViewController:self userPressOkBtnForResult:self.resultModel];
}

- (IBAction)actionRematchBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(resultViewController:userPressRematchBtnForResult:)])
        [self.delegate resultViewController:self userPressRematchBtnForResult:self.resultModel];
}

- (IBAction)actionBragBtnClicked:(id)sender
{
#warning TODO: share this result to social network
}

- (IBAction)actionShareGameBtnClicked:(id)sender
{
#warning TODO: share the game app link via email, sms, social network
}

//- (void)displayBattleResultwithPlayTime:(NSDate *)pTime fireTimes:(NSInteger)fTimes hits:(NSInteger)hits winTimes:(NSInteger)wTimes resultTitle:(NSString *)resTitle
//{
//	self.playTime.text = (NSString *)pTime;
//	self.fireTimes.text = @"Dummy";
//	self.hits.text = @"Dummy";
//	self.winTimes.text = @"Dummy";
//	self.resultTitle.text = resTitle;
//}
@end
