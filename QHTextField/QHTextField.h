//
//  QHTextField.h
//  QHTextField
//
//  Created by imqiuhang on 2019/7/25.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHTFTextMatchRules.h"

/*!********************************************************************************
 ╭----------------╮
 | UI规范化的输入框  |             普通输入框, 间距规范
 ╰----------------╯
 ╭-----------------------╮
 |  ✪  UI规范化的输入框  x |       左右icon规范, 提供一些已有的右视图类型
 ╰-----------------------╯
 ╭----------------------------╮
 |  前置标题  UI规范化的输入框  x |  左标题规范
 ╰----------------------------╯
 ╭---------------------╮
 |  数据校验  999.99  ✪ |         提供正则、字符集和自定义匹配规则的快速过滤
 ╰---------------------╯
 * @brief http://axure.yixin.im/viewvision?id=1908&pid=80&mid=183 数据录入-文本框
 ********************************************************************************/


NS_ASSUME_NONNULL_BEGIN

/*!
 @enum QHTextFieldRightViewType
 @abstract rightView的一些已有类型快速使用
 */
typedef NS_ENUM(NSUInteger, QHTextFieldRightViewType) {
    
    /// 即清空rightView
    QHTextFieldRightViewTypeNone,
    /// 清除按钮, 将会自动设置 viewMode : UITextFieldViewModeWhileEditing
    QHTextFieldRightViewTypeCleanButton,
    /// 红色警告 将会自动设置 viewMode : UITextFieldViewModeAlways, auto clean text when select
    QHTextFieldRightViewTypeWarning,
};


/*! IB_DESIGNABLE */  //开启黑屏且太卡
@interface QHTextField : UITextField

#pragma mark - addition views

/// @brief 左icon, self-sizing, 27*27@2x最佳, 将会设置viewMode ==> UITextFieldViewModeAlways
@property (nonatomic, strong, nullable) IBInspectable UIImage  *leftViewIcon;

/// @brief 左标题, <=4个字最佳, 将会自动设置viewMode ==> UITextFieldViewModeAlways
@property (nonatomic, copy, nullable  ) IBInspectable NSString *leftViewText;

/// @brief leftView标题的富文本 default is nil
@property (nonatomic, strong, nullable) NSAttributedString *leftViewAttText;

/// @brief 右icon, self-sizing, 18*18最佳, 将会自动设置viewMode ==> UITextFieldViewModeAlways
@property (nonatomic, strong, nullable) IBInspectable UIImage  *rightViewIcon;

/// @brief 设置rightView为已提供的类型, 会覆盖已设置的rightViewIcon
#if !TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) QHTextFieldRightViewType rightViewType;
#else
@property (nonatomic, assign) IBInspectable NSInteger   rightViewType;
#endif


#pragma mark - text matching rules

/*!
 * @brief shouldChangeCharactersInRange的text匹配规则集合
 * @discussion
     如果外部自己也设置了delegate且实现了'shouldChangeCharactersInRange,对内部的实现没有影响，内部会先 ‘转发’【Change方法】给外部实现,@see QHTextProxy
     [优先]取外部return的结果, 如果返回YES则继续textMatchRules的过滤，返回NO则结束并也返回NO过滤目标string。
 * @return nonnull, always return value
 */
@property (nonatomic, strong, readonly, nonnull) QHTFTextMatchRules *textMatchRules;

#if TARGET_INTERFACE_BUILDER
/// ... 都将设置textMatchRules对应的值
@property (nonatomic, copy  ) IBInspectable NSString  *textMatchingRegEx;
@property (nonatomic, assign) IBInspectable NSInteger textMatchingType;
@property (nonatomic, assign) IBInspectable NSInteger inputLimit;
@property (nonatomic, assign) IBInspectable BOOL      autoTrimWhitespace;
#endif

#pragma mark - callbacks
/// @brief rightView select callback
@property (nonatomic, copy, nullable) void (^onRightViewSelect)(QHTextField *textField);

/// @brief reach input limit callback
@property (nonatomic, copy, nullable) void (^onReachInputLimit)(QHTextField *textField);


#pragma mark - left/right view configs

/// @brief 有/无 leftView/rightView（包括自己设置的left right view） 状态下的文本左右内间距
@property (nonatomic, assign) IBInspectable CGFloat textLeftNormalInset UI_APPEARANCE_SELECTOR; //default  9
@property (nonatomic, assign) IBInspectable CGFloat textLeftHasViewInset UI_APPEARANCE_SELECTOR;//default  0
@property (nonatomic, assign) IBInspectable CGFloat textRightNormalInset UI_APPEARANCE_SELECTOR;//default  9
@property (nonatomic, assign) IBInspectable CGFloat textRightHasViewInset UI_APPEARANCE_SELECTOR;//default 0

//leftView/rightView 的一些内部config
@property (nonatomic, assign) IBInspectable CGFloat leftViewTextStyleWidth UI_APPEARANCE_SELECTOR; //86
@property (nonatomic, assign) IBInspectable CGFloat leftViewImageStyleWidth UI_APPEARANCE_SELECTOR;//69
@property (nonatomic, assign) IBInspectable CGFloat leftViewIconRightInset UI_APPEARANCE_SELECTOR; //15
@property (nonatomic, assign) IBInspectable CGFloat rightViewWidth UI_APPEARANCE_SELECTOR;         //36
@property (nonatomic, assign) IBInspectable CGFloat rightViewIconRightInset UI_APPEARANCE_SELECTOR;//15

@property (nonatomic, strong) IBInspectable UIFont *leftViewTextFont UI_APPEARANCE_SELECTOR;//system 14
@property (nonatomic, strong) IBInspectable UIColor *leftViewTextColor UI_APPEARANCE_SELECTOR;//333333

@end


NS_ASSUME_NONNULL_END

