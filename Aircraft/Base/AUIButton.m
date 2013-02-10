//
//  AUIButton.m
//  Aircraft
//
//  Created by Yufei Lang on 12/30/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AUIButton.h"

@implementation AUIButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitleForAllState:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateDisabled];
    [self setTitle:title forState:UIControlStateSelected];
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


@implementation AUICheckBoxButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) 
    {
        _checked = NO;
        [self setChecked:NO];
        [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _checked = NO;
        [self setChecked:NO];
        [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonPressed
{
    self.checked = !_checked;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if (checked)
    {
        [self setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    }
    [self setBackgroundColor:[UIColor clearColor]];
}

- (BOOL)isChecked
{
    return _checked;
}

@end