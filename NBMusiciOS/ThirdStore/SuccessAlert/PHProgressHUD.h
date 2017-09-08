//
//  PHProgressHUD.h
//  PHProgressHUD
//
//  Created by Code on 17/1/6.
//  Copyright © 2017年 Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface PHProgressHUD : NSObject
+(instancetype)shareManager;
//风火轮/菊花
+(void)showSingleWheelInView:(UIView *)view;
//简单的菊花加上简单的文字
+(void)showSingeWheelWithMsg:(NSString *)msg view:(UIView *)view;
// 简单的菊花加上简单的文字和复杂的文字
+(void)showSingleWheelWithSingelMsg:(NSString *)msg detailMsg:(NSString *)detailMsg view:(UIView *)view;
// 蛋糕状读条器
+(void)showSingleProgressView:(UIView *)view;
//暂未使用
+(void)showSingleProgressViewWithCancle:(UIView *)view;
// 蛋糕状读条器带着取消按钮
-(void)showSingleProgressViewWithCancle:(UIView *)view singleMsg:(NSString *)msg buttonTitle:(NSString *)btnMsg;
// 底部的msg
+(void)showSingleMsgInBottom:(NSString *)msg view:(UIView *)view;
//自定义的一张view
+(void)showSingleCustonImageSetmsg:(NSString *)msg view:(UIView *)view imageName:(NSString *)imageName setSquare:(BOOL)square;
//显示成功的内容
+ (void)showSuccess:(NSString *)success;
//显示失败的内容
+ (void)showError:(NSString *)error;

+ (void)showWarn:(NSString *)warn;

@end
