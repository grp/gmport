/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#include "input.h"

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include "Interpose.h"

struct input_record {
    uint16_t lastchar;
    uint8_t laststring[0x802]; // maybe uint16_t[0x400] + 2-byte length?

    uint32_t keyboard_lastkey;
    uint32_t keyboard_key;
    uint8_t keyboard_down[0x100];
    uint8_t keyboard_released[0x100];
    uint8_t keyboard_pressed[0x100];

    uint8_t mouse_lastbutton[0x28];
    uint8_t mouse_button[0x28];
    uint8_t mouse_down[0x1E];
    uint8_t mouse_pressed[0x1E];
    uint8_t mouse_released[0x1E];

    uint8_t mousewheel_down[0xA];
    uint8_t mousewheel_up[0xA];

    uint64_t unk9; // appears unused
    uint32_t mouse_x;
    uint32_t mouse_y;
} __attribute__((packed));

struct input_context {
    struct input_record record;
    ptrdiff_t offset;
};

static struct input_context global_context;

void input_key_down(enum input_keycode keycode)
{
    char key = (char)keycode;
    syslog(LOG_WARNING, "key down: %x %c", key, key);
    global_context.record.keyboard_down[key] = 1;
    global_context.record.keyboard_pressed[key] = 1;
    global_context.record.keyboard_released[key] = 0;
    global_context.record.keyboard_key = key; // TODO what if multiple?
}

void input_key_up(enum input_keycode keycode)
{
    char key = (char)keycode;
    syslog(LOG_WARNING, "key up: %x %c", key, key);
    global_context.record.keyboard_down[key] = 0;
    global_context.record.keyboard_pressed[key] = 0;
    global_context.record.keyboard_released[key] = 1;
    global_context.record.keyboard_key = 0; // TODO what if multiple?
}

static void input_init(void *cookie)
{
    struct input_context *context = (struct input_context *)cookie;
    memset(&context->record, 0, sizeof(context->record));
    context->offset = 0;
}

static int input_read(void *cookie, char *buffer, int size)
{
    struct input_context *context = (struct input_context *)cookie;

    if (context->offset + size > sizeof(context->record)) {
        /* Error: reading past the end of the record. */
        syslog(LOG_ERR, "error: reading past end of input");
        return -1;
    }

    /* Read from input buffer. */
    uintptr_t source = (uintptr_t)&context->record + context->offset;
    memcpy(buffer, (void *)source, size);
    context->offset += size;

    /* Read a whole input. */
    if (context->offset >= sizeof(context->record)) {
        /* Reset edge pulses. */
        memset(&context->record.keyboard_pressed, 0, sizeof(context->record.keyboard_pressed));
        memset(&context->record.keyboard_released, 0, sizeof(context->record.keyboard_released));

        /* Cycle key pressed. */
        context->record.keyboard_lastkey = context->record.keyboard_key;
        context->record.keyboard_key = 0;

        // TODO: handle keyboard characters

        // TODO: handle mouse

        /* Start again for the next input. */
        context->offset -= sizeof(context->record);
    }

    return size;
}

static fpos_t input_seek(void *cookie, fpos_t offset, int whence)
{
    /* Not expected or supported. */
    syslog(LOG_ERR, "error: seeking input");
    return -1;
}

static int input_close(void *cookie)
{
    /* Not expected or supported. */
    syslog(LOG_ERR, "error: closing input");
    return -1;
}


/*
 * Redirect input to come from a controlled file.
 */

static const char *playback_flag = "-playback";
static const char *playback_path = "__PLAYBACK_PATH__";

static FILE *interposed_fopen(const char *path, const char *mode)
{
    if (strcmp(path, playback_path) == 0) {
        syslog(LOG_WARNING, "opening playback path");
        void *cookie = &global_context;
        input_init(cookie);
        return funopen(cookie, input_read, NULL, input_seek, input_close);
    } else {
        return fopen(path, mode);
    }
}

Interpose(interposed_fopen, fopen);

static char *interposed_strdup(const char *str)
{
    if (strncmp(str, "-game", 5) == 0) {
        syslog(LOG_WARNING, "found game arg: %s", str);
        size_t size = strlen(str) + 1 + strlen(playback_flag) + 1 + strlen(playback_path) + 1;
        char *result = malloc(size);
        snprintf(result, size, "%s %s %s", str, playback_flag, playback_path);
        syslog(LOG_WARNING, "new game args is: %s", result);
        return result;
    } else {
        return strdup(str);
    }
}

Interpose(interposed_strdup, strdup);
