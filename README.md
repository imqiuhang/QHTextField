# QHTextField
==============
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ibireme/YYText/master/LICENSE)

更加规范和方便的使用textField

Features

==============
```objc

/*!********************************************************************************
 ╭----------------╮
 | UI规范化的输入框  |             普通输入框, 文字内间距规范，定制
 ╰----------------╯
 ╭-----------------------╮
 |  ✪  UI规范化的输入框  x  |       左右icon规范话使用, 提供一些已有的右视图类型
 ╰-----------------------╯
 ╭----------------------------╮
 |  前置标题  UI规范化的输入框  x  |  左标题规范化使用
 ╰----------------------------╯
 ╭---------------------╮
 |  数据校验  999.99  ✪  |         提供正则、字符集和自定义匹配规则的快速过滤
 ╰---------------------╯

 ********************************************************************************/

```

Usage
==============

```objc

    /*! 以下大部分设置都支持xib @see IBInspectable */
    
    // appearance setting support
    [QHTextField appearance].leftViewTextColor = [UIColor purpleColor];

    QHTextField *textField = [QHTextField new];
    
    
    // ------------------- UI相关
    
    
    // 左icon显示
    textField.leftViewIcon = [UIImage imageNamed:@"icon_left_test"];

    // 左文字显示
    textField.leftViewText = @"标题显示";

    // 左自定义富文本显示";
    textField.leftViewAttText = [self customerAttributedString];
    
    // 右显示清除按钮
    textField.leftViewText = @"标题显示";
    textField.rightViewType = QHTextFieldRightViewTypeCleanButton;
    [textField setOnRightViewSelect:^(QHTextField * _Nonnull textField) {
        // rightViewSelect
    }];
    
    // 右自定义图片
    textField.leftViewIcon = [UIImage imageNamed:@"icon_left_test"];
    textField.rightViewIcon = [UIImage imageNamed:@"icon_left_test"];
    
    // 有左右view设置文字内间距50
    textField.leftViewIcon = [UIImage imageNamed:@"icon_left_test"];
    textField.rightViewIcon = [UIImage imageNamed:@"icon_left_test"];
    textField.textLeftHasViewInset = 50.f;
    textField.textRightHasViewInset = 50.f;
    
    // 无左右view设置文字内间距50
    textField.textLeftNormalInset = 50.f;
    textField.textRightNormalInset = 50.f;
    
    
    // ------------------- 匹配相关
    
    textField.textRightNormalInset = 50.f;
    
    // 设置匹配类型为 1:Number
    textField.textMatchRules.textMatchingType = QHTFTextMatchingTypeNumber;
    textField.textAlignment = NSTextAlignmentRight;
    
    // 设置匹配类型为 2:无限制小数
    textField.textMatchRules.textMatchingType = QHTextFieldRightViewTypeDecimals;
    textField.textAlignment = NSTextAlignmentRight;
    
    // 设置匹配类型为 3:最多2位小数";
    textField.textMatchRules.textMatchingType = QHTextFieldRightViewTypeTowFractionDigitsDecimals;
    textField.textAlignment = NSTextAlignmentRight;
    
    // 设置自定义正则 ^[0-9]+$ 最大输入11位
    textField.textMatchRules.textMatchingRegEx = @"^[0-9]+$";
    textField.textMatchRules.inputLimit = 11;
    
    [textField setOnReachInputLimit:^(QHTextField * _Nonnull textField) {
          // inputLimit
    }];
    
    /// 自定义CharacterSet 小写字母+ABC 和代理
    NSMutableCharacterSet *set = [NSMutableCharacterSet lowercaseLetterCharacterSet];
    [set formUnionWithCharacterSet:[NSCharacterSet  characterSetWithCharactersInString:@"ABC"]];
    textField.textMatchRules.textMatchingCharacterSet = [set copy];
    textField.delegate = self;
    
    // 实现delegate的方法不会影响QHTextField内部的实现
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    // 优先会使用外部返回的结果
    if([string isEqualToString:@"a"]) {
        [self showHUD:@"点了a，可以被输入，但先被外部过滤了"];
        return NO;
    }

    return YES;
}

```

