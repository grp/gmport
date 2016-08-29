/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Control.h"
#import "ControlView.h"
#import "input.h"


@interface ControlViewController : UIViewController

- (instancetype)initWithButtons:(NSSet<Button *> *)buttons;
@property(nonatomic, copy, readonly) NSSet<Button *> *buttons;

@end

@implementation ControlViewController {
    NSMapTable<ButtonView *, Button *> *_buttonViews;
    PadView *_padView;
    NSMutableSet<Button *> *_down;
}

- (instancetype)initWithButtons:(NSSet<Button *> *)buttons
{
    if (self = [super init]) {
        _buttons = [buttons copy];
        _down = [NSMutableSet set];
    }

    return self;
}

- (void)loadView
{
    [super loadView];

    self.view.multipleTouchEnabled = YES;

    _padView = [[PadView alloc] init];
    [self.view addSubview:_padView];

    NSMapTable<ButtonView *, Button *> *buttonViews = [NSMapTable strongToStrongObjectsMapTable];
    for (Button *button in _buttons) {
        ButtonView *buttonView = [[ButtonView alloc] init];
        buttonView.title = button.name;
        [self.view addSubview:buttonView];
        [buttonViews setObject:button forKey:buttonView];
    }
    _buttonViews = buttonViews;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    _padView.bounds = CGRectMake(0, 0, 180, 180);
    _padView.center = CGPointMake(120, 300);

    CGRect bounds = self.view.bounds;
    for (ButtonView *buttonView in _buttonViews) {
        Button *button = [_buttonViews objectForKey:buttonView];

        CGPoint anchor = CGPointMake(button.anchor.x * bounds.size.width, button.anchor.y * bounds.size.height);
        CGPoint center = CGPointMake(anchor.x + button.center.dx, anchor.y + button.center.dy);
        CGRect bounds = CGRectMake(0, 0, button.size.width, button.size.height);

        buttonView.bounds = bounds;
        buttonView.center = center;
    }
}

static void Down(NSSet<Button *> *buttons)
{
    for (Button *button in buttons) {
        input_key_down(button.keycode);
    }
}

static void Up(NSSet<Button *> *buttons)
{
    for (Button *button in buttons) {
        input_key_up(button.keycode);
    }
}

- (NSSet<Button *> *)buttonsForTouches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableSet<Button *> *buttons = [NSMutableSet set];

    for (UITouch *touch in touches) {
        for (ButtonView *buttonView in _buttonViews) {
            CGPoint location = [touch locationInView:buttonView];
            if ([buttonView pointInside:location withEvent:event]) {
                Button *button = [_buttonViews objectForKey:buttonView];
                [buttons addObject:button];
                break;
            }
        }
    }

    return buttons;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet<Button *> *buttons = [self buttonsForTouches:touches withEvent:event];

    Down(buttons);

    [_down unionSet:buttons];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet<Button *> *buttons = [self buttonsForTouches:touches withEvent:event];

    NSMutableSet<Button *> *up = [_down mutableCopy];
    [up minusSet:buttons];
    Up(up);

    NSMutableSet<Button *> *down = [buttons mutableCopy];
    [down minusSet:_down];
    Down(down);

    [_down unionSet:down];
    [_down minusSet:up];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet<Button *> *buttons = [self buttonsForTouches:touches withEvent:event];

    Up(buttons);

    [_down minusSet:buttons];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet<Button *> *buttons = [self buttonsForTouches:touches withEvent:event];

    Up(buttons);

    [_down minusSet:buttons];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)interfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end


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

            ControlViewController *viewController = [[ControlViewController alloc] initWithButtons:buttons];
            window.rootViewController = viewController;

            [window makeKeyAndVisible];
        });
    }];
}

