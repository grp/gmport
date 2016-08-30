/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>


/*
 * Describes an abstract control.
 */
@interface Control<ValueType> : NSObject

/* Create a control. */
- (instancetype)initWithCenter:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size slop:(UIEdgeInsets)slop;

/* The offset from the anchor to the center, in points. */
@property(nonatomic, assign, readonly) CGVector center;

/* Where the control is placed relative to, in unit coordinates. */
@property(nonatomic, assign, readonly) CGPoint anchor;

/* The size of the control, in points. */
@property(nonatomic, assign, readonly) CGSize size;

/* The touch slop applied to the view. */
@property(nonatomic, assign, readonly) UIEdgeInsets slop;

@end


/*
 * Describes a pressable button.
 */
@interface Button<ValueType> : Control<ValueType>

/* Create a button. */
- (instancetype)initWithName:(NSString *)name value:(ValueType)value center:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size slop:(UIEdgeInsets)slop;

/* The user-facing button title. */
@property(nonatomic, copy, readonly) NSString *name;

/* The value when the button is pressed. */
@property(nonatomic, assign, readonly) ValueType value;

@end


/*
 * Describes a directional pad.
 */
@interface Pad<ValueType> : Control<ValueType>

/* Create a pad. */
- (instancetype)initWithUpValue:(ValueType)up leftValue:(ValueType)left downValue:(ValueType)down rightValue:(ValueType)right center:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size slop:(UIEdgeInsets)slop;

/* The value when up is pressed. */
@property(nonatomic, assign, readonly) ValueType upValue;

/* The value when left is pressed. */
@property(nonatomic, assign, readonly) ValueType leftValue;

/* The value when down is pressed. */
@property(nonatomic, assign, readonly) ValueType downValue;

/* The value when right is pressed. */
@property(nonatomic, assign, readonly) ValueType rightValue;

@end

