/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import "Control.h"


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

- (instancetype)initWithName:(NSString *)name keycode:(enum input_keycode)keycode center:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size
{
    if (self = [super initWithCenter:center anchor:anchor size:size]) {
        _name = [name copy];
        _keycode = keycode;
    }

    return self;
}

@end


@implementation Pad

- (instancetype)initWithUpKeycode:(enum input_keycode)up leftKeycode:(enum input_keycode)left downKeycode:(enum input_keycode)down rightKeycode:(enum input_keycode)right center:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size
{
    if (self = [super initWithCenter:center anchor:anchor size:size]) {
        _upKeycode = up;
        _leftKeycode = left;
        _downKeycode = down;
        _rightKeycode = right;
    }

    return self;
}

@end

