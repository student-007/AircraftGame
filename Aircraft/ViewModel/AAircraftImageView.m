//
//  AAircraftImageView.m
//  Aircraft
//
//  Created by Yufei Lang on 12/22/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AAircraftImageView.h"

@interface AAircraftImageView () 
{
@private
    
}
- (void)adjustFrameBasedOnAircraftOrginPos:(CGPoint)orgin;
- (void)setDirection:(AircraftDirection)direction;

@end

@implementation AAircraftImageView

@synthesize aircraft = _aircraft;

- (AAircraftImageView *)initWithAircraftModel:(AAircraftModel *)aircraft imageType:(AAircraftImgType)imgType
{
    _imgType = imgType;
    UIImage *aircraftImg = nil;
    switch (aircraft.direction)
    {
        case AircraftDirectionNone:
        {
            NSAssert(NO, [AErrorFacade errorMessageFromKnownErrorCode:kECAircraftVNoneDirection]);
        }
            break;
        case AircraftDirectionUp:
        {
            switch (imgType)
            {
                case AAircraftImgRegularType:
                    aircraftImg = [UIImage imageNamed:kAircraftUpImageName];
                    break;
                case AAircraftImgDottedType:
                    aircraftImg = [UIImage imageNamed:kAircraftDottedImageName];
                    break;
                default:
                    break;
            }
        }
            break;
        case AircraftDirectionDown:
        {
            switch (imgType)
            {
                case AAircraftImgRegularType:
                    aircraftImg = [UIImage imageNamed:kAircraftDownImageName];
                    break;
                case AAircraftImgDottedType:
                    aircraftImg = [UIImage imageNamed:kAircraftDottedImageName];
                    break;
                default:
                    break;
            }
        }
            break;
        case AircraftDirectionLeft:
        {
            switch (imgType)
            {
                case AAircraftImgRegularType:
                    aircraftImg = [UIImage imageNamed:kAircraftLeftImageName];
                    break;
                case AAircraftImgDottedType:
                    aircraftImg = [UIImage imageNamed:kAircraftDottedImageName];
                    break;
                default:
                    break;
            }
        }
            break;
        case AircraftDirectionRight:
        {
            switch (imgType)
            {
                case AAircraftImgRegularType:
                    aircraftImg = [UIImage imageNamed:kAircraftRightImageName];
                    break;
                case AAircraftImgDottedType:
                    aircraftImg = [UIImage imageNamed:kAircraftDottedImageName];
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    
    if (self = [super initWithImage:aircraftImg])
    {
        NSAssert((aircraftImg.size.width == 5 * kMappingFactor &&
                  aircraftImg.size.height == 4 * kMappingFactor),
                 @"[error]: wrong size of aircraft image, should be (%d, %d).", 5*kMappingFactor,4*kMappingFactor);
        self.userInteractionEnabled = YES;
        
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
        
        _aircraft = aircraft;
        
        [self setDirection:aircraft.direction];
        [self adjustFrameBasedOnAircraftOrginPos:aircraft.orginPos];
    }
    return self;
}

- (AAircraftImageView *)initWithAircraftModel:(AAircraftModel *)aircraft
{
    return [self initWithAircraftModel:aircraft imageType:AAircraftImgRegularType];
}

- (void)releasePath
{
    if (_pathRef)
        CGPathRelease(_pathRef);
}

- (void)adjustFrameBasedOnAircraftOrginPos:(CGPoint)orgin
{
    int orginX = orgin.x * kMappingFactor;
    int orginY = orgin.y * kMappingFactor;
    self.frame = CGRectMake(orginX, orginY, self.frame.size.width, self.frame.size.height);
}

- (void)setDirection:(AircraftDirection)direction
{
    switch (direction)
    {
        case AircraftDirectionNone:
        {
            NSLog(@"[warning]: set aircraft direction none at aircraft image view!");
        }
            break;
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

- (BOOL)isTouchingAircraftBodyForPoint:(CGPoint)point
{
    switch (self.aircraft.direction)
    {
        case AircraftDirectionNone:
        {
            return NO;
        }
            break;
        case AircraftDirectionUp:
        {
            if (CGPathContainsPoint(_pathRef, NULL, point, NO))
                return YES;
            else
                return NO;
        }
            break;
        case AircraftDirectionDown:
        {
            //            CGAffineTransform transf = CGAffineTransformMakeRotation(M_PI);
            if (CGPathContainsPoint(_pathRef, NULL, point, NO))
                return YES;
            else
                return NO;
        }
            break;
        case AircraftDirectionLeft:
        {
            //            CGAffineTransform transf = CGAffineTransformMakeRotation(-M_PI_2);
            if (CGPathContainsPoint(_pathRef, NULL, point, NO))
                return YES;
            else
                return NO;
        }
            break;
        case AircraftDirectionRight:
        {
            //            CGAffineTransform transf = CGAffineTransformMakeRotation(M_PI_2);
            if (CGPathContainsPoint(_pathRef, NULL, point, NO))
                return YES;
            else
                return NO;
        }
            break;
        default:
            return NO;
    }
}

- (AAircraftModel *)aircraft
{
    return _aircraft ? _aircraft : nil;
}

- (AAircraftImgType)imgType
{
    return _imgType;
}

@end
