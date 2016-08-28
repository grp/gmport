/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#ifndef __INPUT_H
#define __INPUT_H

/*
 * Supported input keycodes.
 */
enum input_keycode {
    input_keycode_a = 'A',
    input_keycode_b = 'B',
    input_keycode_c = 'C',
    input_keycode_d = 'D',
    input_keycode_e = 'E',
    input_keycode_f = 'F',
    input_keycode_g = 'G',
    input_keycode_h = 'H',
    input_keycode_i = 'I',
    input_keycode_j = 'J',
    input_keycode_k = 'K',
    input_keycode_l = 'L',
    input_keycode_m = 'M',
    input_keycode_n = 'N',
    input_keycode_o = 'O',
    input_keycode_p = 'P',
    input_keycode_q = 'Q',
    input_keycode_r = 'R',
    input_keycode_s = 'S',
    input_keycode_t = 'T',
    input_keycode_u = 'U',
    input_keycode_v = 'V',
    input_keycode_w = 'W',
    input_keycode_x = 'X',
    input_keycode_y = 'Y',
    input_keycode_z = 'Z',

    input_keycode_left = 0x25,
    input_keycode_up = 0x26,
    input_keycode_right = 0x27,
    input_keycode_down = 0x28,
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
