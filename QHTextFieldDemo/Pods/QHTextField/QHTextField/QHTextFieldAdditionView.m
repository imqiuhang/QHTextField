//
//  QHTextFieldAdditionView.m
//  QHTextField
//
//  Created by imqiuhang on 2019/7/26.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "QHTextFieldAdditionView.h"
#import "PureLayout.h"

@interface QHTextFieldAdditionLeftView ()

@property (nonatomic, strong) QHSelfSizingImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation QHTextFieldAdditionLeftView

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

- (void)setup {
    
    self.textLabel = ({
       
        UILabel *view = [UILabel newAutoLayoutView];
        [self addSubview:view];
        [view autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = [UIColor blackColor];
        view;
    });
    
    self.imageView = ({
       
        QHSelfSizingImageView *view = [QHSelfSizingImageView newAutoLayoutView];
        [self addSubview:view];
        [view autoCenterInSuperview];
        view;
    });
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    [self reloadView];
}

- (void)setText:(NSString *)text {
    _text = text;
    [self reloadView];
}

- (void)setAttText:(NSAttributedString *)attText {
    _attText = attText;
    [self reloadView];
}

- (void)setTextColor:(UIColor *)textColor {
    self.textLabel.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont {
    self.textLabel.font = textFont;
}

- (void)reloadView {
    
    if (self.icon) {
        _additionViewType = QHTextFieldAdditionLeftViewTypeImage;
        self.textLabel.hidden = YES;
        self.imageView.hidden = NO;
        self.imageView.image = self.icon;
        
    }else {
        _additionViewType = QHTextFieldAdditionLeftViewTypeText;
        self.imageView.hidden = YES;
        self.textLabel.hidden = NO;
        if (self.attText) {
            self.textLabel.text = nil;
            self.textLabel.attributedText = self.attText;
        }else {
            self.textLabel.attributedText = nil;
            self.textLabel.text = self.text;
        }
    }
}

@end


@interface QHTextFieldAdditionRightView ()

@property (nonatomic, strong) QHSelfSizingImageView *imageView;
@property (nonatomic, strong) NSLayoutConstraint *imageViewRightLayout;

@end

@implementation QHTextFieldAdditionRightView

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

- (void)setup {
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self addGestureRecognizer:tapG];
    
    
    self.imageView = ({
        
        QHSelfSizingImageView *view = [QHSelfSizingImageView newAutoLayoutView];
        [self addSubview:view];
        [view autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        self.imageViewRightLayout = [view autoPinEdgeToSuperviewEdge:ALEdgeRight];
        view;
    });
}

#pragma mark - setter
- (void)setIconViewRightInset:(CGFloat)iconViewRightInset {
    self.imageViewRightLayout.constant = -iconViewRightInset;
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    [self reloadView];
}

- (void)reloadView {
    self.imageView.image = self.icon;
}

- (void)onTap {
    if (self.onSelectCallback) {
        self.onSelectCallback();
    }
}


@end



@implementation QHSelfSizingImageView

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    if (!self.image || ![self.image isKindOfClass:UIImage.class]) {
        return [super intrinsicContentSize];
    }
    return self.image.size;
}

@end
