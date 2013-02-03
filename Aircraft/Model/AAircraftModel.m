//
//  AAircraftModel.m
//  Aircraft
//
//  Created by Yufei Lang on 12/21/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AAircraftModel.h"

@interface AAircraftModel()
{
@private

}
- (void)setAircraftOrginPosition:(CGPoint)orgin direction:(AircraftDirection)direction;
@end

@implementation AAircraftModel

@synthesize orginPos = _orginPos;
//@synthesize direction = _direction;
@synthesize gridArray = _gridArray;

- (id)init
{
    if (self = [super init])
    {
        _direction = AircraftDirectionNone;
        _orginPos = CGPointMake(-1, -1);
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
    for (int row = 0; row < 5; row++)
    {
        NSMutableArray *line = [NSMutableArray arrayWithCapacity:5];
        for (int col = 0; col < 5; col++)
            [line addObject:[NSNumber numberWithInt:grid[row][col]]];
        [res addObject:line];
    }
    return res;
}

- (void)setAircraftOrginPosition:(CGPoint)orgin direction:(AircraftDirection)direction
{
    _orginPos = orgin;
    switch (_direction = direction)
    {
        case AircraftDirectionUp:
        {
            int grid[5][5] = {AircraftNone,AircraftNone,AircraftHead,AircraftNone,AircraftNone,
                AircraftBody,AircraftBody,AircraftBody,AircraftBody,AircraftBody,
                AircraftNone,AircraftNone,AircraftBody,AircraftNone,AircraftNone,
                AircraftNone,AircraftBody,AircraftBody,AircraftBody,AircraftNone,
                AircraftNone,AircraftNone,AircraftNone,AircraftNone,AircraftNone};
            memcpy(_grid, grid, sizeof(int)*25);
            self.gridArray = [NSArray arrayWithArray:[self arrayForGrid:grid]];
        }
            break;
        case AircraftDirectionDown:
        {
            int grid[5][5] =  {AircraftNone,AircraftBody,AircraftBody,AircraftBody,AircraftNone,
                AircraftNone,AircraftNone,AircraftBody,AircraftNone,AircraftNone,
                AircraftBody,AircraftBody,AircraftBody,AircraftBody,AircraftBody,
                AircraftNone,AircraftNone,AircraftHead,AircraftNone,AircraftNone,
                AircraftNone,AircraftNone,AircraftNone,AircraftNone,AircraftNone};
            memcpy(_grid, grid, sizeof(int)*25);
            self.gridArray = [NSArray arrayWithArray:[self arrayForGrid:grid]];
        }
            break;
        case AircraftDirectionLeft:
        {
            int grid[5][5] =  {AircraftNone,AircraftBody,AircraftNone,AircraftNone,AircraftNone,
                AircraftNone,AircraftBody,AircraftNone,AircraftBody,AircraftNone,
                AircraftHead,AircraftBody,AircraftBody,AircraftBody,AircraftNone,
                AircraftNone,AircraftBody,AircraftNone,AircraftBody,AircraftNone,
                AircraftNone,AircraftBody,AircraftNone,AircraftNone,AircraftNone};
            memcpy(_grid, grid, sizeof(int)*25);
            self.gridArray = [NSArray arrayWithArray:[self arrayForGrid:grid]];
        }
            break;
        case AircraftDirectionRight:
        {
            int grid[5][5] =  {AircraftNone,AircraftNone,AircraftBody,AircraftNone,AircraftNone,
                AircraftBody,AircraftNone,AircraftBody,AircraftNone,AircraftNone,
                AircraftBody,AircraftBody,AircraftBody,AircraftHead,AircraftNone,
                AircraftBody,AircraftNone,AircraftBody,AircraftNone,AircraftNone,
                AircraftNone,AircraftNone,AircraftBody,AircraftNone,AircraftNone};
            memcpy(_grid, grid, sizeof(int)*25);
            self.gridArray = [NSArray arrayWithArray:[self arrayForGrid:grid]];
        }
            break;
            
        default:
            break;
    }
}

- (NSDictionary *)savableDictionary
{
    NSArray *orginPos = [NSArray arrayWithObjects:[NSNumber numberWithInt:_orginPos.x],
                         [NSNumber numberWithInt:_orginPos.y], nil];
    NSNumber *direction = [NSNumber numberWithInt:_direction];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
                         orginPos, @"orginPos",
                         direction, @"direction", nil];
}

+ (AAircraftModel *)aircraftFromSavableDictionary:(NSDictionary *)savableDictionary
{
    NSArray *orginPosAry = [savableDictionary valueForKey:@"orginPos"];
    CGPoint orginPos = CGPointMake([(NSNumber *)[orginPosAry objectAtIndex:0] intValue],
                                   [(NSNumber *)[orginPosAry objectAtIndex:1] intValue]);
    AircraftDirection direction = [((NSNumber *)[savableDictionary valueForKey:@"direction"]) intValue];
    return [AAircraftModel aircraftWithOrgin:orginPos direction:direction];
}

 - (NSString *)description
{
    return [NSString stringWithFormat:@"[AAircraftModel] direction value: %d, orgin: (%f,%f)", _direction, _orginPos.x, _orginPos.y];
}

- (AircraftPart)elementAtRow:(NSInteger)row col:(NSInteger)col
{
    return [[[self.gridArray objectAtIndex:row] objectAtIndex:col] intValue];
}

#pragma mark - property synthesizer

 - (AircraftDirection)direction
{
    return _direction;
}

- (void)setDirection:(AircraftDirection)direction
{
    [self setAircraftOrginPosition:_orginPos direction:(_direction = direction)];
}

@end
