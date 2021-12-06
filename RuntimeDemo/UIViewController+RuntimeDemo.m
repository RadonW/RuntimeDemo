//
//  UIViewController+RuntimeDemo.m
//  RuntimeDemo
//
//  Created by wxd on 2021/12/6.
//

#import "UIViewController+RuntimeDemo.h"
#import "RuntimeUtils.h"
#import <objc/runtime.h>

@implementation UIViewController (RuntimeDemo)
// 最简单的一种hook方法，适用于已经对外暴露的类，基于该类写一个Category,并实现一个新的方法即可。
+ (void)load
{
    // 交换两个方法的实现
    exchangeMethod([UIViewController class],@selector(viewDidAppear:),@selector(newViewDidAppear:));
}
- (void)newViewDidAppear:(BOOL)animated{
    NSLog(@"%@ newViewDidAppear",[self class] );
    [self newViewDidAppear:animated];
}

@end
