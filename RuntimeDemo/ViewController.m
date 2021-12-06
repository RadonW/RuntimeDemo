//
//  ViewController.m
//  RuntimeDemo
//
//  Created by wxd on 2021/12/6.
//

#import "ViewController.h"
#import "RuntimeUtils.h"
#import <objc/runtime.h>
// 返回对象指针的函数指针
typedef id(*_IMP)(id,SEL,NSUInteger);
// 返回void的函数指针（不可用于指向返回对象指针的方法实现）
typedef void (*_VIMP)(id,SEL,BOOL);
static _IMP oldSubstringFromIndex = NULL;


@interface ViewController ()

@end

@implementation ViewController (methodSwizzling)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"

// 通过exchangeMethod来交换类的两个方法，适用于未对外暴露的类（无法通过写该类的Category来增加方法）。
+ (void)load
{
    BOOL isAddSuccess = class_addMethod(objc_getClass("NSString"), @selector(newSubstringFromIndex:), class_getMethodImplementation([self class], @selector(newSubstringFromIndex:)), "@@:L");
    if (isAddSuccess) {
        exchangeMethod(objc_getClass("NSString"),@selector(substringFromIndex:),@selector(newSubstringFromIndex:));
    }
}
- (NSString *)newSubstringFromIndex:(NSUInteger)index{
    NSLog(@"%@ newSubstringFromIndex",[self class] );

    NSString *returnValue = [self newSubstringFromIndex:index];
    NSLog(@"newSubstringFromIndex: %@",returnValue);
    return returnValue;
}


// 另一种方法：通过method_setImplementation实现修改原方法。不需要给原有类添加新的方法，直接替换实现，适用于未对外暴露的类。
//+ (void)load {
//    Class hookedClass = objc_getClass("NSString");
//    SEL sel = @selector(substringFromIndex:);
//    replaceImplementation([self class], hookedClass, sel, &oldSubstringFromIndex);
//}
//- (NSString *)substringFromIndex:(NSUInteger)index{
//    NSLog(@"%@ substringFromIndex after modify",[self class] );
//
//    NSString *returnValue = oldSubstringFromIndex(self,@selector(substringFromIndex:),index);
//    NSLog(@"newSubstringFromIndex: %@",returnValue);
//    return returnValue;
//}


//还有一种通过block来直接指定方法的具体实现（IMP）的实现方式，也很适合未对外暴露的类。类似还有一种不使用block直接定义一个方法实现（C风格）的方式。
//_IMP substringFromIndex_IMP;
//_VIMP viewDidAppear_VIMP;
//id (*originSubstringToIndex_IMP) (id self, SEL _cmd, NSUInteger index);
//+ (void)load
//{
//    // 返回值为void型的方法替换
//    Method viewDidAppearMethod = class_getInstanceMethod(objc_getClass("UIViewController"), @selector(viewDidAppear:));
//    //经测试，viewDidLoad_VIMP用_IMP或者_VIMP均可。
//    viewDidAppear_VIMP = method_getImplementation(viewDidAppearMethod);
//    // 此处需注意，直接定义函数实现时，需要带隐藏参数，block的方式只能带一个id隐藏参数，不能带SEL隐藏参数
//    method_setImplementation(viewDidAppearMethod, imp_implementationWithBlock(^(id target, BOOL animated){
//        viewDidAppear_VIMP(target,@selector(viewDidLoad),animated);
//        NSLog(@"%@ did Appear",[target class] );
//    }));
//
//
//    // 返回值为String型的方法替换
//        Method substringFromIndexMethod = class_getInstanceMethod(objc_getClass("NSString"), @selector(substringFromIndex:));
//
//        substringFromIndex_IMP = method_getImplementation(substringFromIndexMethod);
//        method_setImplementation(substringFromIndexMethod, imp_implementationWithBlock(^(id target, int index){
//            NSLog(@"FromIndex:source NSString is %@",target);
//            return substringFromIndex_IMP(target,@selector(substringFromIndex:),index);
//        }));
//
//    // 另一种替换方法的形式，不使用block，使用函数名
//    Method substringToIndexMethod = class_getInstanceMethod(objc_getClass("NSString"), @selector(substringToIndex:));
//    if (substringToIndexMethod) {
//        originSubstringToIndex_IMP = method_getImplementation(substringToIndexMethod);
//        method_setImplementation(substringToIndexMethod, newSubstringToIndex);
//    }
//    else {
//        NSLog(@"selector substringToIndex: not found");
//    }
//}
//
////直接定义一个方法实现，C风格，需要带隐藏的两个参数。
//id newSubstringToIndex(id self, SEL _cmd, NSUInteger index)
//{
//    NSLog(@"ToIndex:source NSString is %@",self);
//    return originSubstringToIndex_IMP(self, _cmd, index);
//}



#pragma clang diagnostic pop
@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *oldString = @"radon";
    NSString * string = [NSString stringWithString:oldString];
    NSLog(@"radon String is %@",string);
    string = [oldString substringFromIndex:2];
    NSLog(@"radon String is %@",string);
    string = [oldString substringToIndex:3];
    NSLog(@"radon String is %@",string);
    string = [oldString substringWithRange:NSMakeRange(0, 4)];
    NSLog(@"radon String is %@",string);
}


@end
