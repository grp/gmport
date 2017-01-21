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

#ifndef __INPUT_H
#define __INPUT_H

/*
 * Supported input keycodes.
 */
enum input_keycode {
    input_keycode_backspace = '\b', /* 0x08 */
    input_keycode_tab = '\t', /* 0x09 */
    input_keycode_enter = '\r', /* 0x0d */
    input_keycode_shift = 0x10,
    input_keycode_control = 0x11,
    input_keycode_alt = 0x12,
    input_keycode_pause = 0x13,
    input_keycode_capslock = 0x14,
    input_keycode_space = ' ', /* 0x20 */

    input_keycode_pageup = 0x21,
    input_keycode_pagedown = 0x22,

    input_keycode_end = 0x23,
    input_keycode_home = 0x24,

    input_keycode_left = 0x25,
    input_keycode_up = 0x26,
    input_keycode_right = 0x27,
    input_keycode_down = 0x28,

    input_keycode_insert = 0x2d,
    input_keycode_delete = 0x2e,

    input_keycode_zero = '0', /* 0x30 */
    input_keycode_one = '1', /* 0x31 */
    input_keycode_two = '2', /* 0x32 */
    input_keycode_three = '3', /* 0x33 */
    input_keycode_four = '4', /* 0x34 */
    input_keycode_five = '5', /* 0x35 */
    input_keycode_six = '6', /* 0x36 */
    input_keycode_seven = '7', /* 0x37 */
    input_keycode_eight = '8', /* 0x38 */
    input_keycode_nine = '9', /* 0x39 */

    input_keycode_a = 'A', /* 0x41 */
    input_keycode_b = 'B', /* 0x42 */
    input_keycode_c = 'C', /* 0x43 */
    input_keycode_d = 'D', /* 0x44 */
    input_keycode_e = 'E', /* 0x45 */
    input_keycode_f = 'F', /* 0x46 */
    input_keycode_g = 'G', /* 0x47 */
    input_keycode_h = 'H', /* 0x48 */
    input_keycode_i = 'I', /* 0x49 */
    input_keycode_j = 'J', /* 0x50 */
    input_keycode_k = 'K', /* 0x51 */
    input_keycode_l = 'L', /* 0x52 */
    input_keycode_m = 'M', /* 0x53 */
    input_keycode_n = 'N', /* 0x54 */
    input_keycode_o = 'O', /* 0x55 */
    input_keycode_p = 'P', /* 0x56 */
    input_keycode_q = 'Q', /* 0x57 */
    input_keycode_r = 'R', /* 0x58 */
    input_keycode_s = 'S', /* 0x59 */
    input_keycode_t = 'T', /* 0x60 */
    input_keycode_u = 'U', /* 0x61 */
    input_keycode_v = 'V', /* 0x62 */
    input_keycode_w = 'W', /* 0x63 */
    input_keycode_x = 'X', /* 0x64 */
    input_keycode_y = 'Y', /* 0x65 */
    input_keycode_z = 'Z', /* 0x66 */

    input_keycode_numpad_zero = 0x60,
    input_keycode_numpad_one = 0x61,
    input_keycode_numpad_two = 0x62,
    input_keycode_numpad_three = 0x63,
    input_keycode_numpad_four = 0x64,
    input_keycode_numpad_five = 0x65,
    input_keycode_numpad_six = 0x66,
    input_keycode_numpad_seven = 0x67,
    input_keycode_numpad_eight = 0x68,
    input_keycode_numpad_nine = 0x69,
    input_keycode_numpad_star = 0x6a,
    input_keycode_numpad_plus = 0x6b,
    input_keycode_numpad_minus = 0x6d,
    input_keycode_numpad_dot = 0x6e,
    input_keycode_numpad_slash = 0x6f,
};

/*
 * Send a keyboard down event.
 */
void input_key_down(enum input_keycode key);

/*
 * Send a keyboard up event.
 */
void input_key_up(enum input_keycode key);

#endif /* __INPUT_H */
