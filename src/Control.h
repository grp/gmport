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

