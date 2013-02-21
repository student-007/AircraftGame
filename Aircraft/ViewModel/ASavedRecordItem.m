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

- (UIView *)getView
{
    [[NSBundle mainBundle] loadNibNamed:@"ASavedRecordItem" owner:self options:nil];
    
    // set the favorite star icon
    if ([self.gameRecord.isFavorite boolValue]) 
    {
        [self.favoriteIcon setImage:[UIImage imageForColoredStar] forState:UIControlStateNormal];
    }
    else
    {
        [self.favoriteIcon setImage:[UIImage imageForUncoloredStar] forState:UIControlStateNormal];
    }
    
    // set the competitor name
    self.battleWithLabel.text = [NSString stringWithFormat:@"%@: %@", ALocalisedString(@"battle_with"), self.gameRecord.competitorName];
    
    // set the began date
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[self.gameRecord.startTimeSec floatValue]];
    self.beganOnLabel.text = [NSString stringWithFormat:@"%@: %@", 
                              ALocalisedString(@"started_at"), 
                              [NSString stringForDate:startDate inFormat:@"HH:mm '%@' MMM dd"], ALocalisedString(@"on")];
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

@end
