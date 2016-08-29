
@interface Button : NSObject

- (instancetype)initWithName:(char)name button:(iCadeState)button frame:(CGRect)frame;
@property(nonatomic, assign, readonly) char name;
@property(nonatomic, assign, readonly) iCadeState button;
@property(nonatomic, assign, readonly) CGRect frame;

@end

@implementation Button

- (instancetype)initWithName:(char)name button:(iCadeState)button frame:(CGRect)frame
{
    if (self = [super init]) {
        _name = name;
        _button = button;
        _frame = frame;
    }

    return self;
}

@end
