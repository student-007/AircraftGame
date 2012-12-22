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

/*!
 @discussion make a dictionary that can be saved into a plist 
 (keys are 1. orginPos:array[number, number] 2.direction:number)
 */
@property (readonly, nonatomic) NSDictionary *savableDictionary;


+ (AAircraftModel *)aircraftWithOrgin:(CGPoint)orgin direction:(AircraftDirection)direction;
+ (AAircraftModel *)aircraftWithSavableDictionary:(NSDictionary *)savableDictionary;

@end
