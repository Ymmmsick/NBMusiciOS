//
//  YZ_ClearCache.h
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/8.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZ_ClearCache : NSObject
+(float)fileSizeAtPath:(NSString *)path;
+(float)folderSizeAtPath:(NSString *)path;
+(void)clearCache:(NSString *)path;
@end
