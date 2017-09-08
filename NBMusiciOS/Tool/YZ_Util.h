//
//  YZ_Util.h
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/4.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZ_HUDView.h"

typedef void(^Callback)(id result);

@interface YZ_Util : NSObject
+(UINavigationController *)GetRootNav;
+(void)ShowPrompt:(NSString *)str jugge:(NSString *)ju;
+(void)ShowMessage:(NSString *)msg completeHandle:(Callback)callback;
+(void)ShowSuccess:(NSString *) success;
+(void)ShowFail:(NSString *) fail;
+(void)showMessage:(NSString *) msg;
+(void)ShowWarn:(NSString *) warn;
-(void)Show:(NSString *)str;
-(void)remove;
@property(nonatomic,strong)UIView * zy;
+(void)ShouTab:(NSString *)str;
+(NSString *)achuitime;
-(UIView *)shangchuan:(float)value;
+(void)savelogintime;
@property(nonatomic,strong)UIButton * cancel;
+(NSString *) changeTheTimeStr:(NSString *) timeStr;
+(NSString*)dictionaryToJson:(NSDictionary *)dic;
+(NSString*)getJsonWithDic:(NSDictionary *) dic;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (BOOL) isHaveNetwork;

@end
