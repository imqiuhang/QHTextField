//
//  QHTextDefine.h
//  Pods
//
//  Created by imqiuhang on 2019/7/30.
//

#ifndef QHTextDefine_h
#define QHTextDefine_h


#define QHTextWeakify   __weak   __typeof__(self) __weakSelf = self;
#define QHTextStrongify __strong __typeof__(self) self       = __weakSelf;

NS_INLINE UIImage* QHTextImageNamed(NSString *name) {
    
    NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"QHTextFieldResources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

#endif /* QHTextDefine_h */
