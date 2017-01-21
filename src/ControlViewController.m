/*
 * Copyright (c) 2016-2017, Grant Paul
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ControlViewController.h"

/* Erased generic parameter. */
typedef id ValueType;


@implementation ControlViewController {
    NSSet<ButtonView<Button<ValueType> *> *> *_buttonViews;
    NSSet<PadView<Pad<ValueType> *> *> *_padViews;
    NSMapTable<UITouch *, NSSet<ValueType> *> *_down;
}

- (instancetype)initWithButtons:(NSSet<Button<ValueType> *> *)buttons pads:(NSSet<Pad<ValueType> *> *)pads
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

    NSMutableSet<PadView<Pad<ValueType> *> *> *padViews = [NSMutableSet set];
    for (Pad<ValueType> *pad in _pads) {
        PadView<Pad<ValueType> *> *padView = [[PadView alloc] init];
        padView.value = pad;

        [self.view addSubview:padView];
        [padViews addObject:padView];
    }
    _padViews = padViews;

    NSMutableSet<ButtonView<Button<ValueType> *> *> *buttonViews = [NSMutableSet set];
    for (Button<ValueType> *button in _buttons) {
        ButtonView<Button<ValueType> *> *buttonView = [[ButtonView alloc] init];
        buttonView.title = button.name;
        buttonView.value = button;

        [self.view addSubview:buttonView];
        [buttonViews addObject:buttonView];
    }
    _buttonViews = buttonViews;
}

- (void)_layoutControlView:(ControlView *)controlView forControl:(Control *)control
{
    CGPoint anchor = CGPointMake(control.anchor.x * self.view.bounds.size.width, control.anchor.y * self.view.bounds.size.height);
    CGPoint center = CGPointMake(anchor.x + control.center.dx, anchor.y + control.center.dy);
    CGRect bounds = CGRectMake(0, 0, control.size.width, control.size.height);

    controlView.bounds = bounds;
    controlView.center = center;
    controlView.hitTestSlop = control.slop;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    for (ButtonView<Button<ValueType> *> *buttonView in _buttonViews) {
        [self _layoutControlView:buttonView forControl:buttonView.value];
    }

    for (PadView<Pad<ValueType> *> *padView in _padViews) {
        [self _layoutControlView:padView forControl:padView.value];
    }
}

- (NSSet<ValueType> *)valuesForTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSMutableSet<ValueType> *values = [NSMutableSet set];

    /* Pressed buttons. */
    for (ButtonView<Button<ValueType> *> *buttonView in _buttonViews) {
        CGPoint location = [touch locationInView:buttonView];
        if ([buttonView pointInside:location withEvent:event]) {
            [values addObject:buttonView.value.value];
        }
    }

    /* Pressed directions, including diagonals. */
    for (PadView<Pad<ValueType> *> *padView in _padViews) {
        CGPoint location = [touch locationInView:padView];
        if ([padView pointInsideUp:location withEvent:event]) {
            [values addObject:padView.value.upValue];
        }
        if ([padView pointInsideLeft:location withEvent:event]) {
            [values addObject:padView.value.leftValue];
        }
        if ([padView pointInsideDown:location withEvent:event]) {
            [values addObject:padView.value.downValue];
        }
        if ([padView pointInsideRight:location withEvent:event]) {
            [values addObject:padView.value.rightValue];
        }
    }

    return values;
}

- (void)handleTouches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event mutations:(void (^)(UITouch *, UIEvent *))mutations
{
    /* All values down before mutation. */
    NSMutableSet<ValueType> *before = [NSMutableSet set];
    for (UITouch *touch in _down) {
        NSSet<ValueType> *down = [_down objectForKey:touch];
        [before unionSet:down];
    }

    /* Apply mutations. */
    for (UITouch *touch in touches) {
        mutations(touch, event);
    }

    /* All values down after mutation. */
    NSMutableSet<ValueType> *after = [NSMutableSet set];
    for (UITouch *touch in _down) {
        NSSet<ValueType> *down = [_down objectForKey:touch];
        [after unionSet:down];
    }

    /* Determine released values. */
    NSMutableSet<ValueType> *up = [before mutableCopy];
    [up minusSet:after];
    if (_releaseHandler != nil) {
        for (ValueType value in up) {
            _releaseHandler(value);
        }
    }

    /* Determine pressed values. */
    NSMutableSet<ValueType> *down = [after mutableCopy];
    [down minusSet:before];
    if (_pressHandler != nil) {
        for (ValueType value in down) {
            _pressHandler(value);
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self handleTouches:touches withEvent:event mutations:^(UITouch *touch, UIEvent *event) {
        /* Add new touch with appropriate values. */
        NSSet<ValueType> *values = [self valuesForTouch:touch withEvent:event];
        [_down setObject:values forKey:touch];
    }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self handleTouches:touches withEvent:event mutations:^(UITouch *touch, UIEvent *event) {
        /* Update each changed touch for new values. */
        NSSet<ValueType> *values = [self valuesForTouch:touch withEvent:event];
        [_down setObject:values forKey:touch];
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end

