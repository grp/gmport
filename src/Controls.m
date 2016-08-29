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

- (instancetype)initWithButtons:(NSSet<Button *> *)buttons pads:(NSSet<Pad *> *)pads;
@property(nonatomic, copy, readonly) NSSet<Button *> *buttons;
@property(nonatomic, copy, readonly) NSSet<Pad *> *pads;

@end

@implementation ControlViewController {
    NSSet<ButtonView<Button *> *> *_buttonViews;
    NSSet<PadView<Pad *> *> *_padViews;
    NSMapTable<UITouch *, NSSet<NSNumber *> *> *_down;
}

- (instancetype)initWithButtons:(NSSet<Button *> *)buttons pads:(NSSet<Pad *> *)pads
{
    if (self = [super init]) {
        _buttons = [buttons copy];
        _pads = [pads copy];

        NSPointerFunctionsOptions keyOptions = (NSPointerFunctionsOpaqueMemory | NSPointerFunctionsOpaquePersonality);
        NSPointerFunctionsOptions valueOptions = (NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPointerPersonality);
        _down = [NSMapTable mapTableWithKeyOptions:keyOptions valueOptions:valueOptions];
    }

    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.multipleTouchEnabled = YES;

    NSMutableSet<PadView<Pad *> *> *padViews = [NSMutableSet set];
    for (Pad *pad in _pads) {
        PadView<Pad *> *padView = [[PadView alloc] init];
        padView.value = pad;

        [self.view addSubview:padView];
        [padViews addObject:padView];
    }
    _padViews = padViews;

    NSMutableSet<ButtonView<Button *> *> *buttonViews = [NSMutableSet set];
    for (Button *button in _buttons) {
        ButtonView<Button *> *buttonView = [[ButtonView alloc] init];
        buttonView.title = button.name;
        buttonView.value = button;

        [self.view addSubview:buttonView];
        [buttonViews addObject:buttonView];
    }
    _buttonViews = buttonViews;
}

- (void)_layoutControlView:(UIView *)controlView forControl:(Control *)control
{
    CGPoint anchor = CGPointMake(control.anchor.x * self.view.bounds.size.width, control.anchor.y * self.view.bounds.size.height);
    CGPoint center = CGPointMake(anchor.x + control.center.dx, anchor.y + control.center.dy);
    CGRect bounds = CGRectMake(0, 0, control.size.width, control.size.height);

    controlView.bounds = bounds;
    controlView.center = center;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    for (ButtonView<Button *> *buttonView in _buttonViews) {
        [self _layoutControlView:buttonView forControl:buttonView.value];
    }

    for (PadView<Pad *> *padView in _padViews) {
        [self _layoutControlView:padView forControl:padView.value];
    }
}

- (NSSet<NSNumber *> *)keycodesForTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSMutableSet<NSNumber *> *keycodes = [NSMutableSet set];

    /* Pressed buttons. */
    for (ButtonView<Button *> *buttonView in _buttonViews) {
        CGPoint location = [touch locationInView:buttonView];
        if ([buttonView pointInside:location withEvent:event]) {
            [keycodes addObject:@(buttonView.value.keycode)];
        }
    }

    /* Pressed directions, including diagonals. */
    for (PadView<Pad *> *padView in _padViews) {
        CGPoint location = [touch locationInView:padView];
        if ([padView pointInsideUp:location withEvent:event]) {
            [keycodes addObject:@(padView.value.upKeycode)];
        }
        if ([padView pointInsideLeft:location withEvent:event]) {
            [keycodes addObject:@(padView.value.leftKeycode)];
        }
        if ([padView pointInsideDown:location withEvent:event]) {
            [keycodes addObject:@(padView.value.downKeycode)];
        }
        if ([padView pointInsideRight:location withEvent:event]) {
            [keycodes addObject:@(padView.value.rightKeycode)];
        }
    }

    return keycodes;
}

- (void)handleTouches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event mutations:(void (^)(UITouch *, UIEvent *))mutations
{
    /* All keycodes down before mutation. */
    NSMutableSet<NSNumber *> *before = [NSMutableSet set];
    for (UITouch *touch in _down) {
        NSSet<NSNumber *> *down = [_down objectForKey:touch];
        [before unionSet:down];
    }

    /* Apply mutations. */
    for (UITouch *touch in touches) {
        mutations(touch, event);
    }

    /* All keycodes down after mutation. */
    NSMutableSet<NSNumber *> *after = [NSMutableSet set];
    for (UITouch *touch in _down) {
        NSSet<NSNumber *> *down = [_down objectForKey:touch];
        [after unionSet:down];
    }

    /* Determine released keycodes. */
    NSMutableSet<NSNumber *> *up = [before mutableCopy];
    [up minusSet:after];
    for (NSNumber *keycode in up) {
        input_key_up(keycode.intValue);
    }

    /* Determine pressed keycodes. */
    NSMutableSet<NSNumber *> *down = [after mutableCopy];
    [down minusSet:before];
    for (NSNumber *keycode in down) {
        input_key_down(keycode.intValue);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self handleTouches:touches withEvent:event mutations:^(UITouch *touch, UIEvent *event) {
        /* Add new touch with appropriate keycodes. */
        NSSet<NSNumber *> *keycodes = [self keycodesForTouch:touch withEvent:event];
        [_down setObject:keycodes forKey:touch];
    }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self handleTouches:touches withEvent:event mutations:^(UITouch *touch, UIEvent *event) {
        /* Update each changed touch for new keycodes. */
        NSSet<NSNumber *> *keycodes = [self keycodesForTouch:touch withEvent:event];
        [_down setObject:keycodes forKey:touch];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self handleTouches:touches withEvent:event mutations:^(UITouch *touch, UIEvent *event) {
        /* Remove touch. */
        [_down removeObjectForKey:touch];
    }];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self handleTouches:touches withEvent:event mutations:^(UITouch *touch, UIEvent *event) {
        /* Remove touch. */
        [_down removeObjectForKey:touch];
    }];
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

