//
//  APPUtility.m
//  ZTOA
//
//  Created by ztky on 16/3/30.
//  Copyright © 2016年 ztky. All rights reserved.
//

#import "APPUtility.h"
#import "sys/utsname.h"
#import <AudioToolbox/AudioToolbox.h>


#define Flag_Height 12
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
@implementation APPUtility

#pragma mark - 1:安卓提示
+(void)showMessage:(NSString *)message
{
    float maxLabelWidth = Screen_Width - 60;
    int labelFont = 17;
    float animationTime = 2.5;
    
    // 找到最上层的Window
    // 1：让键盘显示在最前面 （方法一）
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    //  方法2：让键盘显示在最前面
    /*
     for(UIView*window in [UIApplication sharedApplication].windows)
     {
     if([window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")])
     {
         showview = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
         showview.backgroundColor = [UIColor blackColor];
         showview.alpha=1;
         [window addSubview:showview];
     }
     }
     */
    
    // 2：目的是为了控制：文本的显示距离
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];

    // 3:计算宽高
    //    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:labelFont], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize LabelSize  = [message boundingRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    // 4：创建label，适配宽度和高度
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:labelFont];
    label.numberOfLines = 0;
    [showview addSubview:label];
    
    showview.frame = CGRectMake((Screen_Width - LabelSize.width - 20)/2, Screen_Height - 60 - LabelSize.height - 10 - 35, LabelSize.width+20, LabelSize.height+10);
    
    // 5：动画  透明度动画
    [UIView animateWithDuration:animationTime animations:^{
        showview.alpha = 0.4;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

#pragma mark - 2:时间
/** 2：时间间隔 */
+ (NSDate *) dateInfoFromDate:(NSDate *)date year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSGregorianCalendar
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:date];
    // 得到的是当前的时间
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    adcomps.year = year;
    adcomps.month =  month;
    adcomps.day = day;
    adcomps.hour =  hour;
    adcomps.minute = minute;
    adcomps.second =  second;
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    
    return newdate;
}

/** 3: 日期转string */
+ (NSString *)dateStringFromDate:(NSDate *)date  dateFormat:(NSString *)formatString{
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatString];
    NSString * locationString = [dateformatter stringFromDate:date];
    return locationString;
}


/** 4: string转date
 yyyy-MM-dd HH:mm:ss
 */
+ (NSDate *)dateFromDateString:(NSString *)dateString  dateFormat:(NSString *)formatString
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatString];
    NSDate * locationDate =[dateformatter dateFromString:dateString];
    return locationDate;
}

/** 5:时间比较
 yyyy-MM-dd HH:mm:ss
 1： 开始时间比结束时间小
 -1： 开始时间比结束时间大
 0： 开始时间和结束时间一样大
 */
+ (int)compareWithStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate dateFormat:(NSString *)formatString isShowMessage:(BOOL)isShow;
{// 把日期转化成需要比较的格式
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    
    NSString *startDateStr = [dateFormatter stringFromDate:startDate];
    NSString *endDateStr = [dateFormatter stringFromDate:endDate];
    NSDate *startDateFormat = [dateFormatter dateFromString:startDateStr];
    NSDate *endDateFormat = [dateFormatter dateFromString:endDateStr];
    
    NSComparisonResult result = [startDateFormat compare:endDateFormat];
    //    NSLog(@"开始时间 : %@, 结束时间 : %@", startDateStr, endDateStr);
    if (result == NSOrderedDescending) {
        //NSLog(@"错误：开始时间比结束时间 大");
        if (isShow == YES)
            [APPUtility showMessage:[NSString stringWithFormat:@"开始时间: %@ 比\n结束时间: %@ 大", startDateFormat, endDateFormat]];
        
        return -1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"正确：开始时间比结束时间小");
        if (isShow == YES)
            [APPUtility showMessage:[NSString stringWithFormat:@"开始时间: %@ 比\n结束时间: %@ 小", startDateFormat, endDateFormat]];
        return 1;
    }else{
        if (isShow == YES)
            [APPUtility showMessage:[NSString stringWithFormat:@"开始时间: %@ 比\n结束时间: %@ 相等", startDateFormat, endDateFormat]];
        return 0;

    }
    //NSLog(@"Both dates are the same");
    return 0;
}

//6：将NSDate类型的时间转换为时间戳,从1970/1/1开始
+(NSString *)secondFromDate:(NSDate *)date isSecond:(BOOL)isSecond
{
    NSTimeInterval interval = [date timeIntervalSince1970];
    long long milliseconds;
    if (isSecond == YES) {
        milliseconds = interval;
    }else{
        milliseconds = interval*1000 ;
    }
    NSLog(@"时间戳：%lld",milliseconds);
    NSString *second = [NSString stringWithFormat:@"%lld", milliseconds];
    return second;
}

/** 7：时间戳转日期
 */
+(NSString *)dateFromSecond:(NSString *)second isSecond:(BOOL)isSecond dateFormat:(NSString *)format;
{
    long long time=[second longLongValue];
    NSDate *date;
    if (isSecond == YES) {
        date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    }else{
       date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSString*timeString=[formatter stringFromDate:date];
    return timeString;
}

/** 8:获取当前日期---星期几 */
+ (NSInteger)weekdayStringFromDate:(NSDate*)inputDate
{
    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    NSString *str = [weekdays objectAtIndex:theComponents.weekday];
    NSLog(@"星期:%@", str);
    NSDictionary *dic = @{
                          @"周一":@"1",
                          @"周二":@"2",
                          @"周三":@"3",
                          @"周四":@"4",
                          @"周五":@"5",
                          @"周六":@"6",
                          @"周日":@"7",
                          };
    NSString *string = [dic objectForKey:str];
    return [string integerValue];
}

#pragma mark - 计算文本的宽高
/* 计算宽度
 string:字符串
 font：字体
 maxWidth：最大宽度
 height：高度限制
 */
+ (CGSize)widthOfString:(NSString *)string font:(UIFont *)font  heightOfHang:(float)height
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size  = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    /*
     This method returns fractional(小数) sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
     */
    
    // 取整
    size.height = ceil(size.height);
    size.width = ceil(size.width);
    
    return size;
}

// 计算高度
+ (CGSize)heightOfString:(NSString *)string font:(UIFont *)font width:(float)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size  = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    /*
     This method returns fractional(小数) sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
     */
    
    // 取整
    size.height = ceil(size.height);
    size.width = ceil(size.width);
    
    return size;
}

#pragma mark - 其他


+ (void)textIndentWithTextField:(UITextField *)textField
{
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    leftView.userInteractionEnabled = NO;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

+ (UILabel *)addFlag:(NSString *)flag ToButton:(UIButton *)button
{
    int height = Flag_Height;
    UIFont *font = [UIFont systemFontOfSize:8];
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGSize tittleSize  = [flag boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = flag;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.backgroundColor = [UIColor redColor];
    if (flag.length ==1 ) {
        label.frame = CGRectMake(CGRectGetWidth(button.frame) - height, 0, height, height);
    }else if(flag.length > 1){
        label.frame = CGRectMake(CGRectGetWidth(button.frame) - tittleSize.width - 6, 0, tittleSize.width + 6, height);
    }
    
    if (tittleSize.width + 10 >= CGRectGetWidth(button.frame))
    {
        label.frame = CGRectMake(10, 0, CGRectGetWidth(button.frame) - 10, height);
        
    }
    [button addSubview:label];
    
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = height/2;
    label.layer.borderWidth = 1.0;
    label.layer.borderColor = [[UIColor redColor] CGColor];
    
    return label;
}

+ (void)reloadData:(UILabel *)label toButton:(UIButton *)button
{
    NSDictionary *attributes = @{NSFontAttributeName:label.font};
    CGSize tittleSize  = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    if (label.text.length ==1 ) {
        label.frame = CGRectMake(CGRectGetWidth(button.frame) - Flag_Height, 0, Flag_Height, Flag_Height);
    }else if(label.text.length > 1){
        label.frame = CGRectMake(CGRectGetWidth(button.frame) - tittleSize.width - 6, 0, tittleSize.width + 6, Flag_Height);
    }
    
    if (tittleSize.width + 10 >= CGRectGetWidth(button.frame))
    {
        label.frame = CGRectMake(10, 0, CGRectGetWidth(button.frame) - 10, Flag_Height);
    }
}


/** 按钮 图片文字 垂直 居中 */
+ (void)adjustPositionToButton:(UIButton *)button
{
    // 准备条件
    NSDictionary *attributes = @{NSFontAttributeName:button.titleLabel.font};
    CGSize tittleSize  = [button.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    float spaceOfTittleImage = 10;
    float contentHeight = tittleSize.height + button.currentImage.size.height + spaceOfTittleImage;
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    // 图片移动距离
    // 距顶距离
    float topSpace = (CGRectGetHeight(button.frame) - contentHeight)/2;
    // 右移距离
    float leftImageSpace = (CGRectGetWidth(button.frame) - button.currentImage.size.width)/2;
    button.imageEdgeInsets = UIEdgeInsetsMake(topSpace , leftImageSpace,0,0);
    
    
    // 标题
    // 向下移动
    float bottom = button.currentImage.size.height + spaceOfTittleImage + topSpace - 15;
    
    // 右移距离
    float right = (CGRectGetWidth(button.frame) - tittleSize.width)/2 - button.currentImage.size.width + 5;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(bottom,right, 0, 0);
}


/* 添加圆角 */
+ (void)addRoundLayerToView:(UIView *)view
{
    // 圆角
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 6.0;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [view.backgroundColor CGColor];
}

+ (void)addRoundLayerToView:(UIView *)view withColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [color CGColor];
}

// 解码
+ (NSString *)base64Decode:(NSString *)strBase64
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:strBase64 options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

// 编码
+ (NSString *)base64Encode:(NSString *)strNormal
{
    NSData *data = [strNormal dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

+ (NSDictionary *)getLoginMessage
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"login.plist"];
    // 读取数据
    NSDictionary *dic= [NSDictionary dictionaryWithContentsOfFile:fileName];
    NSLog(@"存储的数据：%@", dic);
    return dic;
}

+(NSString *)getLoginName;
{
    NSDictionary *dic = [APPUtility getLoginMessage];
    NSString *name = dic[@"EmployeeName"];
    return name;
    
}

+ (NSString *)pinjieStringOfArray:(NSArray *)array withString:(NSString *)sepString
{
    NSString *string = @"";
    if (array.count == 0) {
        return string;
    }
    
    if (array.count == 1) {
        return array[0];
    }
    
    for (int i = 0; i < array.count; i++)
    {
        if ( i < array.count - 1)
        {
            string = [NSString stringWithFormat:@"%@%@%@",string, array[i], sepString];
        }else if (i == array.count - 1 )
        {
            string = [NSString stringWithFormat:@"%@%@",string, array[i] ];
        }
    }
    
    return string;
}

/** 判断是移动电话号码 */
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码  152,147,178,184    145,176   177,181
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[5-7]|5[0-35-9]|8[0-24-9]|7[0-9])\\d{8}$";
    
    
    /**
     10         * 中国移动：China Mobile 152,147,178,184
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0-27-9]|78|8[2-478]|47)\\d)\\d{7}$";
    
    
    /**
     15         * 中国联通：China Unicom  145,176
     16         * 130,131,132,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|45|5[56]|76|8[56])\\d{8}$";
    
    
    /**
     20         * 中国电信：China Telecom  177,181
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[019])[0-9]|349)\\d{7}$";
    
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    //     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    /**
     全国
     */
//    NSString *PHS = @"(\\d{4}-|\\d{3}-)?(\\d{8}|\\d{7})";
    
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    BOOL mobile = [regextestmobile evaluateWithObject:mobileNum];
    BOOL mobileCM = [regextestcm evaluateWithObject:mobileNum];
    BOOL mobileCU = [regextestcu evaluateWithObject:mobileNum];
    BOOL mobileCT = [regextestct evaluateWithObject:mobileNum];
//    BOOL mobilePHS = [regextestPHS evaluateWithObject:mobileNum];
//    NSLog(@"号码：%d, 移动：%d， 联通：%d， 电信：%d，固定电话：%zd", mobile, mobileCM, mobileCU, mobileCT, mobilePHS);
    NSLog(@"号码：%d, 移动：%d， 联通：%d， 电信：%d", mobile, mobileCM, mobileCU, mobileCT);
    
    if (   (mobile == YES)
        || (mobileCM == YES)
        || (mobileCU == YES)
        || (mobileCT == YES)
//        || (mobilePHS == YES)
        )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)hasUnOpenFile:(NSString *)fileName;
{
    //    NSString *stri = @"dfahkdj.zip";
//    NSString *stri = @"dfahkdj.rar";
    BOOL zip =  [fileName hasSuffix:@".zip"];
    BOOL rar =  [fileName hasSuffix:@".rar"];
    if (zip == YES  || rar == YES)
    {
        NSLog(@"有");
        return YES;
    }else{
        NSLog(@"没哟");
        return NO;
    }
}




/**
 *  设备版本
 *
 *  @return e.g. iPhone 5S
 */
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod
    
    if ([deviceString isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G"; return @"iPod Touch 5G";
    
    //iPad
//    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
//    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
//    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
//    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
//    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
//    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
//    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
//    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
//    
//    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
//    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
//    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
//    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
//    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
//    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
//    
//    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
//    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
//    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
//    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
//    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
//    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
//    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
//    
//    if ([deviceString isEqualToString:@"iPad4,4"]||[deviceString isEqualToString:@"iPad4,5"]||[deviceString isEqualToString:@"iPad4,6"])  return @"iPad mini 2";
//    
//   if ([deviceString isEqualToString:@"iPad4,7"]||[deviceString isEqualToString:@"iPad4,8"]||[deviceString isEqualToString:@"iPad4,9"])  return @"iPad mini 3";
    return deviceString;
}



//调用系统铃声
+ (void)soundWithName:(NSString *)soundName soundType:(NSString *)soundType
{
    static SystemSoundID soundIDTest = 0;
    
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest);
        AudioServicesPlaySystemSound(soundIDTest);
        
    }
}


+ (NSString *) stringDeleteString:(NSString *)str
{
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if ( c == '"' || c == '.' || c == ',' || c == '(' || c == ')'|| c == '-') { //此处可以是任何字符
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    return newstr;
}



// 毫秒转时间
+ (NSString *)ConvertStrToTime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
}


// 毫秒转时间
+ (NSString *)ConvertSecondStrToTime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
}
@end
