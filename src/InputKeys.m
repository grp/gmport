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

#import "InputKeys.h"

@implementation InputKey

- (instancetype)initWithIdentifier:(NSString *)identifier keycode:(enum input_keycode)keycode
{
    if (self = [super init]) {
        _identifier = [identifier copy];
        _keycode = keycode;
    }

    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[InputKey class]]) {
        return NO;
    }

    InputKey *key = (InputKey *)object;
    return (_identifier == key.identifier);
}

- (NSUInteger)hash
{
    return [_identifier hash];
}

@end

@implementation InputKeys {
    NSSet<InputKey *> *_inputKeys;
    NSDictionary<NSString *, InputKey *> *_identifierInputKeys;
    NSDictionary<NSNumber *, InputKey *> *_keycodeInputKeys;
}

- (NSSet<InputKey *> *)allKeys
{
    return _inputKeys;
}

- (InputKey *)keyWithIdentifier:(NSString *)identifier
{
    return _identifierInputKeys[identifier];
}

- (InputKey *)keyWithKeycode:(enum input_keycode)keycode
{
    return _keycodeInputKeys[@(keycode)];
}

+ (instancetype)defaultKeys
{
    static InputKeys *defaultKeys = nil;

    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray<InputKey *> *inputKeys = @[
            [[InputKey alloc] initWithIdentifier:@"backspace" keycode:input_keycode_backspace],
            [[InputKey alloc] initWithIdentifier:@"tab" keycode:input_keycode_tab],
            [[InputKey alloc] initWithIdentifier:@"enter" keycode:input_keycode_enter],
            [[InputKey alloc] initWithIdentifier:@"shift" keycode:input_keycode_shift],
            [[InputKey alloc] initWithIdentifier:@"control" keycode:input_keycode_control],
            [[InputKey alloc] initWithIdentifier:@"alt" keycode:input_keycode_alt],
            [[InputKey alloc] initWithIdentifier:@"pause" keycode:input_keycode_pause],
            [[InputKey alloc] initWithIdentifier:@"capslock" keycode:input_keycode_capslock],
            [[InputKey alloc] initWithIdentifier:@"space" keycode:input_keycode_space],

            [[InputKey alloc] initWithIdentifier:@"pageup" keycode:input_keycode_pageup],
            [[InputKey alloc] initWithIdentifier:@"pagedown" keycode:input_keycode_pagedown],

            [[InputKey alloc] initWithIdentifier:@"end" keycode:input_keycode_end],
            [[InputKey alloc] initWithIdentifier:@"home" keycode:input_keycode_home],

            [[InputKey alloc] initWithIdentifier:@"left" keycode:input_keycode_left],
            [[InputKey alloc] initWithIdentifier:@"up" keycode:input_keycode_up],
            [[InputKey alloc] initWithIdentifier:@"right" keycode:input_keycode_right],
            [[InputKey alloc] initWithIdentifier:@"down" keycode:input_keycode_down],

            [[InputKey alloc] initWithIdentifier:@"insert" keycode:input_keycode_insert],
            [[InputKey alloc] initWithIdentifier:@"delete" keycode:input_keycode_delete],

            [[InputKey alloc] initWithIdentifier:@"0" keycode:input_keycode_zero],
            [[InputKey alloc] initWithIdentifier:@"1" keycode:input_keycode_one],
            [[InputKey alloc] initWithIdentifier:@"2" keycode:input_keycode_two],
            [[InputKey alloc] initWithIdentifier:@"3" keycode:input_keycode_three],
            [[InputKey alloc] initWithIdentifier:@"4" keycode:input_keycode_four],
            [[InputKey alloc] initWithIdentifier:@"5" keycode:input_keycode_five],
            [[InputKey alloc] initWithIdentifier:@"6" keycode:input_keycode_six],
            [[InputKey alloc] initWithIdentifier:@"7" keycode:input_keycode_seven],
            [[InputKey alloc] initWithIdentifier:@"8" keycode:input_keycode_eight],
            [[InputKey alloc] initWithIdentifier:@"9" keycode:input_keycode_nine],

            [[InputKey alloc] initWithIdentifier:@"a" keycode:input_keycode_a],
            [[InputKey alloc] initWithIdentifier:@"b" keycode:input_keycode_b],
            [[InputKey alloc] initWithIdentifier:@"c" keycode:input_keycode_c],
            [[InputKey alloc] initWithIdentifier:@"d" keycode:input_keycode_d],
            [[InputKey alloc] initWithIdentifier:@"e" keycode:input_keycode_e],
            [[InputKey alloc] initWithIdentifier:@"f" keycode:input_keycode_f],
            [[InputKey alloc] initWithIdentifier:@"g" keycode:input_keycode_g],
            [[InputKey alloc] initWithIdentifier:@"h" keycode:input_keycode_h],
            [[InputKey alloc] initWithIdentifier:@"i" keycode:input_keycode_i],
            [[InputKey alloc] initWithIdentifier:@"j" keycode:input_keycode_j],
            [[InputKey alloc] initWithIdentifier:@"k" keycode:input_keycode_k],
            [[InputKey alloc] initWithIdentifier:@"l" keycode:input_keycode_l],
            [[InputKey alloc] initWithIdentifier:@"m" keycode:input_keycode_m],
            [[InputKey alloc] initWithIdentifier:@"n" keycode:input_keycode_n],
            [[InputKey alloc] initWithIdentifier:@"o" keycode:input_keycode_o],
            [[InputKey alloc] initWithIdentifier:@"p" keycode:input_keycode_p],
            [[InputKey alloc] initWithIdentifier:@"q" keycode:input_keycode_q],
            [[InputKey alloc] initWithIdentifier:@"r" keycode:input_keycode_r],
            [[InputKey alloc] initWithIdentifier:@"s" keycode:input_keycode_s],
            [[InputKey alloc] initWithIdentifier:@"t" keycode:input_keycode_t],
            [[InputKey alloc] initWithIdentifier:@"u" keycode:input_keycode_u],
            [[InputKey alloc] initWithIdentifier:@"v" keycode:input_keycode_v],
            [[InputKey alloc] initWithIdentifier:@"w" keycode:input_keycode_w],
            [[InputKey alloc] initWithIdentifier:@"x" keycode:input_keycode_x],
            [[InputKey alloc] initWithIdentifier:@"y" keycode:input_keycode_y],
            [[InputKey alloc] initWithIdentifier:@"z" keycode:input_keycode_z],

            [[InputKey alloc] initWithIdentifier:@"numpad-0" keycode:input_keycode_numpad_zero],
            [[InputKey alloc] initWithIdentifier:@"numpad-1" keycode:input_keycode_numpad_one],
            [[InputKey alloc] initWithIdentifier:@"numpad-2" keycode:input_keycode_numpad_two],
            [[InputKey alloc] initWithIdentifier:@"numpad-3" keycode:input_keycode_numpad_three],
            [[InputKey alloc] initWithIdentifier:@"numpad-4" keycode:input_keycode_numpad_four],
            [[InputKey alloc] initWithIdentifier:@"numpad-5" keycode:input_keycode_numpad_five],
            [[InputKey alloc] initWithIdentifier:@"numpad-6" keycode:input_keycode_numpad_six],
            [[InputKey alloc] initWithIdentifier:@"numpad-7" keycode:input_keycode_numpad_seven],
            [[InputKey alloc] initWithIdentifier:@"numpad-8" keycode:input_keycode_numpad_eight],
            [[InputKey alloc] initWithIdentifier:@"numpad-9" keycode:input_keycode_numpad_nine],
            [[InputKey alloc] initWithIdentifier:@"numpad-*" keycode:input_keycode_numpad_star],
            [[InputKey alloc] initWithIdentifier:@"numpad-+" keycode:input_keycode_numpad_plus],
            [[InputKey alloc] initWithIdentifier:@"numpad--" keycode:input_keycode_numpad_minus],
            [[InputKey alloc] initWithIdentifier:@"numpad-." keycode:input_keycode_numpad_dot],
            [[InputKey alloc] initWithIdentifier:@"numpad-/" keycode:input_keycode_numpad_slash],
        ];

        NSMutableDictionary<NSString *, InputKey *> *identifierInputKeys = [NSMutableDictionary dictionary];
        NSMutableDictionary<NSNumber *, InputKey *> *keycodeInputKeys = [NSMutableDictionary dictionary];

        for (InputKey *inputKey in inputKeys) {
            identifierInputKeys[inputKey.identifier] = inputKey;
            keycodeInputKeys[@(inputKey.keycode)] = inputKey;
        }

        defaultKeys = [[InputKeys alloc] init];
        defaultKeys->_inputKeys = [NSSet setWithArray:inputKeys];
        defaultKeys->_identifierInputKeys = identifierInputKeys;
        defaultKeys->_keycodeInputKeys = keycodeInputKeys;
    });

    return defaultKeys;
}

@end

