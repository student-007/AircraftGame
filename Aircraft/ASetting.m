//
//  ASetting.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-9.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "ASetting.h"

@implementation ASetting

#pragma mark - guide enable/disable settings

+ (BOOL)needsForGuide:(AGuideType)guideType
{
    // 获取当前用户的NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *mdicSettings = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryRepresentation]];
    
    NSNumber *guideNeed = [mdicSettings valueForKey:[NSString stringWithFormat:@"guideType%d", guideType]];
    if (!guideNeed) 
    {
        [self setValue:YES forGuideType:guideType];
        return YES;
    }
    else
        return [guideNeed boolValue];
}

+ (void)setValue:(BOOL)yesOrNo forGuideType:(AGuideType)guideType
{
    // 获取当前用户的NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:yesOrNo] forKey:[NSString stringWithFormat:@"guideType%d", guideType]];
    
    // 同步保存defaults
    [defaults synchronize];
}

+ (NSString *)currentDisplayLanguageCode
{
    // 获取当前用户的NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *mdicSettings = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryRepresentation]];
    NSString *langCode = [mdicSettings valueForKey:@"displayLanguageCode"];
    return  langCode? langCode: @"en";
}

+ (void)setDisplayLanguageCode:(NSString *)langCode
{
    // 获取当前用户的NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:langCode forKey:@"displayLanguageCode"];
    
    // 同步保存defaults
    [defaults synchronize];
}

@end
