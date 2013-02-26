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
@synthesize playTime;
@synthesize fireTimes;
@synthesize hits;
@synthesize winTimes;
@synthesize resultTitle;
@synthesize resultModel = _resultModel;

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
    
#warning TODO: use self.resultModel to display result on screen
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setPlayTime:nil];
	[self setFireTimes:nil];
	[self setHits:nil];
	[self setWinTimes:nil];
	[self setTitle:nil];
	[super viewDidUnload];
}

- (void)displayBattleResultwithPlayTime:(NSDate *)pTime fireTimes:(NSInteger)fTimes hits:(NSInteger)hits winTimes:(NSInteger)wTimes resultTitle:(NSString *)resTitle
{
	self.playTime.text = (NSString *)pTime;
	self.fireTimes.text = @"Dummy";
	self.hits.text = @"Dummy";
	self.winTimes.text = @"Dummy";
	self.resultTitle.text = resTitle;
}
@end
