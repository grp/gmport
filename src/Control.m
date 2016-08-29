/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import "Control.h"

/* Erased generic parameter. */
typedef id ValueType;


@implementation Control

- (instancetype)initWithCenter:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size
{
    if (self = [super init]) {
        _center = center;
        _anchor = anchor;
        _size = size;
    }

    return self;
}

@end


@implementation Button

- (instancetype)initWithName:(NSString *)name value:(ValueType)value center:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size
{
    if (self = [super initWithCenter:center anchor:anchor size:size]) {
        _name = [name copy];
        _value = value;
    }

    return self;
}

@end


@implementation Pad

- (instancetype)initWithUpValue:(ValueType)up leftValue:(ValueType)left downValue:(ValueType)down rightValue:(ValueType)right center:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size
{
    if (self = [super initWithCenter:center anchor:anchor size:size]) {
        _upValue = up;
        _leftValue = left;
        _downValue = down;
        _rightValue = right;
    }

    return self;
}

@end

