//
//  ALocale.h
//  Aircraft
//
//  Created by Yufei Lang on 12/28/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASetting.h"

@interface ALocale : NSObject
{
//    NSBundle *_languageBundle;
    NSBundle *_defaultLanguageBundle;
    NSString *_langCode;
}

@property (strong, readonly) NSString   *langCode;
@property (strong, readonly) NSArray    *supportedLanguageCode;
@property (strong, readonly) NSArray    *supportedLanguageDisplayName;

/*!
 @discussion shared singleton instance of the locale object
 */
+ (ALocale *)currentLocale;

/*!
 @discussion change the language settings.
 */
- (void)changeLanguageTo:(NSString *)langCode;

/*!
 @discussion retreives the string for the current language by string identifier.
 */
- (NSString *)localisedString:(NSString *)stringId;

@end


#define ALocalisedString(stringId) [[ALocale currentLocale] localisedString:stringId]
