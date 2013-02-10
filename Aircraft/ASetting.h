//
//  ASetting.h
//  Aircraft
//
//  Created by Yufei Lang on 13-2-9.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGuideViewController.h"

@interface ASetting : NSObject

+ (BOOL)needsForGuide:(AGuideType)guideType;
+ (void)setValue:(BOOL)yesOrNo forGuideType:(AGuideType)guideType;

@end
