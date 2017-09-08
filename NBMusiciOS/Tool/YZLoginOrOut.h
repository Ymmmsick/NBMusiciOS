//
//  YZLoginOrOut.h
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/8.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZLoginOrOut : NSObject
/**判断登录过期*/
+(BOOL)IsLogin;
+(BOOL)isRegister;
+(BOOL)issharelogin;
+(BOOL)YZIsLogin;
@end
