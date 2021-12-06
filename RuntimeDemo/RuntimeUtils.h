//
//  RuntimeUtils.h
//  RuntimeDemo
//
//  Created by wxd on 2021/12/6.
//

#import <Foundation/Foundation.h>

void exchangeMethod(Class aClass, SEL oldSEL, SEL newSEL);
void replaceImplementation(Class newClass, Class hookedClass, SEL sel, IMP* oldImp);
NS_ASSUME_NONNULL_BEGIN

@interface RuntimeUtils : NSObject

@end

NS_ASSUME_NONNULL_END
