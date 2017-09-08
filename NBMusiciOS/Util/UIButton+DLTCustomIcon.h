//
//  UIButton+DLTCustomIcon.h
//  ElectricityThrough
//
//  Created by 文涛 on 2017/8/30.
//  Copyright © 2017年 文涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DLTCustomIcon)
/** 图片在左，标题在右 */
- (void)setIconInLeft;
/** 图片在右，标题在左 */
- (void)setIconInRight;
/** 图片在上，标题在下 */
- (void)setIconInTop;
/** 图片在下，标题在上 */
- (void)setIconInBottom;

//** 可以自定义图片和标题间的间隔 */
- (void)setIconInLeftWithSpacing:(CGFloat)Spacing;
- (void)setIconInRightWithSpacing:(CGFloat)Spacing;
- (void)setIconInTopWithSpacing:(CGFloat)Spacing;
- (void)setIconInBottomWithSpacing:(CGFloat)Spacing;
@end
