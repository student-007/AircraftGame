//
//  AErrorFacade.m
//  Aircraft
//
//  Created by Yufei Lang on 12/29/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AErrorFacade.h"

@implementation AErrorFacade

+ (AErrorFacade *)sharedInstance
{
    static AErrorFacade *mainFacade;
    if(!mainFacade)
    {
        mainFacade = [[AErrorFacade alloc] init];
    }
    return mainFacade;
}

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)errorCode message:(NSString *)defaultErrorMessage
{
    NSDictionary *userInfo = nil;
    if (defaultErrorMessage)
    {
        userInfo = [NSDictionary dictionaryWithObject:defaultErrorMessage forKey:NSLocalizedDescriptionKey];
    }
    NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:userInfo];
    [AErrorFacade LogError:error];
    return error;
}

+ (NSError *)errorWithDomain:(NSString *)domain knownCode:(NSInteger)errorCode
{
    NSString *errorCodeString = [NSString stringWithFormat:@"ErrorCode%d", errorCode];
    NSString *errorLocalizedMsg = ALocalisedString(errorCodeString);
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorLocalizedMsg forKey:NSLocalizedDescriptionKey];
    
    NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:userInfo];
    [AErrorFacade LogError:error];
    return error;
}

+ (NSString *)errorMessageFromKnownErrorCode:(NSInteger)errorCode
{
    NSString *errorCodeString = [NSString stringWithFormat:@"ErrorCode%d", errorCode];
    return [NSString stringWithFormat:@"[error]: %@", ALocalisedString(errorCodeString)];
}

+ (void)LogError:(NSError *)error
{
    NSLog(@"[error]: %@\n", error.description);
}

/*!
 @discussion displays the alert message and asserts
 */
- (void)assert:(NSString *)message, ...
{
    
    va_list args;
    va_start(args, message);
    
    
    NSString *assertMessage = [[NSString alloc] initWithFormat:message arguments:args];
    
    va_end(args);
    
    NSAssert(NO, assertMessage);
}

@end
