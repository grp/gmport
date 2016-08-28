/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "input.h"


@interface ControlView : UIView

@end

static NSSet<NSNumber *> *Buttons(UIView *view, NSSet<UITouch *> *touches)
{
    NSMutableSet<NSNumber *> *buttons = [NSMutableSet set];

    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:view];

        // joystick bottom left corner
        {
            CGRect area = CGRectMake(0, view.bounds.size.height / 2, view.bounds.size.width / 2, view.bounds.size.height / 2);
            if (CGRectContainsPoint(area, location)) {
                CGSize region = CGSizeMake(area.size.width / 3, area.size.height / 3);
                if (location.x < CGRectGetMinX(area) + region.width) {
                    [buttons addObject:@(input_keycode_left)];
                }
                if (location.x > CGRectGetMaxX(area) - region.width) {
                    [buttons addObject:@(input_keycode_right)];
                }
                if (location.y < CGRectGetMinY(area) + region.height) {
                    [buttons addObject:@(input_keycode_up)];
                }
                if (location.y > CGRectGetMaxY(area) - region.height) {
                    [buttons addObject:@(input_keycode_down)];
                }
            }
        }

        // buttons top right corner
        {
            CGRect area = CGRectMake(view.bounds.size.width / 2, 0, view.bounds.size.width / 2, view.bounds.size.height / 2);
            if (CGRectContainsPoint(area, location)) {
                if (location.y < CGRectGetMidY(area)) {
                    if (location.x < CGRectGetMidX(area)) {
                        [buttons addObject:@(input_keycode_z)];
                    } else {
                        [buttons addObject:@(input_keycode_x)];
                    }
                } else {
                    if (location.x < CGRectGetMidX(area)) {
                        [buttons addObject:@(input_keycode_c)];
                    } else {
                        [buttons addObject:@(input_keycode_v)];
                    }
                }
            }
        }

        // buttons bottom right corner
        {
            CGRect area = CGRectMake(view.bounds.size.width / 2, view.bounds.size.height / 2, view.bounds.size.width / 2, view.bounds.size.height / 2);
            if (CGRectContainsPoint(area, location)) {
                if (location.y < CGRectGetMidY(area)) {
                    if (location.x < CGRectGetMidX(area)) {
                        [buttons addObject:@(input_keycode_a)];
                    } else {
                        [buttons addObject:@(input_keycode_s)];
                    }
                } else {
                    if (location.x < CGRectGetMidX(area)) {
                        [buttons addObject:@(input_keycode_d)];
                    } else {
                        [buttons addObject:@(input_keycode_f)];
                    }
                }
            }
        }
    }

    return [buttons copy];
}

@implementation ControlView {
    NSMutableSet<NSNumber *> *_previous;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.multipleTouchEnabled = YES;
        _previous = [NSMutableSet set];
    }

    return self;
}

static void Down(NSSet<NSNumber *> *buttons)
{
    for (NSNumber *button in buttons) {
        input_key_down(button.intValue);
    }
}

static void Up(NSSet<NSNumber *> *buttons)
{
    for (NSNumber *button in buttons) {
        input_key_up(button.intValue);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet<NSNumber *> *buttons = Buttons(self, touches);

    Down(buttons);

    [_previous unionSet:buttons];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet<NSNumber *> *buttons = Buttons(self, touches);

    NSMutableSet<NSNumber *> *up = [_previous mutableCopy];
    [up minusSet:buttons];
    Up(up);

    NSMutableSet<NSNumber *> *down = [buttons mutableCopy];
    [down minusSet:_previous];
    Down(down);

    [_previous unionSet:down];
    [_previous minusSet:up];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet<NSNumber *> *buttons = Buttons(self, touches);

    Up(buttons);

    [_previous minusSet:buttons];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet<NSNumber *> *buttons = Buttons(self, touches);

    Up(buttons);

    [_previous minusSet:buttons];
}

@end


@interface ControlViewController : UIViewController

@end

@implementation ControlViewController

- (void)loadView
{
    ControlView *view = [[ControlView alloc] init];
    self.view = view;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)interfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end


static UIWindow *window = nil;

__attribute__((constructor))
static void ControlsInitialize(void)
{
    NSLog(@"booted!");

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [notificationCenter addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:mainQueue usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIScreen *mainScreen = [UIScreen mainScreen];

            window = [[UIWindow alloc] initWithFrame:mainScreen.bounds];
            window.windowLevel = 2000.0;

            ControlViewController *viewController = [[ControlViewController alloc] init];
            window.rootViewController = viewController;

            [window makeKeyAndVisible];
            NSLog(@"added overlay %@ %@", window, viewController);
        });
    }];
}

