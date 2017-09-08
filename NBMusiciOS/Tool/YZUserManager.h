//
//  YZUserManager.h
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/8.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZAccessTokenModel.h"

@interface YZUserManager : NSObject

// 单例
+ (instancetype)sharedManager;

// 更新AccessTokenModel
- (void)updateAccessToken:(YZAccessTokenModel * ) model;
// 从本地或者内存中获取模型
- (YZAccessTokenModel *)selectAccessToken;
//删除模型
-(void)removeAccessToken;

@end
