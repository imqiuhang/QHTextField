//
//  QHTFTextMatchRules.m
//  ColorUtils
//
//  Created by imqiuhang on 2019/8/8.
//

#import "QHTFTextMatchRules.h"

#pragma mark - tools

NSString *QHTextFieldFloatRegExCreat(NSInteger integerLength, NSInteger decimalLength) {
    
    const NSInteger maxLength = 128;
    
    if (integerLength==0) {
        integerLength = maxLength;
    }
    
    if (decimalLength==0) {
        decimalLength = maxLength;
    }
    
    integerLength = MIN(maxLength, MAX(0, integerLength));
    decimalLength = MIN(maxLength, MAX(0, decimalLength));
    
    return  [NSString stringWithFormat:@"^\\d{0,%ld}$|^(\\d{0,%ld}[.][0-9]{0,%ld})$", (long)integerLength, (long)integerLength, (long)decimalLength];
}

NS_INLINE NSString *_U32SubstringFromRange(NSString* string, NSRange range) {
    
    __block NSValue *resultRange = nil;
    
    [string enumerateSubstringsInRange:[string rangeOfComposedCharacterSequencesForRange:range] options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (!NSLocationInRange(substringRange.location, range)) {
            return;
        }
        if (!NSLocationInRange(NSMaxRange(substringRange)-1, range)) {
            *stop = YES;
            return;
        }
        if (!resultRange) {
            resultRange = [NSValue valueWithRange:substringRange];
        }
        else {
            resultRange = [NSValue valueWithRange:NSUnionRange(resultRange.rangeValue, substringRange)];
        }
    }];
    return [string substringWithRange:resultRange.rangeValue];
}

extern BOOL QHTFStringIsMatchedWithCharacterSet(NSString *string, NSCharacterSet *characterSet) {
    
    NSCParameterAssert(characterSet);
    
    if (!characterSet) {
        return YES;
    }
    
    if (!string.length) {
        return NO;
    }
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

extern BOOL QHTFMatchingStringWithRegEx(NSString *string, NSString *regEx) {
    
    if (!string.length||!regEx.length) {
        return NO;
    }
    NSPredicate *matchValue = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [matchValue evaluateWithObject:string];
}

#pragma mark - QHTextFieldTextMatchRules

@implementation QHTFTextMatchRules

+ (instancetype)emptyRules {
    return [self new];
}

#pragma mark - public getter

- (NSCharacterSet *)unionTextMatchingCharacterInvertedSets {
    
    NSMutableArray <NSCharacterSet *> *sets = [NSMutableArray arrayWithCapacity:2];
    
    if (self.textMatchingType==QHTFTextMatchingTypeNumber) {
        [sets addObject:[NSCharacterSet decimalDigitCharacterSet]];
    }
    
    if (self.textMatchingCharacterSet) {
        [sets addObject:self.textMatchingCharacterSet];
    }
    
    if (sets.count) {
        
        NSMutableCharacterSet *tmpSet = nil;
        
        for(NSCharacterSet *set in sets) {
            if (!tmpSet) {
                tmpSet = [set mutableCopy];
            }else {
                [tmpSet formUnionWithCharacterSet:set];
            }
        }
        return [tmpSet invertedSet];
        
    }else {
        return nil;
    }
}

- (NSArray<NSString *> *)unionTextMatchingRegExs {
    
    NSMutableArray *tmpRegExs = [NSMutableArray arrayWithArray:self.textMatchingRegExs];
    
    if (self.textMatchingRegEx.length) {
        [tmpRegExs addObject:self.textMatchingRegEx];
    }
    
    if (self.textMatchingType==QHTextFieldRightViewTypeTowFractionDigitsDecimals) {
        [tmpRegExs addObject:QHTextFieldFloatRegExCreat(0, 2)];
    }else if (self.textMatchingType==QHTextFieldRightViewTypeDecimals) {
        [tmpRegExs addObject:QHTextFieldFloatRegExCreat(0, 0)];
    }
    
    return [tmpRegExs copy];
}

#pragma mark -  rules handle
- (BOOL)isMatchedForString:(NSString *)string {
    
    NSArray <NSString *> *regExs = [self unionTextMatchingRegExs];
    
    for (NSString *regEx in regExs) {
        if (!QHTFMatchingStringWithRegEx(string, regEx)) {
            return NO;
        }
    }
    
    NSCharacterSet *characterSet = [self unionTextMatchingCharacterInvertedSets];
    
    if (characterSet) {
        if (!QHTFStringIsMatchedWithCharacterSet(string, characterSet)) {
            return NO;
        }
    }
    
    if (self.inputLimit>0&&string.length>self.inputLimit) {
        return NO;
    }
    
    return YES;
}

- (NSString *)matchingStringWithString:(NSString *)string {
    
    
    if (!string.length) {
        return string;
    }
    
    // 空白
    if (self.autoTrimWhitespace) {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    //正则
    NSArray <NSString *> *regExs = [self unionTextMatchingRegExs];
    for (NSString *regEx in regExs) {
        if (string.length<=0) {
            break;
        }
        string = [string stringByReplacingOccurrencesOfString:regEx withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
    }
    
    //字符集
    NSCharacterSet *characterSet = [self unionTextMatchingCharacterInvertedSets];
    if (string.length&&characterSet) {
        string = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    }
    
    //inputLimit
    if (self.inputLimit>0&&
        string.length>self.inputLimit) {
        string = _U32SubstringFromRange(string, NSMakeRange(0, self.inputLimit));
    }
    
    return string;
}

@end

