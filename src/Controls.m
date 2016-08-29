/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Control.h"
#import "ControlViewController.h"

static ControlViewController *UndertaleLayout(void)
{
    CGSize actionSize = CGSizeMake(70, 70);
    CGPoint actionAnchor = CGPointMake(0.85, 0.8);
    NSArray<Button *> *action = @[
        [[Button alloc] initWithName:@"Z" keycode:input_keycode_z center:CGVectorMake(45, -20) anchor:actionAnchor size:actionSize],
        [[Button alloc] initWithName:@"X" keycode:input_keycode_x center:CGVectorMake(-45, 20) anchor:actionAnchor size:actionSize],
    ];

    CGSize controlSize = CGSizeMake(75, 25);
    CGPoint controlAnchor = CGPointMake(0.5, 0.92);
    NSArray<Button *> *control = @[
        [[Button alloc] initWithName:@"CONTROL" keycode:input_keycode_control center:CGVectorMake(0, 0) anchor:controlAnchor size:controlSize],
    ];

    NSMutableSet<Button *> *buttons = [NSMutableSet set];
    [buttons addObjectsFromArray:action];
    [buttons addObjectsFromArray:control];

    CGSize padSize = CGSizeMake(180, 180);
    CGPoint padAnchor = CGPointMake(0.15, 0.75);
    Pad *pad = [[Pad alloc] initWithUpKeycode:input_keycode_up leftKeycode:input_keycode_left downKeycode:input_keycode_down rightKeycode:input_keycode_right center:CGVectorMake(0, 0) anchor:padAnchor size:padSize];
    NSSet<Pad *> *pads = [NSSet setWithObject:pad];

    return [[ControlViewController alloc] initWithButtons:buttons pads:pads];
}

static ControlViewController *AM2RLayout(void)
{
    CGSize actionSize = CGSizeMake(70, 70);
    CGPoint actionAnchor = CGPointMake(0.85, 0.8);
    NSArray<Button *> *action = @[
        [[Button alloc] initWithName:@"Z" keycode:input_keycode_z center:CGVectorMake(45, -20) anchor:actionAnchor size:actionSize],
        [[Button alloc] initWithName:@"X" keycode:input_keycode_x center:CGVectorMake(-45, 20) anchor:actionAnchor size:actionSize],
    ];

    CGSize triggerSize = CGSizeMake(110, 35);
    CGFloat triggerOffset = -5;
    NSArray<Button *> *trigger = @[
        [[Button alloc] initWithName:@"SHIFT" keycode:input_keycode_shift center:CGVectorMake(triggerSize.width / 2 - triggerOffset, triggerSize.height / 2 - triggerOffset) anchor:CGPointMake(0.0, 0.0) size:triggerSize],
        [[Button alloc] initWithName:@"A" keycode:input_keycode_a center:CGVectorMake(-triggerSize.width / 2 + triggerOffset, triggerSize.height / 2 - triggerOffset) anchor:CGPointMake(1.0, 0.0) size:triggerSize],
    ];

    CGSize controlSize = CGSizeMake(75, 25);
    CGPoint controlAnchor = CGPointMake(0.5, 0.92);
    NSArray<Button *> *control = @[
        [[Button alloc] initWithName:@"ENTER" keycode:input_keycode_enter center:CGVectorMake(-45, 0) anchor:controlAnchor size:controlSize],
        [[Button alloc] initWithName:@"S" keycode:input_keycode_s center:CGVectorMake(45, 0) anchor:controlAnchor size:controlSize],
    ];

    NSMutableSet<Button *> *buttons = [NSMutableSet set];
    [buttons addObjectsFromArray:action];
    [buttons addObjectsFromArray:trigger];
    [buttons addObjectsFromArray:control];

    CGSize padSize = CGSizeMake(180, 180);
    CGPoint padAnchor = CGPointMake(0.15, 0.75);
    Pad *pad = [[Pad alloc] initWithUpKeycode:input_keycode_up leftKeycode:input_keycode_left downKeycode:input_keycode_down rightKeycode:input_keycode_right center:CGVectorMake(0, 0) anchor:padAnchor size:padSize];
    NSSet<Pad *> *pads = [NSSet setWithObject:pad];

    return [[ControlViewController alloc] initWithButtons:buttons pads:pads];
}


__attribute__((constructor))
static void ControlsInitialize(void)
{
    /* Keep the window alive. */
    static UIWindow *window = nil;

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [notificationCenter addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:mainQueue usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIScreen *mainScreen = [UIScreen mainScreen];

            window = [[UIWindow alloc] initWithFrame:mainScreen.bounds];
            window.windowLevel = 1.0;

            ControlViewController *viewController = UndertaleLayout();
            window.rootViewController = viewController;

            [window makeKeyAndVisible];
        });
    }];
}

