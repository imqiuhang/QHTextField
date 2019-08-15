//
//  QHTFTextMatchRules.h
//  ColorUtils
//
//  Created by imqiuhang on 2019/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/*!
 @enum QHTextFieldRightViewType
 @abstract 文本的匹配校验一些自带的快速类型设置
 */
typedef NS_ENUM(NSUInteger, QHTFTextMatchingType) {
    
    /// default, nothing
    QHTFTextMatchingTypeNone,
    /// number, "0-9"
    QHTFTextMatchingTypeNumber,
    /// 无限制小数, 999.999
    QHTextFieldRightViewTypeDecimals,
    /// 限制两位小数, 999.99
    QHTextFieldRightViewTypeTowFractionDigitsDecimals,
};

#pragma mark - tools
/*!
 * @brief 浮点数匹配正则
 * @example 123.99
 * @param integerLength 整数部分的最大长度 0代表不限制
 * @param decimalLength 小数部分的最大长度 0代表不限制
 * @return 浮点匹配正则
 */
extern NSString *QHTFFloatRegExCreat(NSInteger integerLength, NSInteger decimalLength);

/// @discussion 这几个方法需要暴露?
extern BOOL QHTFStringIsMatchedWithCharacterSet(NSString *string, NSCharacterSet *characterSet);
extern BOOL QHTFStringIsMatchedWithRegEx(NSString *string, NSString *regEx);

#pragma mark - QHTFTextMatchRules
@interface QHTFTextMatchRules : NSObject

/// @brief 文本的正则匹配规则 @seealso QHTextFieldFloatRegExCreat
@property (nonatomic, copy, nullable) NSString *textMatchingRegEx;
@property (nonatomic, copy, nullable) NSArray <NSString *> *textMatchingRegExs;

/*!
 * @brief 文本的字符匹配规则
 * @example
          NSMutableCharacterSet *set = [NSMutableCharacterSet decimalDigitCharacterSet];
          [set formUnionWithCharacterSet:[NSCharacterSet  characterSetWithCharactersInString:@".a"]];
 * @result
          [isMatchedStringForString]  ".a123456789" ==> true , "b123" ==> false
          [matchingStringWithString]  "asjh@#109-a3.12" ==> "a109a3.12"
 */
@property (nonatomic, strong, nullable) NSCharacterSet *textMatchingCharacterSet;

/// @brief 已有的一些简易匹配规则，会逐步增加完善
@property (nonatomic, assign) QHTFTextMatchingType textMatchingType;

/// @brief 最大输入字符数, 包含, 0表示不限制, default is 0
@property (nonatomic, assign) NSInteger inputLimit;

/// @brief 去除头尾的空白, default is NO
@property (nonatomic, assign) BOOL autoTrimWhitespace;

/// @return 根据以上各类规则聚合的 倒转的 CharacterSets
- (NSCharacterSet *)unionTextMatchingCharacterInvertedSets;

/// @return 根据以上各类规则聚合的正则
- (NSArray <NSString *>*)unionTextMatchingRegExs;

/*!
 * @brief  通过textMatchRules的所有规则获取相匹配的string
 * @discussion textField 直接 setText:不会做任何的过滤操作
 *             因此如果有需要，比如从下发的数据中取的string，可以在setText的时候做一次过滤。
 * @return 过滤后的string
 */
- (NSString *)matchingStringWithString:(NSString *)string;

/// @return 目标字符串是否匹配现有的所有过滤规则，忽略autoTrimWhitespace
- (BOOL)isMatchedForString:(NSString *)string;

+ (instancetype)emptyRules;

@end

NS_ASSUME_NONNULL_END
