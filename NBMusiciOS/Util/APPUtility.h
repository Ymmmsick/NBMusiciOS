//
//  APPUtility.h
//  ZTOA
//
//  Created by ztky on 16/3/30.
//  Copyright © 2016年 ztky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface APPUtility : NSObject
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#pragma mark - 1:安卓提示
/** 1：安卓一样的提示 */
+(void)showMessage:(NSString *)message;

#pragma mark - 2:时间
/** 2：时间间隔
 正数：是向后
 负数：是向前
 */
+ (NSDate *) dateInfoFromDate:(NSDate *)date year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second ;

/** 3: 日期转string 
 yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)dateStringFromDate:(NSDate *)date  dateFormat:(NSString *)formatString;

/** 4: string转date
 yyyy-MM-dd HH:mm:ss
 */
+ (NSDate *)dateFromDateString:(NSString *)dateString  dateFormat:(NSString *)formatString;

/** 5:时间比较 
 yyyy-MM-dd HH:mm:ss
  1： 开始时间比结束时间小
 -1： 开始时间比结束时间大
  0： 开始时间和结束时间一样大
  */
+ (int)compareWithStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate dateFormat:(NSString *)formatString isShowMessage:(BOOL)isShow;

/** 6：日期转时间戳
 */
+(NSString *)secondFromDate:(NSDate *)date isSecond:(BOOL)isSecond;

/** 7：时间戳转日期
 */
+(NSString *)dateFromSecond:(NSString *)second isSecond:(BOOL)iSecond dateFormat:(NSString *)format;

/** 8:获取当前日期---星期几 */
+ (NSInteger)weekdayStringFromDate:(NSDate*)inputDate;

#pragma mark - 计算文本的宽高
/* 9：计算文本宽度
 string:字符串
 font：字体
 height：高度限制
 */
+ (CGSize)widthOfString:(NSString *)string font:(UIFont *)font heightOfHang:(float)height;

/* 10：计算文本高度
 string:字符串
 font：字体
 maxWidth：最大宽度
 */
+ (CGSize)heightOfString:(NSString *)string font:(UIFont *)font width:(float)width;

#pragma mark- 其他

// 文本缩进
+ (void)textIndentWithTextField:(UITextField *)textField;

/** 按钮添加小红帽 */ 
+ (UILabel *)addFlag:(NSString *)flag ToButton:(UIButton *)button;

/** 刷新小红帽 */
+ (void)reloadData:(UILabel *)label toButton:(UIButton *)button;

/** 按钮 图片文字 垂直 居中 */
+ (void)adjustPositionToButton:(UIButton *)button;

/* 添加圆角 */
+ (void)addRoundLayerToView:(UIView *)view;
+ (void)addRoundLayerToView:(UIView *)view withColor:(UIColor *)color;


+ (NSString *)base64Encode:(NSString *)strNormal;

+ (NSString *)base64Decode:(NSString *)strBase64;


/** 获取登录信息 */
+ (NSDictionary *)getLoginMessage;

+(NSString *)getLoginName;

/** 拼接字符串 */
+ (NSString *)pinjieStringOfArray:(NSArray *)array withString:(NSString *)sepString;

/** 判断是移动电话号码 */
+ (BOOL)validateMobile:(NSString *)mobileNum;

/** 判断打不开的文件 */
+ (BOOL)hasUnOpenFile:(NSString *)fileName;



/** 获取手机类型 */
+ (NSString*)deviceVersion;

+ (void)soundWithName:(NSString *)soundName soundType:(NSString *)soundType;

/** 删除指定的字符串 */
+ (NSString *) stringDeleteString:(NSString *)str;

@end
