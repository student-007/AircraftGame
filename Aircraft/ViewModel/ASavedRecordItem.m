//
//  ASavedRecordItem.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-20.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "ASavedRecordItem.h"

@interface ASavedRecordItem() 

@property (nonatomic, strong) NSDictionary *savedRecord;

@end

@implementation ASavedRecordItem
@synthesize view;
@synthesize favoriteIcon;
@synthesize battleWithLabel;
@synthesize beganOnLabel;
@synthesize gameRecord = _gameRecord;
@synthesize savedRecord = _savedRecord;
@synthesize target = _target;
@synthesize selectionAction = _selectionAction;

- (UIView *)getView
{
    [[NSBundle mainBundle] loadNibNamed:@"ASavedRecordItem" owner:self options:nil];
    self.view.clipsToBounds = YES;
    
    // set the favorite star icon
    [self.favoriteIcon setImage:[self.gameRecord.isFavorite boolValue] ? [UIImage imageForColoredStar] : [UIImage imageForUncoloredStar] forState:UIControlStateNormal];
    
    // set the competitor name
    self.battleWithLabel.text = [NSString stringWithFormat:@"%@: %@", ALocalisedString(@"battle_with"), self.gameRecord.competitorName];
    
    // set the began date
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[self.gameRecord.startTimeSec floatValue]];
    NSString *formatString = [NSString stringWithFormat:@"HH:mm '%@' MMM dd", ALocalisedString(@"on")];
    self.beganOnLabel.text = [NSString stringWithFormat:@"%@: %@", 
                              ALocalisedString(@"started_at"), 
                              [NSString stringForDate:startDate inFormat:formatString]];
    return self.view;
}

- (CGRect) getViewFrame
{
    return CGRectMake(0, 0, 300, 60);
}

- (void)setData:(id)dataSource forIndex:(NSUInteger)index
{
    self.gameRecord = [dataSource objectAtIndex:index];
}

- (IBAction)actionFavoriteBtnClicked:(AUIButton *)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameRecordSaved:) name:kNotificationGameSaved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveGameRecordFailed:) name:kNotificationSaveGameFailed object:nil];
    
    self.gameRecord.isFavorite = [NSNumber numberWithBool:![self.gameRecord.isFavorite boolValue]];
    AGameRecordManager *recordMgr = [AGameRecordManager sharedInstance];
    recordMgr.sharedGameRecord = self.gameRecord;
    [recordMgr saveGameToFile];
}

- (void)gameRecordSaved:(NSNotification *)notification
{
    // set the favorite star icon
    [self.favoriteIcon setImage:[self.gameRecord.isFavorite boolValue] ?[UIImage imageForColoredStar] : [UIImage imageForUncoloredStar] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationGameSaved object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationSaveGameFailed object:nil];
}

- (void)saveGameRecordFailed:(NSNotification *)notification
{
    self.gameRecord.isFavorite = [NSNumber numberWithBool:![self.gameRecord.isFavorite boolValue]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationGameSaved object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationSaveGameFailed object:nil];
}

@end
