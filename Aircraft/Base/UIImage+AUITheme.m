//
//  UIImage+AUITheme.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-8.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "UIImage+AUITheme.h"

@implementation UIImage(AUITheme)

+ (UIImage *)imageWithExplosionAnimation
{    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i = 1; i <= 90; i++) 
    {
        UIImage *subImg = [UIImage imageNamed:[NSString stringWithFormat:@"explosion1_00%.2d", i]];
        [imgArray addObject:subImg];
    }
    
    UIImage *image = [UIImage animatedImageWithImages:imgArray duration:1.0f];
    return image;
}

@end
