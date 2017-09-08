//
//  YZLoginOrOut.m
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/8.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import "YZLoginOrOut.h"

@implementation YZLoginOrOut

+(BOOL)IsLogin
{
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss "];
    //    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    return [dateFormatter stringFromDate:date];
    
    NSString * str = [[NSUserDefaults standardUserDefaults] valueForKey:@"time"];
    NSDate * olddate = [formatter dateFromString:str];
    
    long dd = (long)[currentDate timeIntervalSince1970] - [olddate timeIntervalSince1970];
    
    long be = [[[YZUserManager sharedManager]selectAccessToken].expires_in longLongValue];
    if ([[[YZUserManager sharedManager]selectAccessToken].expires_in isEqual:NULL]  || dd > be - 10) {
        
        NSNotification * notice = [NSNotification notificationWithName:@"login" object:nil userInfo:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        
        return NO;
    }
    return YES;
}
+ (BOOL)isRegister{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss "];
    //    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    return [dateFormatter stringFromDate:date];
    
    NSString * str = [[NSUserDefaults standardUserDefaults] valueForKey:@"time"];
    NSDate * olddate = [formatter dateFromString:str];
    
    long dd = (long)[currentDate timeIntervalSince1970] - [olddate timeIntervalSince1970];
    
    long be = [[[YZUserManager sharedManager]selectAccessToken].expires_in longLongValue];
    if ([[[YZUserManager sharedManager]selectAccessToken].expires_in isEqual:NULL]  || dd > be - 2000) {
        
        NSNotification * notice = [NSNotification notificationWithName:@"register" object:nil userInfo:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        
        return NO;
    }
    return YES;
}

+(BOOL)issharelogin
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss "];
    //    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    return [dateFormatter stringFromDate:date];
    
    NSString * str = [[NSUserDefaults standardUserDefaults] valueForKey:@"time"];
    NSDate * olddate = [formatter dateFromString:str];
    
    long dd = (long)[currentDate timeIntervalSince1970] - [olddate timeIntervalSince1970];
    
    long be = [[[YZUserManager sharedManager]selectAccessToken].expires_in longLongValue];
    if ([[[YZUserManager sharedManager]selectAccessToken].expires_in isEqual:NULL]  || dd > be - 2000) {
        return NO;
    }
    return YES;
}

+ (BOOL)YZIsLogin{
    if ([YZUserManager sharedManager].selectAccessToken.access_token.length != 0) {
        return YES;
    }
    return NO;
}


@end
