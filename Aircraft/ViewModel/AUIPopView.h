//
//  AUIPopView.h
//  Aircraft
//
//  Created by Yufei Lang on 13-2-9.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AUIPopView : NSObject
{
    UIImage *_backgroundImage;          // default: nil
    UIImage *_image;                    // default: nil
    CGSize _size;                       // default: 0,0
    NSTimeInterval _dissmissDuration;   // default: 1
    NSString *_text;
}

@property (strong, nonatomic) UIImage *backgroundImage;  // default: nil
@property (strong, nonatomic) UIImage *image;            // default: nil
@property (nonatomic) CGSize size;                       // default: 0,0
@property (nonatomic) NSTimeInterval dissmissDuration;   // default: 1
@property (strong, nonatomic) NSString *text;            // default: nil
@property (strong, nonatomic) UILabel *textLabel;

+ (AUIPopView *)popViewWithText:(NSString *)text image:(UIImage *)image size:(CGSize)size dissmissDuration:(NSTimeInterval)dissmissDuration;

- (void)show;
- (void)dissmissPopView;
@end
