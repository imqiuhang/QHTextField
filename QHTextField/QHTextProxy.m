//
//  QHTextProxy.m
//  ColorUtils
//
//  Created by imqiuhang on 2019/7/30.
//

#import "QHTextProxy.h"

@implementation QHTextProxy


- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    
    return [self.originalDelegate conformsToProtocol:aProtocol] || [self.proxyDelegate conformsToProtocol:aProtocol];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    return [self.originalDelegate respondsToSelector:aSelector] || [self.proxyDelegate respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    
    id methodSignature = [self.originalDelegate methodSignatureForSelector:sel];
    
    if (!methodSignature) {
        methodSignature = [self.proxyDelegate methodSignatureForSelector:sel];
    }
    
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    if ([self.proxyDelegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.proxyDelegate];
    } else if ([self.originalDelegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.originalDelegate];
    }
}

@end
