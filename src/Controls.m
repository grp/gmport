/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Control.h"
#import "ControlViewController.h"

static UIWindow *window = nil;

__attribute__((constructor))
static void ControlsInitialize(void)
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [notificationCenter addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:mainQueue usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIScreen *mainScreen = [UIScreen mainScreen];

            window = [[UIWindow alloc] initWithFrame:mainScreen.bounds];
            window.windowLevel = 2000.0;

            CGSize actionSize = CGSizeMake(65, 65);
            CGPoint actionAnchor = CGPointMake(0.83, 0.7);
            NSArray<Button *> *action = @[
                [[Button alloc] initWithName:@"Z" keycode:input_keycode_z center:CGVectorMake(65, 0) anchor:actionAnchor size:actionSize],
                [[Button alloc] initWithName:@"X" keycode:input_keycode_x center:CGVectorMake(0, 55) anchor:actionAnchor size:actionSize],
                [[Button alloc] initWithName:@"A" keycode:input_keycode_a center:CGVectorMake(-65, 0) anchor:actionAnchor size:actionSize],
                [[Button alloc] initWithName:@"C" keycode:input_keycode_c center:CGVectorMake(0, -55) anchor:actionAnchor size:actionSize],
            ];

            CGSize controlSize = CGSizeMake(75, 25);
            CGPoint controlAnchor = CGPointMake(0.5, 0.92);
            NSArray<Button *> *control = @[
                [[Button alloc] initWithName:@"ENTER" keycode:input_keycode_enter center:CGVectorMake(-45, 0) anchor:controlAnchor size:controlSize],
                [[Button alloc] initWithName:@"SHIFT" keycode:input_keycode_shift center:CGVectorMake(45, 0) anchor:controlAnchor size:controlSize],
            ];

            NSMutableSet<Button *> *buttons = [NSMutableSet set];
            [buttons addObjectsFromArray:action];
            [buttons addObjectsFromArray:control];

            CGSize padSize = CGSizeMake(180, 180);
            CGPoint padAnchor = CGPointMake(0.15, 0.70);
            Pad *pad = [[Pad alloc] initWithUpKeycode:input_keycode_up leftKeycode:input_keycode_left downKeycode:input_keycode_down rightKeycode:input_keycode_right center:CGVectorMake(0, 0) anchor:padAnchor size:padSize];
            NSSet<Pad *> *pads = [NSSet setWithObject:pad];

            ControlViewController *viewController = [[ControlViewController alloc] initWithButtons:buttons pads:pads];
            window.rootViewController = viewController;

            [window makeKeyAndVisible];
        });
    }];
}

