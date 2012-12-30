//
//  AUITextField.m
//  Aircraft
//
//  Created by Yufei Lang on 12/30/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AUITextField.h"

@implementation AUITextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setLeftViewWithImageNamed:(NSString *)imgName;
{
    [self setLeftView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]]];
    [self setLeftViewMode:UITextFieldViewModeAlways];
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
