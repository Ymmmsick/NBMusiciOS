//
//  YZ_TextField.h
//  ElectricityThrough
//
//  Created by 文涛 on 2017/9/7.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YZTapAcitonBlock)();
typedef void(^YZEndEditBlock)(NSString *text);

@interface YZ_TextField : UITextField
/** textField 的点击回调 */
@property (nonatomic, copy) YZTapAcitonBlock tapAcitonBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) YZEndEditBlock endEditBlock;

@end
