//
//  ADiagnostic.m
//  
//
//  Created by Yufei Lang on 6/28/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "ADiagnostic.h"

@implementation ADiagnostic

+ (ADiagnostic *)sharedInstance
{
    static ADiagnostic *diag;
    if (nil == diag)
    {
        diag = [[ADiagnostic alloc] init];
    }
    return diag;
}

+ (void)logWithfileName:(const char *)fileName lineNumber:(int)lineNumber logType:(int)flag Message:(NSString *)message, ...
{
    va_list args;
    va_start(args, message);
    NSString *msg = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);
    
    if (flag == LOG_FLAG_VERBOSE)
    {
        // for those verbose logs, do not show file name and line number. [Yufei Lang]
        //        NSLog(@"[Log verbose]: %@\n[File:%@][Line:%d]", msg, ExtractFileNameWithoutExtension(fileName, NO), lineNumber);
        NSLog(@"[Log verbose]: %@", msg);
    }
    else if (flag == LOG_FLAG_ERROR)
    {
        NSLog(@"[Log error]: %@\n[File:%@][Line:%d]", msg, ExtractFileNameWithoutExtension(fileName, NO), lineNumber);
    }
    
    [msg release];
}

- (void)assertFromFile:(const char *)fileName atLineNumber:(int)lineNumber message:(NSString *)message, ...
{
    va_list args;
    va_start(args, message);
    _assertMessage = [[[NSString alloc] initWithFormat:message arguments:args] autorelease];
    va_end(args);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Assertion happened"
                                                    message:[NSString stringWithFormat:@"Reason: %@\nWhere: %@\nAt line: %d",
                                                             _assertMessage,
                                                             ExtractFileNameWithoutExtension(fileName, NO),
                                                             lineNumber]
                                                   delegate:self
                                          cancelButtonTitle:@"Abort app"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    NSAssert(NO, _assertMessage);
    _assertMessage = nil;
}

NSString *ExtractFileNameWithoutExtension(const char *filePath, BOOL copy)
{
	if (filePath == NULL) return nil;
	
	char *lastSlash = NULL;
	char *lastDot = NULL;
	
	char *p = (char *)filePath;
	
	while (*p != '\0')
	{
		if (*p == '/')
			lastSlash = p;
		else if (*p == '.')
			lastDot = p;
		
		p++;
	}
	
	char *subStr;
	NSUInteger subLen;
	
	if (lastSlash)
	{
		if (lastDot)
		{
			// lastSlash -> lastDot
			subStr = lastSlash + 1;
			subLen = lastDot - subStr;
		}
		else
		{
			// lastSlash -> endOfString
			subStr = lastSlash + 1;
			subLen = p - subStr;
		}
	}
	else
	{
		if (lastDot)
		{
			// startOfString -> lastDot
			subStr = (char *)filePath;
			subLen = lastDot - subStr;
		}
		else
		{
			// startOfString -> endOfString
			subStr = (char *)filePath;
			subLen = p - subStr;
		}
	}
	
	if (copy)
	{
		return [[[NSString alloc] initWithBytes:subStr
                                         length:subLen
                                       encoding:NSUTF8StringEncoding] autorelease];
	}
	else
	{
		// We can take advantage of the fact that __FILE__ is a string literal.
		// Specifically, we don't need to waste time copying the string.
		// We can just tell NSString to point to a range within the string literal.
		
		return [[[NSString alloc] initWithBytesNoCopy:subStr
                                               length:subLen
                                             encoding:NSUTF8StringEncoding
                                         freeWhenDone:NO] autorelease];
	}
}

@end