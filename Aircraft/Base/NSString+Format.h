//
//  NSString+Format.h
//  Aircraft
//
//  Created by Yufei Lang on 1/28/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Format)

/*!
 @discussion return xx:xx:xx style string based on given time interval
 */
+ (NSString *)timeFormatStringFromTimeInterval:(NSTimeInterval)timeInterval;

/*!
 @discussion return xx:xx:xx style string based on given time interval string
 */
+ (NSString *)timeFormatStringFromSecondString:(NSString *)timeIntervalStr;


+ (NSString *)stringForDate:(NSDate *)date inFormat:(NSString *)formatString;
@end
