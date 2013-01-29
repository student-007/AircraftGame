//
//  NSString+Format.h
//  Aircraft
//
//  Created by Yufei Lang on 1/28/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Format)

+ (NSString *)timeFormatStringFromTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)timeFormatStringFromSecondString:(NSString *)timeIntervalStr;

@end
