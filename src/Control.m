/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import "Control.h"

@implementation Button

- (instancetype)initWithName:(NSString *)name keycode:(enum input_keycode)keycode center:(CGVector)center anchor:(CGPoint)anchor size:(CGSize)size
{
    if (self = [super init]) {
        _name = [name copy];
        _keycode = keycode;
        _center = center;
        _anchor = anchor;
        _size = size;
    }

    return self;
}

@end

