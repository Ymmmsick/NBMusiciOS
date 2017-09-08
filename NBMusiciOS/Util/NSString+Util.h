//
//  NSString+Util.h
//  wantEat
//
//  Created by 千锋 on 16/2/29.
//  Copyright (c) 2016年 mobiletrain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)
/**根据文字大小及长度计算文字的高度*/
+(CGSize) heightForString:(NSString *)value;
+(CGSize) stringSize:(NSString *)value font:(CGFloat)font;
/**网络请求,MD5加密*/
+(NSString *)md5String:(NSDictionary *)params;
+(NSString *) md5:(NSString *)str;
//判断手机号码
+(NSString *)valiMobile:(NSString *)mobile;
+(NSString *)Generaterandom;
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
//过滤emoj字符
+ (BOOL)isContainsTwoEmoji:(NSString *)string;
@end
