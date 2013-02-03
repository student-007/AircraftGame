//
//  AAircraftImageView.h
//  Aircraft
//
//  Created by Yufei Lang on 12/22/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAircraftModel.h"

#define kMappingFactor 29

#define kAircraftUpImageName       @"aircraftUp.png"
#define kAircraftDownImageName     @"aircraftDown.png"
#define kAircraftLeftImageName     @"aircraftLeft.png"
#define kAircraftRightImageName    @"aircraftRight.png"

@interface AAircraftImageView : UIImageView
{
    AAircraftModel *_aircraft;
    CGMutablePathRef _pathRef;
}

#pragma mark - properties

/*!
 @discussion aircraft model stored within self
 */
@property (nonatomic, readonly) AAircraftModel *aircraft;

#pragma mark - methods

- (AAircraftImageView *)initWithAircraftModel:(AAircraftModel *)aircraft;
- (void)releasePath;

/*!
 @discussion check if the point is currently touching aircraft body. The point is based on self's coordinate system.
 */
- (BOOL)isTouchingAircraftBodyForPoint:(CGPoint)point;

@end
