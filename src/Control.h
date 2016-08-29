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
@interface Button : NSObject

/* Create a button. */
- (instancetype)initWithName:(NSString *)name keycode:(enum input_keycode)keycode center:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size;

/* The user-facing button title. */
@property(nonatomic, copy, readonly) NSString *name;

/* The keycode when the button is pressed. */
@property(nonatomic, assign, readonly) enum input_keycode keycode;

/* The offset from the anchor to the center, in points. */
@property(nonatomic, assign, readonly) CGVector center;

/* Where the button is placed relative to, in unit coordinates. */
@property(nonatomic, assign, readonly) CGPoint anchor;

/* The size of the button, in points. */
@property(nonatomic, assign, readonly) CGSize size;

@end

