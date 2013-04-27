//
//  ADiagnostic.h
//  
//
//  Created by Yufei Lang on 6/28/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADiagnostic : NSObject
{
@private
    NSString *_assertMessage;
}

/*!
 @discussion retrieves the singleton instance
 */
+ (ADiagnostic *)sharedInstance;

/*!
 @abstract log the message in the console.
 @discussion Diaplay file name and line number is it is an error log.
 */
+ (void)logWithfileName:(const char *)fileName lineNumber:(int)lineNumber logType:(int)flag Message:(NSString *)message, ...;

/*!
 @discussion displays the alert message and asserts
 */
- (void)assertFromFile:(const char *)fileName atLineNumber:(int)lineNumber message:(NSString *)message, ...;

@end

#define LOG_FLAG_ERROR    (1 << 0)  // 0...0001
#define LOG_FLAG_WARN     (1 << 1)  // 0...0010
#define LOG_FLAG_INFO     (1 << 2)  // 0...0100
#define LOG_FLAG_VERBOSE  (1 << 3)  // 0...1000

#if A_ASSERT_ENABLED
#define AAssert(condition, desc, ...) \
do {			\
if (!(condition)) [[ADiagnostic sharedInstance] assertFromFile:__FILE__ atLineNumber:__LINE__ message:desc, ##__VA_ARGS__];\
} while(0)
#else
#define AAssert(condition, desc, ...)
#endif


#if A_LOG_VERBOSE
#define LogVerbose(fmt, ...) \
do {\
[ADiagnostic logWithfileName:__FILE__ lineNumber:__LINE__ logType:LOG_FLAG_VERBOSE Message:fmt, ##__VA_ARGS__];\
} while(0)
#else
#define LogVerbose(fmt, ...)
#endif

#if A_LOG_ERROR
#define LogError(fmt, ...) \
do {			\
[ADiagnostic logWithfileName:__FILE__ lineNumber:__LINE__ logType:LOG_FLAG_ERROR Message:fmt, ##__VA_ARGS__];\
} while(0)
#else
#define LogError(fmt, ...)
#endif