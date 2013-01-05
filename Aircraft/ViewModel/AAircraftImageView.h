//
//  AAircraftImageView.h
//  Aircraft
//
//  Created by Yufei Lang on 12/22/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAircraftModel.h"

@interface AAircraftImageView : UIImageView
{
    AAircraftModel *_aircraft;
    CGMutablePathRef _pathRef;
    UIImage *_aircraftImage;
    BOOL _isTouchingAircraftBody;
}

#pragma mark - properties
/*!
 @discussion aircraft's direction. setting this can effect how image show
 */
@property (nonatomic) AircraftDirection direction;

/*!
 @discussion aircraft's orgin, set this EQUAL TO FRAME's ORGIN ONLY after calculated position in battle grid
 */
@property (nonatomic) CGPoint orgin;

/*!
 @discussion aircraft model stored within self
 */
@property (nonatomic, readonly) AAircraftModel *aircraft;

#pragma mark - methods


@end
