/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Control.h"
#import "ControlViewController.h"

#import "input.h"
#import "InputKeys.h"


static ControlViewController<InputKey *> *UndertaleLayout(InputKeys *inputKeys)
{
    CGSize actionSize = CGSizeMake(70, 70);
    CGPoint actionAnchor = CGPointMake(0.85, 0.8);
    NSArray<Button<InputKey *> *> *action = @[
        [[Button alloc] initWithName:@"Z" value:[inputKeys keyWithKeycode:input_keycode_z] center:CGVectorMake(45, -20) anchor:actionAnchor size:actionSize],
        [[Button alloc] initWithName:@"X" value:[inputKeys keyWithKeycode:input_keycode_x] center:CGVectorMake(-45, 20) anchor:actionAnchor size:actionSize],
    ];

    CGSize controlSize = CGSizeMake(75, 25);
    CGPoint controlAnchor = CGPointMake(0.5, 0.92);
    NSArray<Button<InputKey *> *> *control = @[
        [[Button alloc] initWithName:@"CONTROL" value:[inputKeys keyWithKeycode:input_keycode_control] center:CGVectorMake(0, 0) anchor:controlAnchor size:controlSize],
    ];

    NSMutableSet<Button<InputKey *> *> *buttons = [NSMutableSet set];
    [buttons addObjectsFromArray:action];
    [buttons addObjectsFromArray:control];

    CGSize padSize = CGSizeMake(180, 180);
    CGPoint padAnchor = CGPointMake(0.15, 0.75);
    Pad<InputKey *> *pad = [[Pad alloc] initWithUpValue:[inputKeys keyWithKeycode:input_keycode_up] leftValue:[inputKeys keyWithKeycode:input_keycode_left] downValue:[inputKeys keyWithKeycode:input_keycode_down] rightValue:[inputKeys keyWithKeycode:input_keycode_right] center:CGVectorMake(0, 0) anchor:padAnchor size:padSize];
    NSSet<Pad<InputKey *> *> *pads = [NSSet setWithObject:pad];

    return [[ControlViewController alloc] initWithButtons:buttons pads:pads];
}

static ControlViewController<InputKey *> *AM2RLayout(InputKeys *inputKeys)
{
    CGSize actionSize = CGSizeMake(70, 70);
    CGPoint actionAnchor = CGPointMake(0.85, 0.8);
    NSArray<Button<InputKey *> *> *action = @[
        [[Button alloc] initWithName:@"Z" value:[inputKeys keyWithKeycode:input_keycode_z] center:CGVectorMake(45, -20) anchor:actionAnchor size:actionSize],
        [[Button alloc] initWithName:@"X" value:[inputKeys keyWithKeycode:input_keycode_x] center:CGVectorMake(-45, 20) anchor:actionAnchor size:actionSize],
    ];

    CGSize triggerSize = CGSizeMake(110, 35);
    CGFloat triggerOffset = -5;
    NSArray<Button<InputKey *> *> *trigger = @[
        [[Button alloc] initWithName:@"SHIFT" value:[inputKeys keyWithKeycode:input_keycode_shift] center:CGVectorMake(triggerSize.width / 2 - triggerOffset, triggerSize.height / 2 - triggerOffset) anchor:CGPointMake(0.0, 0.0) size:triggerSize],
        [[Button alloc] initWithName:@"A" value:[inputKeys keyWithKeycode:input_keycode_a] center:CGVectorMake(-triggerSize.width / 2 + triggerOffset, triggerSize.height / 2 - triggerOffset) anchor:CGPointMake(1.0, 0.0) size:triggerSize],
    ];

    CGSize controlSize = CGSizeMake(75, 25);
    CGPoint controlAnchor = CGPointMake(0.5, 0.92);
    NSArray<Button<InputKey *> *> *control = @[
        [[Button alloc] initWithName:@"ENTER" value:[inputKeys keyWithKeycode:input_keycode_enter] center:CGVectorMake(-45, 0) anchor:controlAnchor size:controlSize],
        [[Button alloc] initWithName:@"S" value:[inputKeys keyWithKeycode:input_keycode_s] center:CGVectorMake(45, 0) anchor:controlAnchor size:controlSize],
    ];

    NSMutableSet<Button<InputKey *> *> *buttons = [NSMutableSet set];
    [buttons addObjectsFromArray:action];
    [buttons addObjectsFromArray:trigger];
    [buttons addObjectsFromArray:control];

    CGSize padSize = CGSizeMake(180, 180);
    CGPoint padAnchor = CGPointMake(0.15, 0.75);
    Pad<InputKey *> *pad = [[Pad alloc] initWithUpValue:[inputKeys keyWithKeycode:input_keycode_up] leftValue:[inputKeys keyWithKeycode:input_keycode_left] downValue:[inputKeys keyWithKeycode:input_keycode_down] rightValue:[inputKeys keyWithKeycode:input_keycode_right] center:CGVectorMake(0, 0) anchor:padAnchor size:padSize];
    NSSet<Pad<InputKey *> *> *pads = [NSSet setWithObject:pad];

    return [[ControlViewController alloc] initWithButtons:buttons pads:pads];
}


__attribute__((constructor))
static void ControlsInitialize(void)
{
    /* Keep the window alive. */
    static UIWindow *window = nil;

    InputKeys *inputKeys = [InputKeys defaultKeys];

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [notificationCenter addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:mainQueue usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIScreen *mainScreen = [UIScreen mainScreen];

            window = [[UIWindow alloc] initWithFrame:mainScreen.bounds];
            window.windowLevel = 1.0;

            ControlViewController<InputKey *> *viewController = UndertaleLayout(inputKeys);
            viewController.pressHandler = ^(InputKey *inputKey) {
                input_key_down(inputKey.keycode);
            };
            viewController.releaseHandler = ^(InputKey *inputKey) {
                input_key_up(inputKey.keycode);
            };

            window.rootViewController = viewController;
            [window makeKeyAndVisible];
        });
    }];
}

