//
//  ASavedRecordItem.h
//  Aircraft
//
//  Created by Yufei Lang on 13-2-20.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASavedGameRecord.h"
#import "NSString+Format.h"

@interface ASavedRecordItem : NSObject<ATableViewAdapterSectionDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) ASavedGameRecord *gameRecord;

@property (strong, nonatomic) IBOutlet UIButton *favoriteIcon;
@property (strong, nonatomic) IBOutlet UILabel *battleWithLabel;
@property (strong, nonatomic) IBOutlet UILabel *beganOnLabel;

@end
