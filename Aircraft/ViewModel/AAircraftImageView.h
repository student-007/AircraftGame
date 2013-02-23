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
#define kAircraftDottedImageName   @"aircraftDotted.png"

typedef enum
{
    AAircraftImgRegularType     = 1,
    AAircraftImgDottedType     = 2
}AAircraftImgType;

@interface AAircraftImageView : UIImageView
{
    AAircraftImgType _imgType;
    AAircraftModel *_aircraft;
    CGMutablePathRef _pathRef;
}

#pragma mark - properties

/*!
 @discussion aircraft model stored within self
 */
@property (nonatomic, readonly) AAircraftModel *aircraft;

/*!
 @discussion aircraft image type
 */
@property (readonly) AAircraftImgType imgType;

#pragma mark - methods
- (AAircraftImageView *)initWithAircraftModel:(AAircraftModel *)aircraft imageType:(AAircraftImgType)imgType;
- (AAircraftImageView *)initWithAircraftModel:(AAircraftModel *)aircraft; // default aircraft image
- (void)releasePath;

/*!
 @discussion check if the point is currently touching aircraft body. The point is based on self's coordinate system.
 */
- (BOOL)isTouchingAircraftBodyForPoint:(CGPoint)point;

@end
