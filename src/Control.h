/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "input.h"


/*
 * A single button shown on the screen.
 */
@interface Control : NSObject

/* Create a control. */
- (instancetype)initWithCenter:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size;

/* The offset from the anchor to the center, in points. */
@property(nonatomic, assign, readonly) CGVector center;

/* Where the control is placed relative to, in unit coordinates. */
@property(nonatomic, assign, readonly) CGPoint anchor;

/* The size of the control, in points. */
@property(nonatomic, assign, readonly) CGSize size;

@end


@interface Button : Control

/* Create a button. */
- (instancetype)initWithName:(NSString *)name keycode:(enum input_keycode)keycode center:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size;

/* The user-facing button title. */
@property(nonatomic, copy, readonly) NSString *name;

/* The keycode when the button is pressed. */
@property(nonatomic, assign, readonly) enum input_keycode keycode;

@end


@interface Pad : Control

/* Create a pad. */
- (instancetype)initWithUpKeycode:(enum input_keycode)up leftKeycode:(enum input_keycode)left downKeycode:(enum input_keycode)down rightKeycode:(enum input_keycode)right center:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size;

/* The keycode when up is pressed. */
@property(nonatomic, assign, readonly) enum input_keycode upKeycode;

/* The keycode when left is pressed. */
@property(nonatomic, assign, readonly) enum input_keycode leftKeycode;

/* The keycode when down is pressed. */
@property(nonatomic, assign, readonly) enum input_keycode downKeycode;

/* The keycode when right is pressed. */
@property(nonatomic, assign, readonly) enum input_keycode rightKeycode;

@end

