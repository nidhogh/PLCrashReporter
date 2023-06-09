#include "plcrashreporter.h"
#import <CrashReporter.h>
#include <QDebug>

// 回调函数，将崩溃信息输出到文件中
static void handleSignalCallback (siginfo_t *info, ucontext_t *uap, void *context) {
    qDebug() << __FUNCTION__;
    // 获取 PLCrashReporter 实例
    PLCrashReporter *crashReporter = (PLCrashReporter *)context;

    if ([crashReporter hasPendingCrashReport]) {
        NSError *error;

        // Try loading the crash report.
        NSData *data = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
        if (data == nil) {
            NSLog(@"Failed to load crash report data: %@", error);
            return;
        }

        // Retrieving crash reporter data.
        PLCrashReport *report = [[PLCrashReport alloc] initWithData: data error: &error];
        if (report == nil) {
            NSLog(@"Failed to parse crash report: %@", error);
            return;
        }

        // We could send the report from here, but we'll just print out some debugging info instead.
        NSString *text = [PLCrashReportTextFormatter stringValueForCrashReport: report withTextFormat: PLCrashReportTextFormatiOS];
        NSLog(@"%@", text);

        // Purge the report.
        [crashReporter purgePendingCrashReport];
    }
}

plcrashreporter::plcrashreporter(QObject *parent) : QObject(parent)
{
    // Uncomment and implement isDebuggerAttached to safely run this code with a debugger.
    // See: https://github.com/microsoft/plcrashreporter/blob/2dd862ce049e6f43feb355308dfc710f3af54c4d/Source/Crash%20Demo/main.m#L96
    // if (![self isDebuggerAttached]) {

    // It is strongly recommended that local symbolication only be enabled for non-release builds.
    // Use PLCrashReporterSymbolicationStrategyNone for release versions.
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType: PLCrashReporterSignalHandlerTypeMach
                                                                       symbolicationStrategy: PLCrashReporterSymbolicationStrategyAll];
    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration: config];

    // 设置回调
    PLCrashReporterCallbacks callbacks;
    memset(&callbacks, 0, sizeof(callbacks));
    callbacks.version = 0;
    callbacks.context = (__bridge void *)crashReporter;
    callbacks.handleSignal = handleSignalCallback;

    // 注册回调
    [crashReporter setCrashCallbacks:&callbacks];

    //启用 PLCrashReporter
    NSError *error;
    if (![crashReporter enableCrashReporterAndReturnError:&error]) {
        NSLog(@"Failed to enable crash reporter: %@", error);
    }
}
