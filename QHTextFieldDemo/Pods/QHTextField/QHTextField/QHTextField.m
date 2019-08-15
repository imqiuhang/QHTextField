//
//  QHTextField.m
//  QHTextField
//
//  Created by imqiuhang on 2019/7/25.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "QHTextField.h"
#import "QHTextFieldAdditionView.h"
#import <objc/runtime.h>
#import "QHTextProxy.h"
#import "QHTextDefine.h"

@interface QHTextFieldProxyDelegate : NSObject<UITextFieldDelegate>

@property (nonatomic, copy) BOOL (^shouldChangeCharactersHandler)(UITextField *textField, NSRange range, NSString *string);

@end

@interface QHTextField ()

@property (nonatomic, strong) QHTextFieldAdditionLeftView  *leftAccessoryView;
@property (nonatomic, strong) QHTextFieldAdditionRightView *rightAccessoryView;

@property (nonatomic, strong) QHTextProxy *delegateProxy;
@property (nonatomic, strong) QHTextFieldProxyDelegate *proxyDelegate;

@end

@implementation QHTextField
@synthesize textMatchRules = _textMatchRules;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

#pragma Mark - delegate pack
- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    self.delegateProxy.originalDelegate = delegate;
}

- (void)setupDelegateProxy {
    
    [super setDelegate:nil];
    
    self.proxyDelegate = ({
        
        QHTextFieldProxyDelegate *delegate = [[QHTextFieldProxyDelegate alloc] init];
        QHTextWeakify;
        [delegate setShouldChangeCharactersHandler:^BOOL(UITextField *textField, NSRange range, NSString *string) {
            QHTextStrongify;
            return [self QHTF_textField:textField shouldChangeCharactersInRange:range replacementString:string];
        }];
        delegate;
    });
    
    self.delegateProxy = ({
        
        QHTextProxy *proxy = [QHTextProxy alloc];
        proxy.originalDelegate = nil;
        proxy.proxyDelegate    = self.proxyDelegate;
        proxy;
    });
    
    [super setDelegate:(id)self.delegateProxy];
}

#pragma mark - rules handle
- (QHTFTextMatchRules *)textMatchRules {
    if (!_textMatchRules) {
        _textMatchRules = [QHTFTextMatchRules emptyRules];
    }
    return _textMatchRules;
}


#pragma mark - characters handle
- (BOOL)QHTF_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    id originalDelegate =  self.delegateProxy.originalDelegate;
    
    if ([originalDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        BOOL result =  [originalDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
        if (!result) {
            return NO;
        }
    }
    
    if (textField!=self) {
        return YES;
    }
    
    // 删除操作
    if((range.length > 0 && string.length == 0)) {
        return YES;
    }
    
    // 候选词
    if (textField.markedTextRange) {
        return YES;
    }
    
    // undo 避免bug崩溃
    if(NSMaxRange(range) > textField.text.length) {
        return NO;
    }
    
    NSString *oldString = textField.text;
    
    NSString *resultString = [oldString stringByReplacingCharactersInRange:range withString:string ?: @""];
    
    //不能直接判断 replacementString 是不是空格，因为有可能是选中用空格替换之间的某个字符
    if (self.textMatchRules.autoTrimWhitespace) {
       
        if (resultString.length >= oldString.length) {
            
            NSString *oldTrimed = [oldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *trimedString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([trimedString isEqualToString:oldTrimed]) {
                return NO;
            };
        }
    }
    
    if (self.textMatchRules.inputLimit>0&&resultString.length>self.textMatchRules.inputLimit) {
        if (self.onReachInputLimit) {
            self.onReachInputLimit(self);
        }
        return NO;
    }
    
    return [self.textMatchRules isMatchedForString:resultString];
}

#pragma mark - leftView
- (void)setLeftViewIcon:(UIImage *)leftViewIcon {
    _leftViewIcon = leftViewIcon;
    [self updateLeftView];
}

- (void)setLeftViewText:(NSString *)leftViewText {
    _leftViewText = leftViewText;
    [self updateLeftView];
}

- (void)setLeftViewAttText:(NSAttributedString *)leftViewAttText {
    _leftViewAttText = leftViewAttText;
    [self updateLeftView];
}

- (void)setLeftViewIconRightInset:(CGFloat)leftViewIconRightInset {
    _leftViewIconRightInset = leftViewIconRightInset;
    [self updateLeftView];
}

- (void)setLeftViewTextFont:(UIFont *)leftViewTextFont {
    _leftViewTextFont = leftViewTextFont;
    [self updateLeftView];
}

- (void)setLeftViewTextColor:(UIColor *)leftViewTextColor {
    _leftViewTextColor = leftViewTextColor;
    [self updateLeftView];
}

- (void)setLeftViewTextStyleWidth:(CGFloat)leftViewTextStyleWidth {
    _leftViewTextStyleWidth = leftViewTextStyleWidth;
    [self setNeedsLayout];
}

- (void)setLeftViewImageStyleWidth:(CGFloat)leftViewImageStyleWidth {
    _leftViewImageStyleWidth = leftViewImageStyleWidth;
    [self setNeedsLayout];
}

- (void)updateLeftView {
    
    if (!self.leftViewIcon&&!self.leftViewAttText&&!self.leftViewText.length) {
        self.leftAccessoryView = nil;
        if ([self.leftView isKindOfClass:QHTextFieldAdditionLeftView.class]) {
            self.leftView = nil;
        }
    }else {
        
        if (!self.leftAccessoryView) {
            self.leftAccessoryView = [QHTextFieldAdditionLeftView new];
        }
        
        self.leftAccessoryView.icon      = self.leftViewIcon;
        self.leftAccessoryView.text      = self.leftViewText;
        self.leftAccessoryView.attText   = self.leftViewAttText;
        self.leftAccessoryView.textFont  = self.leftViewTextFont;
        self.leftAccessoryView.textColor = self.leftViewTextColor;
        
        self.leftView = self.leftAccessoryView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    
    [self setNeedsLayout];
}

#pragma mark - rightView
- (void)setRightViewIcon:(UIImage *)rightViewIcon {
   
    _rightViewType = QHTextFieldRightViewTypeNone;
    _rightViewIcon = rightViewIcon;
    [self updateRightView];
}

- (void)setRightViewWidth:(CGFloat)rightViewWidth {
    _rightViewWidth = rightViewWidth;
    [self setNeedsLayout];
}

- (void)setRightViewIconRightInset:(CGFloat)rightViewIconRightInset {
    _rightViewIconRightInset = rightViewIconRightInset;
    [self updateRightView];
}

- (void)setRightViewType:(QHTextFieldRightViewType)rightViewType {
    
    switch (rightViewType) {
        case QHTextFieldRightViewTypeWarning: {
            self.rightViewIcon = QHTextImageNamed(@"icon_right_warning");
            self.rightViewMode = UITextFieldViewModeAlways;
            break;
        }
        case QHTextFieldRightViewTypeCleanButton: {
            self.rightViewIcon = QHTextImageNamed(@"icon_right_cleanBtn");
            self.rightViewMode = UITextFieldViewModeWhileEditing;
            break;
        }
        case QHTextFieldRightViewTypeNone: {
            self.rightAccessoryView = nil;
            break;
        }
    }
    
    _rightViewType = rightViewType;
}

- (void)updateRightView {
    
    if (!self.rightViewIcon) {
        
        self.rightAccessoryView = nil;
        if ([self.rightView isKindOfClass:QHTextFieldAdditionRightView.class]) {
            self.rightView = nil;
        }
        
    }else {
        
        if (!self.rightAccessoryView) {
            self.rightAccessoryView = [QHTextFieldAdditionRightView new];
            QHTextWeakify;
            [self.rightAccessoryView setOnSelectCallback:^{
                QHTextStrongify;
                if (self.onRightViewSelect) {
                    self.onRightViewSelect(self);
                }
                
                if (self.rightViewType==QHTextFieldRightViewTypeCleanButton) {
                    self.text = nil;
                }
            }];
        }
        
        self.rightAccessoryView.icon = self.rightViewIcon;
        self.rightAccessoryView.iconViewRightInset = self.rightViewIconRightInset;
        
        self.rightView = self.rightAccessoryView;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    
    [self setNeedsLayout];
}

#pragma mark - inset
- (void)setTextLeftNormalInset:(CGFloat)textLeftNormalInset {
    _textLeftNormalInset = textLeftNormalInset;
    [self setNeedsLayout];
}

- (void)setTextLeftHasViewInset:(CGFloat)textLeftHasViewInset {
    _textLeftHasViewInset = textLeftHasViewInset;
    [self setNeedsLayout];
}

- (void)setTextRightNormalInset:(CGFloat)textRightNormalInset {
    _textRightNormalInset = textRightNormalInset;
    [self setNeedsLayout];
}

- (void)setTextRightHasViewInset:(CGFloat)textRightHasViewInset {
    _textRightHasViewInset = textRightHasViewInset;
    [self setNeedsLayout];
}

#pragma mark - private setter
- (void)setLeftView:(UIView *)leftView {
    
    if (![leftView isKindOfClass:QHTextFieldAdditionLeftView.class]) {
        self.leftAccessoryView = nil;
    }
    [super setLeftView:leftView];
}

- (void)setRightView:(UIView *)rightView {
    
    if (![rightView isKindOfClass:QHTextFieldAdditionRightView.class]) {
        self.rightAccessoryView = nil;
    }
    [super setRightView:rightView];
}

#pragma mark - inserts config
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super leftViewRectForBounds:bounds];
    if (!self.leftAccessoryView) {
        return rect;
    }
    
    return CGRectMake(0, 0, self.leftAccessoryView.additionViewType==QHTextFieldAdditionLeftViewTypeText?self.leftViewTextStyleWidth:self.leftViewImageStyleWidth, CGRectGetHeight(bounds));
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super leftViewRectForBounds:bounds];
    if (!self.rightAccessoryView) {
        return rect;
    }
    return CGRectMake(CGRectGetMaxX(bounds) - self.rightViewWidth, 0, self.rightViewWidth, CGRectGetHeight(bounds));
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    //这里是否需要判断是不是自定义的view?
    
    CGFloat leftInset  = self.leftView?self.textLeftHasViewInset:self.textLeftNormalInset;
    CGFloat rightInset = self.rightView?self.textRightHasViewInset:self.textRightNormalInset;
    
    CGRect rect = [super editingRectForBounds:bounds];
    return CGRectMake(CGRectGetMinX(rect)+ leftInset, CGRectGetMinY(rect), CGRectGetWidth(rect) - leftInset - rightInset, CGRectGetHeight(rect));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

#pragma mark - setup
- (void)setup {
    
    [self setupDelegateProxy];
    
    _textLeftNormalInset   = 9.f;
    _textLeftHasViewInset  = 0.f;
    _textRightNormalInset  = 9.f;
    _textRightHasViewInset = 0.f;

    _leftViewAttText = nil;
    
    _leftViewTextStyleWidth   = 86.f;
    _leftViewImageStyleWidth  = 54.f;
    _rightViewWidth           = 36.f;
    _rightViewIconRightInset  = 15.f;
    _leftViewTextFont         = [UIFont systemFontOfSize:14];
    _leftViewTextColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.f];
}

#pragma mark - IBInspectable
- (void)setTextMatchingRegEx:(NSString *)textMatchingRegEx {
    self.textMatchRules.textMatchingRegEx = textMatchingRegEx;
}

- (void)setTextMatchingType:(NSInteger)textMatchingType {
    self.textMatchRules.textMatchingType = textMatchingType;
}

- (void)setInputLimit:(NSInteger)inputLimit {
    self.textMatchRules.inputLimit = inputLimit;
}

- (void)setAutoTrimWhitespace:(BOOL)autoTrimWhitespace {
    self.textMatchRules.autoTrimWhitespace = autoTrimWhitespace;
}

@end

@implementation QHTextFieldProxyDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.shouldChangeCharactersHandler) {
        return self.shouldChangeCharactersHandler(textField, range, string);
    }
    return YES;
}

@end

