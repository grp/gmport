/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
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

