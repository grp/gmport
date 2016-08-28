/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#ifndef __INTERPOSE_H
#define __INTERPOSE_H

#define __ConcatenateInternal(x, y) x##y
#define __Concatenate(x, y) __ConcatenateInternal(x, y)

/*
 * Interpose a function, replacing with a target. The original
 * function name can be used to call the original implementation.
 */
#define Interpose(_target, _original) \
    __attribute__((used)) \
    __attribute__((section("__DATA,__interpose"))) \
    static struct { \
        const void *target; \
        const void *original; \
    } __Concatenate(__interpose_, __COUNTER__) = { \
        .target = _target, \
        .original = _original, \
    }

#endif /* __INTERPOSE_H */
