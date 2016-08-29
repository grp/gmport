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
@interface ControlViewController : UIViewController

/* Create a view controller with buttons and pads. */
- (instancetype)initWithButtons:(NSSet<Button *> *)buttons pads:(NSSet<Pad *> *)pads;

/* The buttons shown in the controls. */
@property(nonatomic, copy, readonly) NSSet<Button *> *buttons;

/* The pads shown in the controls. */
@property(nonatomic, copy, readonly) NSSet<Pad *> *pads;

@end

