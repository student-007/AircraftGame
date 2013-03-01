//
//  AUserInfo.h
//  Aircraft
//
//  Created by Matt on 2/28/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    AUserTypeNone       = 0,
    AUserTypeUser       = 1,
    AUserTypeOpponent   = 2
}AUserType;

@interface AUserInfo : NSObject

@end
