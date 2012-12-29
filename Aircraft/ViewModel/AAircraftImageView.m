//
//  AAircraftImageView.m
//  Aircraft
//
//  Created by Yufei Lang on 12/22/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AAircraftImageView.h"

#define kMappingFactor 29

@implementation AAircraftImageView

- (id)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image])
    {
        NSAssert((image.size.width == 5*kMappingFactor && image.size.height == 4*kMappingFactor),
                 @"[error]: wrong size of aircraft image, should be (%d, %d).", 5*kMappingFactor,4*kMappingFactor);
        self.userInteractionEnabled = YES;
        _aircraftImage = image;
        _isTouchingAircraftBody = NO;
        
        // create a aircraft path has a dircetion of UP
        _pathRef=CGPathCreateMutable();
        CGPathMoveToPoint(_pathRef, NULL, 0, kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 2 * kMappingFactor, kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 2 * kMappingFactor, 0);
        CGPathAddLineToPoint(_pathRef, NULL, 3 * kMappingFactor, 0);
        CGPathAddLineToPoint(_pathRef, NULL, 3 * kMappingFactor, kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 5 * kMappingFactor, kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 5 * kMappingFactor, 2 * kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 3 * kMappingFactor, 2 * kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 3 * kMappingFactor, 3 * kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 4 * kMappingFactor, 3 * kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 4 * kMappingFactor, 4 * kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, kMappingFactor, 4 * kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, kMappingFactor, 3 * kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 2 * kMappingFactor, 3 * kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 2 * kMappingFactor, 2 * kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 0, 2 * kMappingFactor);
        CGPathAddLineToPoint(_pathRef, NULL, 0, kMappingFactor);
        CGPathCloseSubpath(_pathRef);
    }
    return self;
}

- (CGPoint)orgin
{
    return _aircraft ?
    CGPointMake(_aircraft.orginPos.x * kMappingFactor, _aircraft.orginPos.y * kMappingFactor) :
    CGPointMake(-1, -1);
}

- (void)setOrgin:(CGPoint)orgin
{
    if (!_aircraft)
        _aircraft = [[AAircraftModel alloc] init];
    
    _aircraft.orginPos = CGPointMake(orgin.x / kMappingFactor, orgin.y / kMappingFactor);
}

#pragma mark - property

- (AAircraftModel *)aircraft
{
    return _aircraft ? _aircraft : nil;
}

- (AircraftDirection)direction
{
    return _aircraft ? _aircraft.direction : -1;
}

- (void)setDirection:(AircraftDirection)direction
{
    if (!_aircraft)
        _aircraft = [[AAircraftModel alloc] init];
    
    switch (_aircraft.direction = direction)
    {
        case AircraftDirectionUp:
        {
            
        }
            break;
        case AircraftDirectionDown:
        {
            
            self.transform = CGAffineTransformMakeRotation(M_PI);
        }
            break;
        case AircraftDirectionLeft:
        {
            
            self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
            break;
        case AircraftDirectionRight:
        {
            
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
            break;
            
        default:
            break;
    }
}

@end
