//
//  QHTextProxy.h
//  ColorUtils
//
//  Created by imqiuhang on 2019/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHTextProxy : NSProxy

@property (nonatomic, weak) id originalDelegate;
@property (nonatomic, weak) id proxyDelegate;

@end

NS_ASSUME_NONNULL_END
