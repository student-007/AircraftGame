//
//  AAircraftModel.m
//  Aircraft
//
//  Created by Yufei Lang on 12/21/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AAircraftModel.h"

@implementation AAircraftModel

@synthesize orginPos = _orginPos;
@synthesize direction = _direction;
@synthesize gridArray = _gridArray;

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

+ (AAircraftModel *)aircraftWithOrgin:(CGPoint)orgin direction:(AircraftDirection)direction
{
    AAircraftModel *aircraftModel = [[AAircraftModel alloc] init];
    [aircraftModel setAircraftOrginPosition:orgin direction:direction];
    return aircraftModel;
}

- (NSMutableArray *)arrayForGrid:(int [5][5])grid
{
    NSMutableArray *res = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++)
    {
        NSMutableArray *line = [NSMutableArray arrayWithCapacity:5];
        for (int j = 0; j < 5; j++)
            [line addObject:[NSNumber numberWithInt:grid[i][j]]];
        [res addObject:line];
    }
    return res;
}

- (void)setAircraftOrginPosition:(CGPoint)orgin direction:(AircraftDirection)direction
{
    self.orginPos = orgin;
    switch (self.direction = direction)
    {
        case AircraftDirectionUp:
        {
            int grid[5][5] = {0,0,kAircraftHead,0,0,
                kAircraftBody,kAircraftBody,kAircraftBody,kAircraftBody,kAircraftBody,
                0,0,kAircraftBody,0,0,
                0,kAircraftBody,kAircraftBody,kAircraftBody,0,
                0,0,0,0,0};
            self.gridArray = [NSArray arrayWithArray:[self arrayForGrid:grid]];
        }
            break;
        case AircraftDirectionDown:
        {
            int grid[5][5] =  {0,kAircraftBody,kAircraftBody,kAircraftBody,0,
                0,0,kAircraftBody,0,0,
                kAircraftBody,kAircraftBody,kAircraftBody,kAircraftBody,kAircraftBody,
                0,0,kAircraftHead,0,0,
                0,0,0,0,0};
            self.gridArray = [NSArray arrayWithArray:[self arrayForGrid:grid]];
        }
            break;
        case AircraftDirectionLeft:
        {
            int grid[5][5] =  {0,kAircraftBody,0,0,0,
                0,kAircraftBody,0,kAircraftBody,0,
                kAircraftHead,kAircraftBody,kAircraftBody,kAircraftBody,0,
                0,kAircraftBody,0,kAircraftBody,0,
                0,kAircraftBody,0,0,0};
            self.gridArray = [NSArray arrayWithArray:[self arrayForGrid:grid]];
        }
            break;
        case AircraftDirectionRight:
        {
            int grid[5][5] =  {0,0,kAircraftBody,0,0,
                kAircraftBody,0,kAircraftBody,0,0,
                kAircraftBody,kAircraftBody,kAircraftBody,kAircraftHead,0,
                kAircraftBody,0,kAircraftBody,0,0,
                0,0,kAircraftBody,0,0};
            self.gridArray = [NSArray arrayWithArray:[self arrayForGrid:grid]];
        }
            break;
            
        default:
            break;
    }
}

 - (NSString *)description
{
    return [NSString stringWithFormat:@"[AAircraftModel] direction value: %d, orgin: (%f,%f)", _direction, _orginPos.x, _orginPos.y];
}

@end
