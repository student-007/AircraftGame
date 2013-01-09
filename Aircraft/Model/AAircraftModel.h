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
    AircraftDirectionNone = -1,
    AircraftDirectionUp = 8,
    AircraftDirectionDown = 2,
    AircraftDirectionLeft = 4,
    AircraftDirectionRight = 6,
}AircraftDirection;

typedef enum
{
    AircraftNone        = 0,
    AircraftHead        = 1,
    AircraftBody        = 2
}AircraftPart;

//#define kAircraftBody    1
//#define kAircraftHead    2

@interface AAircraftModel : NSObject
{
    AircraftDirection _direction;
    int _grid[5][5];
}


/*!
 @discussion this is the orgin which is the place where to put top left connor of the aircraft in battle field
 points are human readable integers like (1, 2) or (3, 7) in the 10*10 grid.
 */
@property (nonatomic) CGPoint orginPos;

/*!
 @discussion this represents which direction of the aircraft head points to
 */
@property (nonatomic) AircraftDirection direction;

/*!
 @discussion 2D array represents a 5*5 grid (5 * 5 NSNumbers)
 */
@property (strong, nonatomic) NSArray *gridArray;

/*!
 @discussion make a dictionary that can be saved into a plist 
 (keys are 1. orginPos:array[number, number] 2.direction:number)
 */
@property (readonly, nonatomic) NSDictionary *savableDictionary;


+ (AAircraftModel *)aircraftWithOrgin:(CGPoint)orgin direction:(AircraftDirection)direction;
+ (AAircraftModel *)aircraftFromSavableDictionary:(NSDictionary *)savableDictionary;

- (AircraftPart)elementAtRow:(NSInteger)row col:(NSInteger)col;

@end
