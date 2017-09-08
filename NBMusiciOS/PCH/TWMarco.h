//
//  TWMarco.h
//  NBMusiciOS
//
//  Created by 文涛 on 2017/9/9.
//  Copyright © 2017年 Ymmmsick. All rights reserved.
//

#ifndef TWMarco_h
#define TWMarco_h

#define kAccessTokenModel @"kAccessTokenModel"
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define ScreenWidth  ([[UIScreen mainScreen] bounds].size.width)

#define WEAKSELF __weak typeof(&*self) weakSelf = self;

#define height(height) ((ScreenHeight /667) * height)

#define widht(width) ((ScreenWidth /375) * width)

#define  RGBColor(x,y,z)  [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

#define   FONT(size)  ([UIFont systemFontOfSize:size])
#define UIColor_HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]


#define kHeight ScreenHeight - 64 - 50

//Debug下输出打印信息，Release下不输出打印信息
#ifdef DEBUG
#define HWLog(...) NSLog(__VA_ARGS__)
#else
#define HWLog(...)
#endif



#endif /* TWMarco_h */
