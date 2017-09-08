//
//  UIColor+Util.m
//  ElectricityThrough
//
//  Created by 文涛 on 2017/8/28.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)
+ (instancetype) colorWithHexValue:(NSUInteger) hexValue {
    return [self colorWithHexValue:hexValue alpha:1];
}

+ (instancetype) colorWithHexValue:(NSUInteger) hexValue alpha:(CGFloat) alpha {
    return [UIColor colorWithRed:((hexValue & 0xFF0000) >> 16) / 255.0 green:((hexValue & 0xFF00) >> 8) / 255.0 blue:(hexValue & 0xFF) / 255.0 alpha:alpha];
}
+(UIColor *)defaultColor{
    return [UIColor colorWithHexValue:0xfedb7c];
}
+ (UIColor *)lineColor{
    return [UIColor colorWithHexValue:0xEBEBED];
}

@end
