//
//  AUIButton.h
//  Aircraft
//
//  Created by Yufei Lang on 12/30/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AUIButton : UIButton

- (void)setTitleForAllState:(NSString *)title;

@end

@interface AUICheckBoxButton : AUIButton
{
    BOOL _checked;      // default: NO
}

@property (nonatomic, getter = isChecked) BOOL checked;

@end
