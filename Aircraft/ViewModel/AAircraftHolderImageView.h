//
//  AAircraftHolderImageView.h
//  Aircraft
//
//  Created by Yufei Lang on 1/23/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAircraftModel.h"

@interface AAircraftHolderImageView : UIImageView

@property (nonatomic) AircraftDirection direction;

- (AAircraftHolderImageView *)initWithDirection:(AircraftDirection)direction;
- (void)setupLongPressRecognizersWithTarget:(id)target selector:(SEL)selector;
- (void)setupPanPressRecognizersWithTarget:(id)target selector:(SEL)selector;
- (void)setupRecognizersWithTarget:(id)target pressSelector:(SEL)pressSelector panSelector:(SEL)panSelector;
@end
