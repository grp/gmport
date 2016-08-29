/*
 * Copyright (c) 2016, Grant Paul
 * All rights reserved.
 */

#import "ControlView.h"


@implementation ControlView

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithWhite:1.0 alpha:0.1];
}

+ (CGFloat)borderWidth
{
    return 2.0;
}

+ (UIColor *)borderColor
{
    return [UIColor colorWithWhite:0.5 alpha:0.3];
}

+ (UIColor *)textColor
{
    return [UIColor colorWithWhite:0.8 alpha:0.4];
}

@end


@implementation ButtonView {
    UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [self.class backgroundColor];

        self.clipsToBounds = YES;
        self.layer.borderWidth = [self.class borderWidth];
        self.layer.borderColor = [[self.class borderColor] CGColor];

        _label = [[UILabel alloc] init];
        _label.textColor = [self.class textColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect bounds = self.bounds;
    self.layer.cornerRadius = MIN(bounds.size.width, bounds.size.height) / 2;
    _label.frame = bounds;
    _label.font = [UIFont systemFontOfSize:(bounds.size.height * 0.5)];
}

- (void)setTitle:(NSString *)title
{
    if (![_title isEqualToString:title]) {
        _title = [title copy];
        _label.text = _title;
    }
}

@end


@implementation PadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        self.opaque = NO;
    }

    return self;
}

static CGSize SpokeSize(CGRect bounds)
{
    CGSize center = CGSizeMake(bounds.size.width / 3, bounds.size.height / 3);
    return CGSizeMake((bounds.size.width - center.width) / 2, (bounds.size.height - center.height) / 2);
}

- (BOOL)pointInsideUp:(CGPoint)point withEvent:(UIEvent *)event
{
    if (![self pointInside:point withEvent:event]) {
        return NO;
    }

    CGSize spoke = SpokeSize(self.bounds);
    return (point.y < CGRectGetMinY(self.bounds) + spoke.height);
}

- (BOOL)pointInsideDown:(CGPoint)point withEvent:(UIEvent *)event
{
    if (![self pointInside:point withEvent:event]) {
        return NO;
    }

    CGSize spoke = SpokeSize(self.bounds);
    return (point.y > CGRectGetMaxY(self.bounds) - spoke.height);
}

- (BOOL)pointInsideLeft:(CGPoint)point withEvent:(UIEvent *)event
{
    if (![self pointInside:point withEvent:event]) {
        return NO;
    }

    CGSize spoke = SpokeSize(self.bounds);
    return (point.x < CGRectGetMinX(self.bounds) + spoke.width);
}

- (BOOL)pointInsideRight:(CGPoint)point withEvent:(UIEvent *)event
{
    if (![self pointInside:point withEvent:event]) {
        return NO;
    }

    CGSize spoke = SpokeSize(self.bounds);
    return (point.x > CGRectGetMaxX(self.bounds) - spoke.width);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGRect bounds = self.bounds;
    CGSize spoke = SpokeSize(self.bounds);
    CGVector radii = CGVectorMake(bounds.size.width / 8, bounds.size.height / 8);

    UIBezierPath *path = [UIBezierPath bezierPath];

    CGPoint start = CGPointMake(bounds.size.width - spoke.width, spoke.height);
    [path moveToPoint:start];

    for (NSUInteger i = 0; i < 4; i++) {
        CGFloat angle = i * (M_PI / 2);
        CGFloat startAngle = angle - (M_PI / 2);
        CGFloat endAngle = angle + (M_PI / 2);

        CGFloat radius;
        CGPoint line1, line2, line3;
        CGPoint center1, center2, center3;

        switch (i) {
            case 0: /* Right. */
                radius  = radii.dx;
                line1   = CGPointMake(CGRectGetMaxX(bounds) - radius,      CGRectGetMinY(bounds) + spoke.height);
                center1 = CGPointMake(CGRectGetMaxX(bounds) - radius,      CGRectGetMinY(bounds) + spoke.height + radius);
                line2   = CGPointMake(CGRectGetMaxX(bounds),               CGRectGetMaxY(bounds) - spoke.height - radius);
                center2 = CGPointMake(CGRectGetMaxX(bounds) - radius,      CGRectGetMaxY(bounds) - spoke.height - radius);
                line3   = CGPointMake(CGRectGetMaxX(bounds) - spoke.width, CGRectGetMaxY(bounds) - spoke.height);
                break;
            case 1: /* Bottom. */
                radius  = radii.dy;
                line1   = CGPointMake(CGRectGetMaxX(bounds) - spoke.width,          CGRectGetMaxY(bounds) - radius);
                center1 = CGPointMake(CGRectGetMaxX(bounds) - spoke.width - radius, CGRectGetMaxY(bounds) - radius);
                line2   = CGPointMake(CGRectGetMinX(bounds) + spoke.width + radius, CGRectGetMaxY(bounds));
                center2 = CGPointMake(CGRectGetMinX(bounds) + spoke.width + radius, CGRectGetMaxY(bounds) - radius);
                line3   = CGPointMake(CGRectGetMinX(bounds) + spoke.width,          CGRectGetMaxY(bounds) - spoke.height);
                break;
            case 2: /* Left. */
                radius  = radii.dx;
                line1   = CGPointMake(CGRectGetMinX(bounds) + radius,      CGRectGetMaxY(bounds) - spoke.height);
                center1 = CGPointMake(CGRectGetMinX(bounds) + radius,      CGRectGetMaxY(bounds) - spoke.height - radius);
                line2   = CGPointMake(CGRectGetMinX(bounds),               CGRectGetMinY(bounds) + spoke.height + radius);
                center2 = CGPointMake(CGRectGetMinX(bounds) + radius,      CGRectGetMinY(bounds) + spoke.height + radius);
                line3   = CGPointMake(CGRectGetMinX(bounds) + spoke.width, CGRectGetMinY(bounds) + spoke.height);
                break;
            case 3: /* Top. */
                radius  = radii.dy;
                line1   = CGPointMake(CGRectGetMinX(bounds) + spoke.width,          CGRectGetMinY(bounds) + radius);
                center1 = CGPointMake(CGRectGetMinX(bounds) + spoke.width + radius, CGRectGetMinY(bounds) + radius);
                line2   = CGPointMake(CGRectGetMaxX(bounds) - spoke.width - radius, CGRectGetMinY(bounds));
                center2 = CGPointMake(CGRectGetMaxX(bounds) - spoke.width - radius, CGRectGetMinY(bounds) + radius);
                line3   = CGPointMake(CGRectGetMaxX(bounds) - spoke.width,          CGRectGetMinY(bounds) + spoke.height);
                break;
        }

        [path addLineToPoint:line1];
        [path addArcWithCenter:center1 radius:radius startAngle:startAngle endAngle:angle clockwise:YES];
        [path addLineToPoint:line2];
        [path addArcWithCenter:center2 radius:radius startAngle:angle endAngle:endAngle clockwise:YES];
        [path addLineToPoint:line3];
    }

    [path closePath];

    /* Fill inside of path. */
    [[self.class backgroundColor] setFill];
    [path fill];

    /* Clip to draw stroke outside. */
    [path.bezierPathByReversingPath addClip];
    path.lineWidth = [self.class borderWidth] * 2; /* Half is clipped. */
    [[self.class borderColor] setStroke];
    [path stroke];
}

@end

