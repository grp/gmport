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


static Button<InputKey *> *LoadButton(InputKeys *inputKeys, NSDictionary<NSString *, id> *dictionary)
{
    NSString *name = dictionary[@"Name"];
    if (name == nil) {
        return nil;
    }

    InputKey *inputKey = [inputKeys keyWithIdentifier:dictionary[@"KeyIdentifier"]];
    if (inputKey == nil) {
        return nil;
    }

    CGVector center = CGVectorFromString(dictionary[@"Center"]);
    CGPoint anchor = CGPointFromString(dictionary[@"Anchor"]);
    CGSize size = CGSizeFromString(dictionary[@"Size"]);
    UIEdgeInsets slop = UIEdgeInsetsFromString(dictionary[@"Slop"]);

    return [[Button alloc] initWithName:name value:inputKey center:center anchor:anchor size:size slop:slop];
}

static Pad<InputKey *> *LoadPad(InputKeys *inputKeys, NSDictionary<NSString *, id> *dictionary)
{
    InputKey *upInputKey = [inputKeys keyWithIdentifier:dictionary[@"UpKeyIdentifier"]];
    InputKey *leftInputKey = [inputKeys keyWithIdentifier:dictionary[@"LeftKeyIdentifier"]];
    InputKey *downInputKey = [inputKeys keyWithIdentifier:dictionary[@"DownKeyIdentifier"]];
    InputKey *rightInputKey = [inputKeys keyWithIdentifier:dictionary[@"RightKeyIdentifier"]];
    if (upInputKey == nil || leftInputKey == nil || downInputKey == nil || rightInputKey == nil) {
        return nil;
    }

    CGVector center = CGVectorFromString(dictionary[@"Center"]);
    CGPoint anchor = CGPointFromString(dictionary[@"Anchor"]);
    CGSize size = CGSizeFromString(dictionary[@"Size"]);
    UIEdgeInsets slop = UIEdgeInsetsFromString(dictionary[@"Slop"]);

    return [[Pad alloc] initWithUpValue:upInputKey leftValue:leftInputKey downValue:downInputKey rightValue:rightInputKey center:center anchor:anchor size:size slop:slop];
}


__attribute__((constructor))
static void InputControlsInitialize(void)
{
    /*
     * Load input controls specification from bundle.
     */
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *controlsURL = [mainBundle URLForResource:@"InputControls" withExtension:@"plist"];
    NSDictionary<NSString *, id> *controlsDictionary = [NSDictionary dictionaryWithContentsOfURL:controlsURL];
    if (controlsDictionary == nil) {
        NSLog(@"warning: unable to load controls (URL: %@)", controlsURL);
    }

    /*
     * Parse buttons and pads from specification.
     */
    NSArray<NSDictionary<NSString *, id> *> *buttonsArray = controlsDictionary[@"Buttons"];
    NSArray<NSDictionary<NSString *, id> *> *padsArray = controlsDictionary[@"Pads"];

    InputKeys *inputKeys = [InputKeys defaultKeys];

    NSMutableSet<Button<InputKey *> *> *buttons = [NSMutableSet set];
    for (NSDictionary<NSString *, id> *buttonDictionary in buttonsArray) {
        Button<InputKey *> *button = LoadButton(inputKeys, buttonDictionary);
        if (button != nil) {
            [buttons addObject:button];
        }
    }

    NSMutableSet<Pad<InputKey *> *> *pads = [NSMutableSet set];
    for (NSDictionary<NSString *, id> *padDictionary in padsArray) {
        Pad<InputKey *> *pad = LoadPad(inputKeys, padDictionary);
        if (pad != nil) {
            [pads addObject:pad];
        }
    }

    /*
     * Create control overlay for the input controls.
     */
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [notificationCenter addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:mainQueue usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            /* Keep the window alive. */
            static UIWindow *window;

            /* Create the overlay window. */
            UIScreen *mainScreen = [UIScreen mainScreen];
            window = [[UIWindow alloc] initWithFrame:mainScreen.bounds];
            window.windowLevel = 1.0;

            /* Create control view controller, and handle actions. */
            ControlViewController<InputKey *> *viewController = [[ControlViewController alloc] initWithButtons:buttons pads:pads];
            viewController.pressHandler = ^(InputKey *inputKey) {
                input_key_down(inputKey.keycode);
            };
            viewController.releaseHandler = ^(InputKey *inputKey) {
                input_key_up(inputKey.keycode);
            };

            /* Show the overlay window. */
            window.rootViewController = viewController;
            [window makeKeyAndVisible];
        });
    }];
}

