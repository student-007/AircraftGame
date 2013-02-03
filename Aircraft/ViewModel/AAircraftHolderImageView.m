//
//  AAircraftHolderImageView.m
//  Aircraft
//
//  Created by Yufei Lang on 1/23/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "AAircraftHolderImageView.h"

@implementation AAircraftHolderImageView

@synthesize direction = _direction;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (AAircraftHolderImageView *)initWithDirection:(AircraftDirection)direction
{
    if (self = [super init])
    {
        self.direction = direction;
    }
    return self;
}

- (void)setupLongPressRecognizersWithTarget:(id)target selector:(SEL)selector
{
    UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
    longRecognizer.delegate = target;
    [self addGestureRecognizer:longRecognizer];
    longRecognizer.minimumPressDuration = 0;
}

- (void)setupPanPressRecognizersWithTarget:(id)target selector:(SEL)selector
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:selector];
    panRecognizer.delegate = target;
    [self addGestureRecognizer:panRecognizer];
}

- (void)setupRecognizersWithTarget:(id)target pressSelector:(SEL)pressSelector panSelector:(SEL)panSelector
{
    [self setupLongPressRecognizersWithTarget:target selector:pressSelector];
    [self setupPanPressRecognizersWithTarget:target selector:panSelector];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
