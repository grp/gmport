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

#import "input.h"


/*
 * An input key.
 */
@interface InputKey : NSObject

/* Create an input key. */
- (instancetype)initWithIdentifier:(NSString *)identifier keycode:(enum input_keycode)keycode;

/* The key identifier. */
@property(nonatomic, copy, readonly) NSString *identifier;

/* The key's keycode. */
@property(nonatomic, assign, readonly) enum input_keycode keycode;

@end


/*
 * A collection of input keys.
 */
@interface InputKeys : NSObject

/* Complete set of default input keys. */
+ (instancetype)defaultKeys;

/* All keys in the collection. */
- (NSSet<InputKey *> *)allKeys;

/* The key with the given identifier. */
- (InputKey *)keyWithIdentifier:(NSString *)identifier;

/* The key with the given keycode. */
- (InputKey *)keyWithKeycode:(enum input_keycode)keycode;

@end

