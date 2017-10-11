//
//  AppDelegate.m
//  Screenshot Tools
//
//  Created by Live365_Joni on 10/28/14.
//  Copyright (c) 2014 Joni. All rights reserved.
//

#import "AppDelegate.h"

static AppDelegate *appInstance = nil;
static NSUInteger _myWindowNumber = 0;
@implementation AppDelegate
+(AppDelegate *)instance
{
    return appInstance;
}

+(CaptureState)currentCaptureState
{
    return [[AppDelegate instance] _currentCaptureState];
}

+ (void )showEventDictionary:(NSDictionary *)dic
{
//    [[AppDelegate instance] WindowNamelabel].stringValue = [dic objectForKey:@"window name"];
//    [[AppDelegate instance] WindowRectlabel].stringValue = [dic objectForKey:@"window rect"];
//    [[AppDelegate instance] MouseLocationlabel].stringValue = [dic objectForKey:@"mouse location"];
//    [[AppDelegate instance] KeyDownlabel].stringValue = [dic objectForKey:@"key"];
}

+(NSUInteger)getCurWindowNumber
{
    return _myWindowNumber;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DidBeginCaptureRegister;
    appInstance = self;
    
    _CaptureManager = [[CaptureManager alloc] init];
    // Insert code here to initialize your application
    self.label.stringValue = @"该Demo展示了全局监听事件，包含鼠标和键盘事件。\n\n     不仅可以监听App内部的事件，也可以监听App外部的事件,监听事件的同时也可获取当前鼠标位置所在的window信息,比如window名称和window的位置、大小等。\n\n  区域截图(右键返回) \n\n 当自动检索到窗口时，点击左键锁定，右键黑色区域取消自动检索窗口进行自定义选区，再次右键，退出截图";
//    char *command= "/usr/bin/sqlite3";
//    char *args[] = {"/Library/Application Support/com.apple.TCC/TCC.db", "INSERT or REPLACE INTO access  VALUES('kTCCServiceAccessibility','com.yourapp',0,1,0,NULL);", nil};
//    AuthorizationRef authRef;
//    OSStatus status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authRef);
//    if (status == errAuthorizationSuccess) {
//        status = AuthorizationExecuteWithPrivileges(authRef, command, kAuthorizationFlagDefaults, args, NULL);
//        AuthorizationFree(authRef, kAuthorizationFlagDestroyRights);
//        if(status != 0){
//            //handle errors...
//        }
//    }
   
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask|NSKeyUpMask handler:^(NSEvent *event) {
        //若无法进入回调函数,则打开系统偏好设置--->辅助功能--->勾选“启用辅助设备的控制”
        [self _screenshotKeyDown:event];
    }];
    
    [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent *(NSEvent *event) {
        
        [self _screenshotKeyDown:event];
        return event;
    }];
    
    //鼠标事件
    CGEventMask eventMask =  CGEventMaskBit(kCGEventMouseMoved)|CGEventMaskBit(kCGEventLeftMouseDragged);
    CFMachPortRef eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault, eventMask, (CGEventTapCallBack)eventCallback, nil);
    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
    CGEventTapEnable(eventTap, true);
//    CFRelease(eventTap);
    CFRelease(runLoopSource);
    
    /*模拟键盘事件
    CGEventRef eventRef = CGEventCreateKeyboardEvent(NULL, kVK_ANSI_T, true);
    CGEventSetFlags(eventRef, kCGEventFlagMaskShift | kCGEventFlagMaskCommand);
    CGEventPost(kCGSessionEventTap, eventRef);
    CFRelease(eventRef);
     */
    
}

-(void)_screenshotKeyDown:(NSEvent *)event
{
    NSUInteger flags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
    if (flags == NSShiftKeyMask ) {
        NSLog(@"%@",[event characters]);
    }
}

-(CaptureState)_currentCaptureState
{
    if (_CaptureManager) {
        return _CaptureManager.mCaptureState;
    }
    return CaptureState_None;
}
-(IBAction)FullScreenCapture:(id)sender
{
    _CaptureManager.mCaptureType =CaptureType_FullScreen;
    [_CaptureManager beginCapture];
    [_CaptureManager capture];
    [_CaptureManager endCapture];
}

-(IBAction)RegionScreenCapture:(id)sender
{
    _CaptureManager.mCaptureType =CaptureType_WindowRegion;
    [_CaptureManager beginCapture];
}

static NSString* getKeyDownString(CGEventRef eventRef)
{
    UniCharCount actualLength = 0;
    UniCharCount defaultLength = 128;
    UniChar inputString[defaultLength];
    CGEventKeyboardGetUnicodeString(eventRef, defaultLength, &actualLength, inputString);
    NSString *key = [[[NSString alloc] initWithBytes:(const void *)inputString length:actualLength encoding:NSUTF8StringEncoding] autorelease];
    return key;
}

static CGEventRef eventCallback(CGEventTapProxy proxy , CGEventType type, CGEventRef event ,void *refcon)
{
////    NSString *key = getKeyDownString(event);
//    if (type == kCGEventKeyDown) {
//        CGEventFlags flags = CGEventGetFlags(event) & NSDeviceIndependentModifierFlagsMask;
//        if (flags == kCGEventFlagMaskShift) {
//            NSLog(@"shift key down");
//        }
//        else if(flags == kCGEventFlagMaskCommand )
//        {
//            NSLog(@"command key down");
//            [AppDelegate RegionShot];
//        }
//        else if (flags == kCGEventFlagMaskCommand + kCGEventFlagMaskShift)
//        {
//            NSLog(@"command + shift key down");
//            [AppDelegate FullScreenShot];
//        }
//}
    if (type == kCGEventLeftMouseDragged)
    {
        NSLog(@"left mouse drag...");
    }
    if (type == kCGEventFlagsChanged) {
        NSLog(@"flags changed");
    }
    
    if (type == kCGEventKeyDown) {
        NSLog(@"key down");
    }

   if (type == kCGEventMouseMoved)
    {
        //获取鼠标所在位置的窗口信息
        //CGRect 坐标系与NSRect 坐标系不同.CGRect 坐标系原点在左上角，NSRect 坐标系原点在左下角
        NSRect fullScreenRc = [[NSScreen mainScreen] frame];
        CGPoint location = CGEventGetLocation(event);
        NSPoint nsLocation = NSMakePoint(location.x, fullScreenRc.size.height - location.y);
        NSInteger windowNumber = [NSWindow windowNumberAtPoint:nsLocation belowWindowWithWindowNumber:_myWindowNumber];
        CGWindowID windowID = (CGWindowID)windowNumber;
        CFArrayRef array = CFArrayCreate(NULL, (const void **)&windowID, 5, NULL);
        
        NSArray *windowInfos =  (NSArray *)CGWindowListCreateDescriptionFromArray(array);
        NSDictionary *captureWindowInfoDic = nil;
        if (windowInfos.count>0)
        {
            captureWindowInfoDic = [windowInfos objectAtIndex:0];
        }
        if ([AppDelegate currentCaptureState] == CaptureState_Capturing) {
            UpdateCaptureWindowPush;
        }
        [windowInfos release];
        CFRelease(array);
    }
    else if (type ==kCGEventLeftMouseDown)
    {
        if ([AppDelegate currentCaptureState] == CaptureState_Capturing)
        {
            NSLog(@"xxxxxx");
             StartCustomRegionCapturePush;
        }
    }
    return event;
}

#pragma mark - NSNotification
-(void)didBeginCaptureNotification:(NSNotification *)notify
{
    if (notify.object && [notify.object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = (NSDictionary*)notify.object;
        _myWindowNumber = [[dic valueForKey:@"kWindowNumber"] unsignedIntegerValue];
    }
}

@end
