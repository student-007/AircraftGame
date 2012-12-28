//
//  ACommunicator.m
//  Aircraft
//
//  Created by Yufei Lang on 12/28/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "ACommunicator.h"

@implementation ACommunicator

+ (ACommunicator *)sharedInstance
{
    static ACommunicator *communicator = nil;
    
    if (!communicator)
    {
        communicator = [[ACommunicator alloc]init];
    }
    return  communicator;
}

@end
