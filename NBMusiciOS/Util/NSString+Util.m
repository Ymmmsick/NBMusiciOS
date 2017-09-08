//
//  NSString+Util.m
//  wantEat
//
//  Created by 千锋 on 16/2/29.
//  Copyright (c) 2016年 mobiletrain. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/types.h>
#import <sys/sysctl.h>
@implementation NSString (Util)
+ (CGSize) stringSize:(NSString *)value font:(CGFloat)font
{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize retSize = [value boundingRectWithSize:CGSizeMake(ScreenWidth-20, 250)
                                             options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    return retSize;
}
+ (NSString *)md5String:(NSMutableDictionary *)params{
    NSArray *arr = [params.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *needStr = [NSMutableString new];
    for (NSString *mStr in arr) {
        if ([mStr isEqualToString:@"from"] || [mStr isEqualToString: @"certificates"] || [mStr isEqualToString:@"sign"]) {
            continue;
        }
        NSString *valueStr =[[NSString alloc]initWithFormat:@"%@",[params valueForKey:mStr]];
        if ([valueStr isEqualToString:@""] || !valueStr) {
            continue;
        }
        [needStr appendFormat:@"%@=%@&",mStr,valueStr];
    }
//    [needStr appendString:@""];
    //先转为UTF_8编码的字符串
    const char* str = [needStr UTF8String];
    //设置一个接受字符数组
    //md5加密后是128bit, 16 字节 * 8位/字节 = 128 位
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     
     把str字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH* 2];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    //将16字节的16进制转成32字节的16进制字符串
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return [ret uppercaseString];
}

+ (NSString *) md5:(NSString *)str
{
    str = [str stringByAppendingString:@"0C7ED86F235C60C147C5EF91687030D0"];
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
//判断手机号码
+ (NSString *)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return nil;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        if (isMatch1 || isMatch2 || isMatch3) {
            return mobile;
        }else{
            return nil;
        }
    }
//    return mobile;
}
/**
 *  产生随机数
 */

+(NSString *)Generaterandom
{
    long shuzi = 100 + (arc4random() % (10000000 - 100 + 1));
    NSString * str = [[NSString alloc]initWithFormat:@"%ld",shuzi];
    return str;
    
}
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
+ (CGSize) heightForString:(NSString *)value
{
    
    NSDictionary *attribute = @{NSFontAttributeName: FONT(17)};
    CGSize retSize = [value boundingRectWithSize:CGSizeMake(ScreenWidth-20, 250)
                                         options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    return retSize;
}
+ (BOOL)isContainsTwoEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         //         NSLog(@"hs++++++++%04x",hs);
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     isEomji = YES;
                 }
                 //                 NSLog(@"uc++++++++%04x",uc);
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3|| ls ==0xfe0f) {
                 isEomji = YES;
             }
             //             NSLog(@"ls++++++++%04x",ls);
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
         
     }];
    return isEomji;
}

@end
