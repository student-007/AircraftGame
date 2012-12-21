//
//  AAircraftModel.h
//  Aircraft
//
//  Created by Yufei Lang on 12/21/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    AircraftDirectionUp = 8,
    AircraftDirectionDown = 2,
    AircraftDirectionLeft = 4,
    AircraftDirectionRight = 6,
}AircraftDirection;

#define kAircraftBody    1
#define kAircraftHead    2

@interface AAircraftModel : NSObject

/*!
 @discussion orgin point at top left of the aircraft grid
 */
@property (nonatomic) CGPoint orginPos;

/*!
 @discussion this represents which direction of the aircraft head points to
 */
@property (nonatomic) AircraftDirection direction;

/*!
 @discussion 2D array represents a 5*5 grid (NSNumber values stored)
 */
@property (strong, nonatomic) NSArray *gridArray;


+ (AAircraftModel *)aircraftWithOrgin:(CGPoint)orgin direction:(AircraftDirection)direction;

@end
