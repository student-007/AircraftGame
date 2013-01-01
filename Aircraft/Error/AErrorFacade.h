//
//  AErrorFacade.h
//  Aircraft
//
//  Created by Yufei Lang on 12/29/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

// define error domains
#define kErrorDomainNet         @"Net"
#define kErrorDomainOrganizer   @"Organizer"

// define error codes
// connections errors
#define kECConnCanceledByUser           1000    // bluetooth connection canceled by user
#define kECConnEptSessionOrDisconnected 1001

// parser errors
#define kECParserNotFoundOrEmpty        2000    // parser in communicator is not found or empty
#define kECParserCantFindFlag           2001    //
#define kECParserCantFindInternalClass  2002    //

// organizer errors
#define kECOrganizerCommunicatorNotFoundOrEnpty     3001

typedef enum
{
    ErrorTrivial    = 1,
    ErrorLow        = 2,
    ErrorMedium     = 3,
    ErrorMajor      = 4,
}ErrorPriority;

@interface AErrorFacade : NSObject

+ (AErrorFacade *)sharedInstance;
+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)errorCode message:(NSString *)defaultErrorMessage;
+ (NSError *)errorWithDomain:(NSString *)domain knownCode:(NSInteger)errorCode;

+ (NSString *)errorMessageFromKnownErrorCode:(NSInteger)errorCode;
+ (void)LogError:(NSError *)error;

@end
