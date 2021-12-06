//
//  RuntimeUtils.m
//  RuntimeDemo
//
//  Created by wxd on 2021/12/6.
//

#import "RuntimeUtils.h"
#import <objc/runtime.h>
void exchangeMethod(Class aClass, SEL oldSEL, SEL newSEL)
{
    Method oldMethod = class_getInstanceMethod(aClass, oldSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(aClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}

// 该函数的设计也可改为支持不同名的方法替换，多传一个newSel即可。
void replaceImplementation(Class newClass, Class hookedClass, SEL sel, IMP* oldImp)
{
    Method old = class_getInstanceMethod(hookedClass, sel);
    IMP newImp = class_getMethodImplementation(newClass, sel);
    *oldImp = method_setImplementation(old, newImp);
}

@implementation RuntimeUtils

@end
