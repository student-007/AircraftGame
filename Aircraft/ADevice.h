//
//  ADevice.h
//  Aircraft
//
//  Created by Matt on 3/10/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )

@interface ADevice : NSObject

@end
