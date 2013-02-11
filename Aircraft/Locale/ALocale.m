//
//  ALocale.m
//  Aircraft
//
//  Created by Yufei Lang on 12/28/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "ALocale.h"

@implementation ALocale

@synthesize supportedLanguageCode = _supportedLanguageCode;
@synthesize supportedLanguageDisplayName = _supportedLanguageDisplayName;

+ (id)currentLocale
{
    static ALocale *locale = nil;
    
    if (!locale)
    {
        locale = [[ALocale alloc]init];
        [locale changeLanguageTo:[ASetting currentDisplayLanguageCode]];//en-US,zh-Hans. Default: en
    }
    return  locale;
}

- (NSString *)langCode
{
    return _langCode ? _langCode : [ASetting currentDisplayLanguageCode];
}

/*!
 @discussion change the language settings.
 */
- (void)changeLanguageTo:(NSString *)newLangCode
{
    _langCode = newLangCode;
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:newLangCode];
    _defaultLanguageBundle = [[NSBundle alloc] initWithPath:[bundlePath stringByDeletingLastPathComponent]];
    
    [ASetting setDisplayLanguageCode:newLangCode];
}


/*!
 @discussion retreives the string for the current language by string identifier.
 */
- (NSString *)localisedString:(NSString *)stringId
{
    
    /*NSString *string = NSLocalizedStringFromTableInBundle(stringId, @"Labels", languageBundle, nil);
     if (nil != string && string != stringId)
     {
     return string;
     }*/
    
    return NSLocalizedStringFromTableInBundle(stringId, nil, _defaultLanguageBundle, nil);
}
@end
