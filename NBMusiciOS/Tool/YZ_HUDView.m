//
//  YZ_HUDView.m
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/4.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import "YZ_HUDView.h"

@implementation YZ_HUDView

-(instancetype)initWithFrame:(CGRect)frame Str:(NSString *)str
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexValue:0xffcd00];
        UILabel * lab = [[UILabel alloc]init];
        lab.text = str;
        lab.font =[UIFont systemFontOfSize:18];
        lab.textColor = [UIColor whiteColor];
        [self addSubview:lab];
        lab.sd_layout.centerXEqualToView(self).centerYEqualToView(self);
        
    }
    return self;
}


@end
