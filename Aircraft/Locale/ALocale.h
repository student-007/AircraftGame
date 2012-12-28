//
//  ALocale.h
//  Aircraft
//
//  Created by Yufei Lang on 12/28/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALocale : NSObject
{
//    NSBundle *_languageBundle;
    NSBundle *_defaultLanguageBundle;
}

@property (retain, readonly) NSString   *langCode;
@property (retain, readonly) NSArray    *supportedLanguageCode;
@property (retain, readonly) NSArray    *supportedLanguageDisplayName;

/*!
 @discussion shared singleton instance of the locale object
 */
+ (id)currentLocale;

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
