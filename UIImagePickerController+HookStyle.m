//
//  UIImagePickerController+HookStyle.m
//  修改模态出系统相册库的导航条样式
//
//  Created by lipan on 2016/12/27.
//  Copyright © 2016年 Company. All rights reserved.
//

#import "UIImagePickerController+HookStyle.h"
#import <objc/runtime.h>

void Swizzle(Class c, SEL origSEL, SEL newSEL)
{
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method newMethod = class_getInstanceMethod(c, newSEL);
    
    if(class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    {
        class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@implementation UIImagePickerController (HookStyle)

+ (void)load
 {
     static dispatch_once_t predicate;
     dispatch_once(&predicate, ^{
         Swizzle([UIImagePickerController class],@selector(viewDidLoad),@selector(lp_viewDidLoad));
     });
 }

- (void)lp_viewDidLoad
{
    self.delegate = self;
    [self lp_viewDidLoad];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [navigationController.navigationItem.leftBarButtonItem setTintColor:kNavigationBarTitleColor];
//    [navigationController.navigationItem.rightBarButtonItem setTintColor:kNavigationBarTitleColor];
    [navigationController.navigationBar setTintColor:kNavigationBarTitleColor];
    [navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:kNavigationBarTitle,
                                                                      NSForegroundColorAttributeName:kNavigationBarTitleColor}];
}

@end
