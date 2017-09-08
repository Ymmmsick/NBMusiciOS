//
//  YZAccessTokenModel.h
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/8.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZAccessTokenModel : NSObject
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *expires_in;
@property (nonatomic,copy) NSString *access_token;
@end
