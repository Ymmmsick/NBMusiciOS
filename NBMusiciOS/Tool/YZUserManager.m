//
//  YZUserManager.m
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/8.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import "YZUserManager.h"

@implementation YZUserManager{
    YZAccessTokenModel * _accessTokenModel;
}

+ (instancetype)sharedManager
{
    static YZUserManager * globalManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!globalManager) {
            globalManager = [[YZUserManager alloc] init];
        }
    });
    return globalManager;
}

- (void)updateAccessToken:(YZAccessTokenModel *)model
{
    _accessTokenModel = model;
    // 将模型数据转换字符串
    NSString * modelStr = [model yy_modelToJSONString];
    // 储存到本地plist文件中
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:modelStr forKey:kAccessTokenModel];
    // 同步
    [userDefaults synchronize];
}

- (YZAccessTokenModel *)selectAccessToken
{
    // 读取本地plist文件
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * modelStr = [userDefaults objectForKey:kAccessTokenModel];
    if (modelStr == nil) {
        return nil;
    }
    else {
        _accessTokenModel = [YZAccessTokenModel yy_modelWithJSON:modelStr];
        return _accessTokenModel;
    }
    
}

-(void)removeAccessToken
{
    // 读取本地plist文件
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kAccessTokenModel];
}



@end
