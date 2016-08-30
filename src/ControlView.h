/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/*
 * A view that shows a control.
 */
@interface ControlView<ValueType> : UIView

/* An opaque value held by the view. */
@property(nonatomic, strong) ValueType value;

/* Outsets around the view to accept touches. */
@property(nonatomic, assign) UIEdgeInsets hitTestSlop;

@end


/*
 * A view that shows a single button.
 */
@interface ButtonView<ValueType> : ControlView<ValueType>

/* The text shown on the button. */
@property(nonatomic, copy) NSString *title;

@end


/*
 * A view showing a directional selector.
 */
@interface PadView<ValueType> : ControlView<ValueType>

/* If a point is inside a specific direction. */
- (BOOL)pointInsideUp:(CGPoint)point withEvent:(UIEvent *)event;
- (BOOL)pointInsideLeft:(CGPoint)point withEvent:(UIEvent *)event;
- (BOOL)pointInsideDown:(CGPoint)point withEvent:(UIEvent *)event;
- (BOOL)pointInsideRight:(CGPoint)point withEvent:(UIEvent *)event;

@end

