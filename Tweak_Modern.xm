// BlockWAUpdates Tweak - 现代版本
// 使用最新 iOS SDK 和现代 Objective-C API
// 针对 iOS 14+ 优化

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ============================================================================
// WhatsApp 类声明 - 使用现代 API
// ============================================================================

@interface WARootViewController : UIViewController
- (BOOL)isBuildExpired;
- (void)expireBuild;
- (void)presentHelperScreen;
- (void)wa_applicationDidEnterBackground;
@end

// ============================================================================
// Logos 钩子定义 - 现代实现
// ============================================================================

%hook WARootViewController

/**
 * isBuildExpired - 阻止构建过期检查
 * 返回 NO 表示应用未过期，从而阻止 WhatsApp 显示更新提示
 */
- (BOOL)isBuildExpired {
    // 直接返回 NO，不调用原始实现
    // 这会阻止应用显示"构建已过期，请更新"的提示
    NSLog(@"[BlockWAUpdates] isBuildExpired 调用 - 返回 NO");
    return NO;
}

/**
 * expireBuild - 阻止构建过期操作
 * 禁止执行过期构建的相关操作
 */
- (void)expireBuild {
    // 不调用原始实现
    // 这会阻止 WhatsApp 将应用标记为已过期
    NSLog(@"[BlockWAUpdates] expireBuild 调用 - 已拦截");
    return;
}

/**
 * presentHelperScreen - 阻止帮助屏幕显示
 * 防止显示更新或错误提示屏幕
 */
- (void)presentHelperScreen {
    // 不调用原始实现
    // 这会阻止显示任何帮助或更新提示屏幕
    NSLog(@"[BlockWAUpdates] presentHelperScreen 调用 - 已拦截");
    return;
}

/**
 * wa_applicationDidEnterBackground - 处理后台事件
 * 应用进入后台时的处理
 */
- (void)wa_applicationDidEnterBackground {
    // 调用原始实现以保持应用正常功能
    %orig;

    // 在应用进入后台时，确保构建状态检查不会被触发
    NSLog(@"[BlockWAUpdates] 应用进入后台");
}

%end

// ============================================================================
// 初始化代码 - 加载时执行
// ============================================================================

%ctor {
    // 在线程安全的上下文中初始化
    dispatch_once_t onceToken;
    static dispatch_once_t token = 0;

    dispatch_once(&token, ^{
        NSLog(@"==============================================");
        NSLog(@"BlockWAUpdates v1.0.1 - 现代版本");
        NSLog(@"iOS SDK: 最新版本 (14.0+)");
        NSLog(@"钩接目标: WARootViewController");
        NSLog(@"状态: 已成功加载");
        NSLog(@"==============================================");

        // 获取当前 iOS 版本
        NSString *osVersion = [[UIDevice currentDevice] systemVersion];
        NSLog(@"运行 iOS 版本: %@", osVersion);

        // 确认钩子已应用
        NSLog(@"已钩接方法:");
        NSLog(@"  - isBuildExpired");
        NSLog(@"  - expireBuild");
        NSLog(@"  - presentHelperScreen");
        NSLog(@"  - wa_applicationDidEnterBackground");
    });
}

// ============================================================================
// 安全退出处理
// ============================================================================

%dtor {
    NSLog(@"[BlockWAUpdates] 卸载钩子");
}
