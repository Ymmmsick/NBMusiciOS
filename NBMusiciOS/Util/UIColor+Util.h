//
//  UIColor+Util.h
//  ElectricityThrough
//
//  Created by 文涛 on 2017/8/28.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)
/**用16进制数指定颜色*/
+ (instancetype) colorWithHexValue:(NSUInteger) hexValue;
/**用16进制数和alpha通道指定颜色*/
+ (instancetype) colorWithHexValue:(NSUInteger) hexValue alpha:(CGFloat) alpha;
/**UI通用颜色值*/
+ (UIColor *) defaultColor;
/**分割线通用颜色*/
+ (UIColor *) lineColor;
@end
