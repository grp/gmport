/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Control.h"
#import "ControlViewController.h"

#import "input.h"

static ControlViewController<NSNumber *> *UndertaleLayout(void)
{
    CGSize actionSize = CGSizeMake(70, 70);
    CGPoint actionAnchor = CGPointMake(0.85, 0.8);
    NSArray<Button<NSNumber *> *> *action = @[
        [[Button alloc] initWithName:@"Z" value:@(input_keycode_z) center:CGVectorMake(45, -20) anchor:actionAnchor size:actionSize],
        [[Button alloc] initWithName:@"X" value:@(input_keycode_x) center:CGVectorMake(-45, 20) anchor:actionAnchor size:actionSize],
    ];

    CGSize controlSize = CGSizeMake(75, 25);
    CGPoint controlAnchor = CGPointMake(0.5, 0.92);
    NSArray<Button<NSNumber *> *> *control = @[
        [[Button alloc] initWithName:@"CONTROL" value:@(input_keycode_control) center:CGVectorMake(0, 0) anchor:controlAnchor size:controlSize],
    ];

    NSMutableSet<Button<NSNumber *> *> *buttons = [NSMutableSet set];
    [buttons addObjectsFromArray:action];
    [buttons addObjectsFromArray:control];

    CGSize padSize = CGSizeMake(180, 180);
    CGPoint padAnchor = CGPointMake(0.15, 0.75);
    Pad<NSNumber *> *pad = [[Pad alloc] initWithUpValue:@(input_keycode_up) leftValue:@(input_keycode_left) downValue:@(input_keycode_down) rightValue:@(input_keycode_right) center:CGVectorMake(0, 0) anchor:padAnchor size:padSize];
    NSSet<Pad<NSNumber *> *> *pads = [NSSet setWithObject:pad];

    return [[ControlViewController alloc] initWithButtons:buttons pads:pads];
}

static ControlViewController<NSNumber *> *AM2RLayout(void)
{
    CGSize actionSize = CGSizeMake(70, 70);
    CGPoint actionAnchor = CGPointMake(0.85, 0.8);
    NSArray<Button<NSNumber *> *> *action = @[
        [[Button alloc] initWithName:@"Z" value:@(input_keycode_z) center:CGVectorMake(45, -20) anchor:actionAnchor size:actionSize],
        [[Button alloc] initWithName:@"X" value:@(input_keycode_x) center:CGVectorMake(-45, 20) anchor:actionAnchor size:actionSize],
    ];

    CGSize triggerSize = CGSizeMake(110, 35);
    CGFloat triggerOffset = -5;
    NSArray<Button<NSNumber *> *> *trigger = @[
        [[Button alloc] initWithName:@"SHIFT" value:@(input_keycode_shift) center:CGVectorMake(triggerSize.width / 2 - triggerOffset, triggerSize.height / 2 - triggerOffset) anchor:CGPointMake(0.0, 0.0) size:triggerSize],
        [[Button alloc] initWithName:@"A" value:@(input_keycode_a) center:CGVectorMake(-triggerSize.width / 2 + triggerOffset, triggerSize.height / 2 - triggerOffset) anchor:CGPointMake(1.0, 0.0) size:triggerSize],
    ];

    CGSize controlSize = CGSizeMake(75, 25);
    CGPoint controlAnchor = CGPointMake(0.5, 0.92);
    NSArray<Button<NSNumber *> *> *control = @[
        [[Button alloc] initWithName:@"ENTER" value:@(input_keycode_enter) center:CGVectorMake(-45, 0) anchor:controlAnchor size:controlSize],
        [[Button alloc] initWithName:@"S" value:@(input_keycode_s) center:CGVectorMake(45, 0) anchor:controlAnchor size:controlSize],
    ];

    NSMutableSet<Button<NSNumber *> *> *buttons = [NSMutableSet set];
    [buttons addObjectsFromArray:action];
    [buttons addObjectsFromArray:trigger];
    [buttons addObjectsFromArray:control];

    CGSize padSize = CGSizeMake(180, 180);
    CGPoint padAnchor = CGPointMake(0.15, 0.75);
    Pad<NSNumber *> *pad = [[Pad alloc] initWithUpValue:@(input_keycode_up) leftValue:@(input_keycode_left) downValue:@(input_keycode_down) rightValue:@(input_keycode_right) center:CGVectorMake(0, 0) anchor:padAnchor size:padSize];
    NSSet<Pad<NSNumber *> *> *pads = [NSSet setWithObject:pad];

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

            ControlViewController<NSNumber *> *viewController = UndertaleLayout();
            viewController.pressHandler = ^(NSNumber *value) {
                input_key_down(value.intValue);
            };
            viewController.releaseHandler = ^(NSNumber *value) {
                input_key_up(value.intValue);
            };

            window.rootViewController = viewController;
            [window makeKeyAndVisible];
        });
    }];
}

