/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
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

