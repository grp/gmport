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
#import <UIKit/UIKit.h>

#import "Control.h"
#import "ControlView.h"

/*
 * Displays controls and handles actions.
 */
@interface ControlViewController<ValueType> : UIViewController

/* Create a view controller with buttons and pads. */
- (instancetype)initWithButtons:(NSSet<Button<ValueType> *> *)buttons pads:(NSSet<Pad<ValueType> *> *)pads;

/* The buttons shown in the controls. */
@property(nonatomic, copy, readonly) NSSet<Button<ValueType> *> *buttons;

/* The pads shown in the controls. */
@property(nonatomic, copy, readonly) NSSet<Pad<ValueType> *> *pads;

/* Called when a button or pad is pressed. */
@property(nonatomic, copy, readwrite) void (^pressHandler)(ValueType value);

/* Called when a button or pad is released. */
@property(nonatomic, copy, readwrite) void (^releaseHandler)(ValueType value);

@end

