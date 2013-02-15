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

+ (UIImage *)imageForWhiteRectBackground
{
    UIImage *image = [UIImage imageNamed:@"rectBackground_white.png"];
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(14, 14, 14, 14);
    return [image resizableImageWithCapInsets:edgeInset];
}

+ (UIImage *)imageForBlackRectBackground
{
    UIImage *image = [UIImage imageNamed:@"rectBackground_black.png"];
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(14, 14, 14, 14);
    return [image resizableImageWithCapInsets:edgeInset];
}

+ (UIImage *)imageForDarkGuideBackground
{
    UIImage *image = [UIImage imageNamed:@"darkGuideBkg.png"];
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(14, 14, 14, 14);
    return [image resizableImageWithCapInsets:edgeInset];
}

+ (UIImage *)imageForBlueRectBackground
{
    UIImage *image = [UIImage imageNamed:@"rectBackground_blue.png"];
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(14, 14, 14, 14);
    return [image resizableImageWithCapInsets:edgeInset]; 
}

+ (UIImage *)imageForOrangeRectBackground
{
    UIImage *image = [UIImage imageNamed:@"rectBackground_orange.png"];
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(14, 14, 14, 14);
    return [image resizableImageWithCapInsets:edgeInset]; 
}

+ (UIImage *)imageForDarkLightRectBackground
{
//    UIImage *image = [UIImage imageNamed:@"lightBlackBackground.png"];
//    UIEdgeInsets edgeInset = UIEdgeInsetsMake(14, 14, 14, 14);
//    return [image resizableImageWithCapInsets:edgeInset];
    return [UIImage imageNamed:@"lightBlackBackground.png"];
}

@end
