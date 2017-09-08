//
//  UILabel+Util.m
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/1.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import "UILabel+Util.h"
#import "objc/Runtime.h"

@implementation UILabel (Util)
- (NSString *)verticalText{
    // 利用runtime添加属性
    return objc_getAssociatedObject(self, @selector(verticalText));
}

- (void)setVerticalText:(NSString *)verticalText{
    objc_setAssociatedObject(self, &verticalText, verticalText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableString *str = [[NSMutableString alloc] initWithString:verticalText];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2-1];
    }
    self.text = str;
    self.numberOfLines = 0;
}

@end
