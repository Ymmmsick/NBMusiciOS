//
//  YZ_MobileCheck.h
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/4.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZ_MobileCheck : NSObject
@property (nonatomic,copy)NSString *reg_time;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *nick_name;
@property (nonatomic,copy)NSString *c_mac;
@property (nonatomic,copy)NSString *fr;
@property (nonatomic,copy)NSString *uname;
@property (nonatomic,copy)NSString *ad_code;
@property (nonatomic,copy)NSString *last_login;
@property (nonatomic,copy)NSString *ip;
@property (nonatomic,copy)NSString *avatar;
@property (nonatomic,copy)NSString *integral;
@property (nonatomic,copy)NSString *pwd;
@property (nonatomic,copy)NSString *accid;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *trade;

+ (BOOL)checkTelNumber:(NSString *) telNumber;
-(id)initWithDict:(NSDictionary *)dict;
+(id)userWithDict:(NSDictionary *)dict;
@end
