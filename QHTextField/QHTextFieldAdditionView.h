//
//  QHTextFieldAdditionView.h
//  QHTextField
//
//  Created by imqiuhang on 2019/7/26.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QHTextFieldAdditionLeftViewType) {
    QHTextFieldAdditionLeftViewTypeImage,
    QHTextFieldAdditionLeftViewTypeText,
};

@interface QHTextFieldAdditionLeftView : UIView

// 优先级从上到下
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSAttributedString *attText;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign, readonly) QHTextFieldAdditionLeftViewType additionViewType;

@end

@interface QHTextFieldAdditionRightView : UIView

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) CGFloat iconViewRightInset;//default is 15.f;
@property (nonatomic, copy  ) void (^onSelectCallback)(void);

@end

@interface QHSelfSizingImageView : UIImageView

@end

