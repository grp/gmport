/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Hook.h"
#import "iCadeState.h"


@interface EAGLView : UIView

- (void)buttonDown:(iCadeState)state;
- (void)buttonUp:(iCadeState)state;

@end


@interface RunnerAppDelegate : NSObject <UIApplicationDelegate>

@property(nonatomic, strong) EAGLView *glView;

@end


@interface ControlView : UIView

@end

static EAGLView *GetEAGLView(void)
{
    UIApplication *application = [UIApplication sharedApplication];
    RunnerAppDelegate *delegate = (RunnerAppDelegate *)application.delegate;
    return delegate.glView;
}

static iCadeState Buttons(UIView *view, NSSet<UITouch *> *touches)
{
    iCadeState buttons = iCadeJoystickNone;

    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:view];

        // joystick bottom left corner
        {
            CGRect area = CGRectMake(0, view.bounds.size.height / 2, view.bounds.size.width / 2, view.bounds.size.height / 2);
            if (CGRectContainsPoint(area, location)) {
                CGSize region = CGSizeMake(area.size.width / 3, area.size.height / 3);
                if (location.x < CGRectGetMinX(area) + region.width) {
                    buttons |= iCadeJoystickLeft;
                }
                if (location.x > CGRectGetMaxX(area) - region.width) {
                    buttons |= iCadeJoystickRight;
                }
                if (location.y < CGRectGetMinY(area) + region.height) {
                    buttons |= iCadeJoystickUp;
                }
                if (location.y > CGRectGetMaxY(area) - region.height) {
                    buttons |= iCadeJoystickDown;
                }
            }
        }

        // buttons top right corner
        {
            CGRect area = CGRectMake(view.bounds.size.width / 2, 0, view.bounds.size.width / 2, view.bounds.size.height / 2);
            if (CGRectContainsPoint(area, location)) {
                if (location.y < CGRectGetMidY(area)) {
                    if (location.x < CGRectGetMidX(area)) {
                        buttons |= iCadeButtonA;
                    } else {
                        buttons |= iCadeButtonB;
                    }
                } else {
                    if (location.x < CGRectGetMidX(area)) {
                        buttons |= iCadeButtonC;
                    } else {
                        buttons |= iCadeButtonD;
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
                        buttons |= iCadeButtonE;
                    } else {
                        buttons |= iCadeButtonF;
                    }
                } else {
                    if (location.x < CGRectGetMidX(area)) {
                        buttons |= iCadeButtonG;
                    } else {
                        buttons |= iCadeButtonH;
                    }
                }
            }
        }
    }

    return buttons;
}

static NSString *ButtonsDescription(iCadeState state) {
    NSMutableString *description = [NSMutableString string];
    [description appendString:@"["];

    if (state & iCadeJoystickUp) {
        [description appendString:@"^"];
    } else {
        [description appendString:@" "];
    }

    if (state & iCadeJoystickDown) {
        [description appendString:@"v"];
    } else {
        [description appendString:@" "];
    }

    if (state & iCadeJoystickLeft) {
        [description appendString:@"<"];
    } else {
        [description appendString:@" "];
    }

    if (state & iCadeJoystickRight) {
        [description appendString:@">"];
    } else {
        [description appendString:@" "];
    }

    if (state & iCadeButtonA) {
        [description appendString:@"a"];
    } else {
        [description appendString:@" "];
    }

    if (state & iCadeButtonB) {
        [description appendString:@"b"];
    } else {
        [description appendString:@" "];
    }

    if (state & iCadeButtonC) {
        [description appendString:@"c"];
    } else {
        [description appendString:@" "];
    }

    if (state & iCadeButtonD) {
        [description appendString:@"d"];
    } else {
        [description appendString:@" "];
    }

    if (state & iCadeButtonE) {
        [description appendString:@"e"];
    } else {
        [description appendString:@" "];
    }

    if (state & iCadeButtonF) {
        [description appendString:@"f"];
    } else {
        [description appendString:@" "];
    }

    if (state & iCadeButtonG) {
        [description appendString:@"g"];
    } else {
        [description appendString:@" "];
    }

    if (state & iCadeButtonH) {
        [description appendString:@"h"];
    } else {
        [description appendString:@" "];
    }

    [description appendString:@"]"];
    return [description copy];
}

@implementation ControlView {
    iCadeState _previous;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.multipleTouchEnabled = YES;
    }

    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    iCadeState buttons = Buttons(self, touches);
    EAGLView *view = GetEAGLView();

    NSLog(@"began, down: %@", ButtonsDescription(buttons));
    [view buttonDown:buttons];

    _previous |= buttons;
    NSLog(@"state is now: %@", ButtonsDescription(_previous));
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    iCadeState buttons = Buttons(self, touches);
    EAGLView *view = GetEAGLView();

    iCadeState up = _previous & ~buttons;
    [view buttonUp:up];

    iCadeState down = buttons & ~_previous;
    [view buttonDown:down];

    NSLog(@"moved, up: %@, down: %@, seen: %@", ButtonsDescription(up), ButtonsDescription(down), ButtonsDescription(buttons));

    _previous |= down;
    _previous &= ~up;
    NSLog(@"state is now: %@", ButtonsDescription(_previous));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    iCadeState buttons = Buttons(self, touches);
    EAGLView *view = GetEAGLView();

    NSLog(@"ended, up: %@", ButtonsDescription(buttons));
    [view buttonUp:buttons];

    _previous &= ~buttons;
    NSLog(@"state is now: %@", ButtonsDescription(_previous));
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    iCadeState buttons = Buttons(self, touches);
    EAGLView *view = GetEAGLView();

    NSLog(@"cancelled, up: %@", ButtonsDescription(buttons));
    [view buttonUp:buttons];

    _previous &= ~buttons;
    NSLog(@"state is now: %@", ButtonsDescription(_previous));
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


__attribute__((constructor))
static void ControlsInitialize(void)
{
    NSLog(@"booted!");

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [notificationCenter addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:mainQueue usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIScreen *mainScreen = [UIScreen mainScreen];
            UIWindow *window = [[UIWindow alloc] initWithFrame:mainScreen.bounds];
            window.windowLevel = 2000.0;

            ControlViewController *viewController = [[ControlViewController alloc] init];
            window.rootViewController = viewController;

            [window makeKeyAndVisible];
            NSLog(@"added overlay %@ %@", window, viewController);
        });
    }];
}

