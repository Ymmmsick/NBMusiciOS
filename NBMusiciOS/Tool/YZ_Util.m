//
//  YZ_Util.m
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/4.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import "YZ_Util.h"
#import "TWTabBarController.h"
#import "PHProgressHUD.h"
#import "APPUtility.h"

@implementation YZ_Util
+(UINavigationController *)GetRootNav
{
    NSInteger nu =((TWTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).num;
    return  ((UINavigationController *)((TWTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).viewControllers[nu]);
    
}
+(void)ShowPrompt:(NSString *)str jugge:(NSString *)ju
{
    NSString *str1= [[NSString alloc]initWithFormat:@"%@",str];
    CGSize  ci = CGSizeMake(ScreenWidth, 30);
    CGSize wight = [str1 sizeWithFont:[UIFont systemFontOfSize:18] maxSize:ci ];
    //    ZY_HUDView * zy = [[ZY_HUDView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) Str:str];
    UILabel * zy = [[UILabel alloc]init];
    zy.backgroundColor = [UIColor colorWithHexValue:0xffcd00];
    zy.layer.cornerRadius = 10;
    zy.clipsToBounds = YES;
    zy.font =[UIFont systemFontOfSize:16];
    zy.textColor = [UIColor whiteColor];
    zy.layer.cornerRadius = 7;
    zy.textAlignment=  NSTextAlignmentCenter;
    zy.text=[[NSString alloc]initWithFormat:@" %@ ",str1];
    zy.numberOfLines = 0;
    [[YZ_Util GetRootNav].view addSubview:zy];
    
    [zy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo([YZ_Util GetRootNav].view);
        make.width.mas_lessThanOrEqualTo(ScreenWidth - 80);
        make.height.mas_greaterThanOrEqualTo(34);
        
    }];
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1ull *NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        //执行操作
        //        [UIView animateWithDuration:3 animations:^{
        //            zy.alpha = 0.5;
        //        } completion:^(BOOL finished) {
        [zy removeFromSuperview];
        //        }];
    });
}
+(void)ShouTab:(NSString *)str
{
    if ([str isEqualToString:@"y"]) {
        ((TWTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).bottomView.hidden = YES;
    }else
    {
        ((TWTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).bottomView.hidden = NO;
    }
    
}
+(NSString *)achuitime
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd-hhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}
-(void)Show:(NSString *)str
{
    _zy = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _zy.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:0.7];
    CGSize  ci = CGSizeMake(ScreenWidth, 30);
    CGSize wight = [str sizeWithFont:[UIFont systemFontOfSize:18] maxSize:ci ];
    YZ_HUDView * zyz = [[YZ_HUDView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) Str:str];
    zyz.layer.cornerRadius = 7;
    [_zy addSubview:zyz];
    [zyz mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_zy);
        make.width.mas_equalTo(wight.width + 20);
        make.height.mas_equalTo(34);
        make.centerY.mas_equalTo(_zy);
    }];
    [[YZ_Util GetRootNav].view addSubview:_zy];
    
}
-(void)remove
{
    [_zy removeFromSuperview];
    _zy = nil;
}
+(NSString *)changeTheTimeStr:(NSString *)timeStr{
    //    NSString* timeStr = @"2011-01-26 17:40:50";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    //    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //    [formatter setTimeZone:timeZone];
    
    //    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    //
    //    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    //
    //    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    // 时间转时间戳的方法:
    //    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    //    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    //时间戳转时间的方法
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStr integerValue]];
    NSLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSLog(@"confromTimespStr =  %@",confromTimespStr);
    return confromTimespStr;
}

+ (void)ShowMessage:(NSString *)msg completeHandle:(Callback)callback{
       
}
//存储时间
+(void)savelogintime
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss "];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    [[NSUserDefaults standardUserDefaults]
     setValue:dateString forKey:@"time"];
    
}

+ (void)ShowSuccess:(NSString *)success{
    [PHProgressHUD showSuccess:success];
}
+ (void)ShowFail:(NSString *)fail{
    [PHProgressHUD showError:fail];
}
+ (void)ShowWarn:(NSString *)warn{
    [PHProgressHUD showWarn:warn];
}
+ (void)showMessage:(NSString *)msg{
    [APPUtility showMessage:msg];
}
+(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

+(NSString *)getJsonWithDic:(NSDictionary *)dic{
    static NSString *str;
    if ([dic allKeys].count != 0) {
        str = [YZ_Util dictionaryToJson:dic];
    }else{
        str = [AFNManagerRequest URLEncryOrDecryString:dic IsHead:YES];
    }
    
    NSString *signle = [NSString md5:str];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"data"] = str;
    params[@"sign"] = signle;
    params[@"platform"] = @"ios";
    params[@"version"] = @"1.0";
    NSString *json = [YZ_Util dictionaryToJson:params];
    
    return json;
}

//判断是否有网
+ (BOOL)isHaveNetwork{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([[userDef objectForKey:@"wifi"] isEqualToString:@"n"]) {
        return NO;
    }else{
        return YES;
    }
}

@end
