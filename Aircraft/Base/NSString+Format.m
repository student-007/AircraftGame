//
//  NSString+Format.m
//  Aircraft
//
//  Created by Yufei Lang on 1/28/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (NSString_Format)

+ (NSString *)timeFormatStringFromTimeInterval:(NSTimeInterval)timeInterval
{
    timeInterval = timeInterval > 0 ? timeInterval : timeInterval * -1;
    
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger second = 0;
    
    hour = timeInterval / (3600);
    minute = (timeInterval - (hour * 3600)) / 60;
    second = (int)timeInterval % 60;
    
    if (hour > 0)
        return [NSString stringWithFormat:@"%2d:%2d:%2d", hour, minute, second];
    else if (minute > 0)
        return [NSString stringWithFormat:@"%2d:%2d", minute, second];
    else if (second > 0)
        return [NSString stringWithFormat:@"%2d sec", second];
    else
        return @"0";
}

+ (NSString *)timeFormatStringFromSecondString:(NSString *)timeIntervalStr
{
    return [NSString timeFormatStringFromTimeInterval:[timeIntervalStr floatValue]];
}

@end
