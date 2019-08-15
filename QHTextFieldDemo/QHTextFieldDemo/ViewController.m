//
//  ViewController.m
//  QHTextFieldDemo
//
//  Created by imqiuhang on 2019/8/15.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "ViewController.h"
#import <QHTextField/QHTextField.h>
#import <QHTextField/QHTextDefine.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <PureLayout/PureLayout.h>


@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

#pragma mark - setup
- (void)setup {
    
    /*! 以下大部分设置都支持xib @see IBInspectable */
    
    [QHTextField appearance].leftViewTextColor = [UIColor purpleColor];
    
    [self creatTextFields:^(QHTextField *view) {
        view.placeholder = @"左icon显示";
        view.leftViewIcon = [UIImage imageNamed:@"icon_left_test"];
    }];
    
    [self creatTextFields:^(QHTextField *view) {
        view.placeholder = @"左文字显示";
        view.leftViewText = @"标题显示";
    }];
    
    [self creatTextFields:^(QHTextField *view) {
        view.placeholder = @"左自定义富文本显示";
        view.leftViewAttText = [self customerAttributedString];
    }];
    
    [self creatTextFields:^(QHTextField *view) {
        view.placeholder = @"右显示清除按钮";
        view.leftViewText = @"标题显示";
        view.rightViewType = QHTextFieldRightViewTypeCleanButton;
        QHTextWeakify
        [view setOnRightViewSelect:^(QHTextField * _Nonnull textField) {
            QHTextStrongify
            [self showHUD:[NSString stringWithFormat:@"right view select,type: :%lu",(unsigned long)textField.rightViewType]];
        }];
    }];
    
    [self creatTextFields:^(QHTextField *view) {
        view.placeholder = @"右自定义图片";
        view.leftViewIcon = [UIImage imageNamed:@"icon_left_test"];
        view.rightViewIcon = [UIImage imageNamed:@"icon_left_test"];
    }];
    
    [self creatTextFields:^(QHTextField *view) {
        view.placeholder = @"有左右view设置文字内间距50";
        view.leftViewIcon = [UIImage imageNamed:@"icon_left_test"];
        view.rightViewIcon = [UIImage imageNamed:@"icon_left_test"];
        view.textLeftHasViewInset = 50.f;
        view.textRightHasViewInset = 50.f;
    }];
    
    [self creatTextFields:^(QHTextField *view) {
        view.placeholder = @"无左右view设置文字内间距50";
        view.textLeftNormalInset = 50.f;
        view.textRightNormalInset = 50.f;
    }];
    
    __divisionFlag = YES;
    
    [self creatTextFields:^(QHTextField *view) {
        view.placeholder = @"设置匹配类型为 1:Number";
        view.textMatchRules.textMatchingType = QHTFTextMatchingTypeNumber;
        view.textAlignment = NSTextAlignmentRight;
    }];
    
    [self creatTextFields:^(QHTextField *view) {
        view.placeholder = @"设置匹配类型为 2:无限制小数";
        view.textMatchRules.textMatchingType = QHTextFieldRightViewTypeDecimals;
        view.textAlignment = NSTextAlignmentRight;
    }];
    
    [self creatTextFields:^(QHTextField *view) {
        view.placeholder = @"设置匹配类型为 3:最多2位小数";
        view.textMatchRules.textMatchingType = QHTextFieldRightViewTypeTowFractionDigitsDecimals;
        view.textAlignment = NSTextAlignmentRight;
    }];
    
    [self creatTextFields:^(QHTextField *view) {
        view.placeholder = @"设置自定义正则 ^[0-9]+$ 最大输入11位";
        view.textMatchRules.textMatchingRegEx = @"^[0-9]+$";
        view.textMatchRules.inputLimit = 11;
        QHTextWeakify;
        [view setOnReachInputLimit:^(QHTextField * _Nonnull textField) {
            QHTextStrongify;
            [self showHUD:[NSString stringWithFormat:@"reach input limit :%li",(long)textField.textMatchRules.inputLimit]];
        }];
    }];
    
    [self creatTextFields:^(QHTextField *view) {
        view.tag = 100;
        view.placeholder = @"自定义CharacterSet 小写字母+ABC 和代理";
        NSMutableCharacterSet *set = [NSMutableCharacterSet lowercaseLetterCharacterSet];
        [set formUnionWithCharacterSet:[NSCharacterSet  characterSetWithCharactersInString:@"ABC"]];
        view.textMatchRules.textMatchingCharacterSet = [set copy];
    }];
    
}

__weak static UIView *__lastView;
static BOOL  __divisionFlag;

- (void)creatTextFields:(void (^)(QHTextField *view))config {
    
    QHTextField *textField = ({
        
        QHTextField *view = [QHTextField newAutoLayoutView];
        [self.view addSubview:view];
        [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        if (__lastView) {
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:__lastView withOffset:15.f];
        }else {
            [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100.f];
        }

        [view autoSetDimension:ALDimensionHeight toSize:30.f];
        view.backgroundColor = __divisionFlag? [UIColor greenColor]:[UIColor yellowColor];
        view.delegate = self;
        
        QHTextWeakify
        [view setOnRightViewSelect:^(QHTextField * _Nonnull textField) {
            QHTextStrongify
            [self showHUD:[NSString stringWithFormat:@"right view select,type: :%lu",(unsigned long)textField.rightViewType]];
        }];
        
        view;
    });
    
    __lastView = textField;
    if (config) {
        config(textField);
    }
}

#pragma mark UITextField delegate
// 实现delegate的方法不会影响QHTextField内部的实现
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag==100) {
        
        if ([string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length==0) {
            [self showHUD:[NSString stringWithFormat:@"输入了数字%@",string]];
        }
        
        if([string isEqualToString:@"a"]) {
            
            [self showHUD:@"点了a，可以被输入，但先被外部过滤了"];
            return NO;
        }
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self showHUD:@"return key select"];
    return YES;
}


#pragma Mark- private
- (void)showHUD:(NSString *)string {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = string;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:2];
}


- (NSAttributedString *)customerAttributedString {
    
    NSMutableAttributedString *attributedString = ({
        
        NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] initWithString:@"自定" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]}];
        [ret addAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(1, 1)];
        
        NSTextAttachment *attch = ({
            
            NSTextAttachment *ret = [[NSTextAttachment alloc] init];
            ret.image = [UIImage imageNamed:@"icon_left_test"];
            ret.bounds = CGRectMake(0, -6, 25, 25);
            ret;
        });
        [ret appendAttributedString:[NSAttributedString attributedStringWithAttachment:attch]];
        ret;
    });
    
    return attributedString;
}

@end
