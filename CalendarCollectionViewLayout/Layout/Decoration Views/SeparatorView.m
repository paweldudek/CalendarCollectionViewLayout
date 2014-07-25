/*
 * Copyright 2014 Taptera Inc. All rights reserved.
 */


#import "SeparatorView.h"
#import "CalendarLayoutAttributes.h"


@interface SeparatorView ()
@property(nonatomic, strong) UIView *separator;
@property(nonatomic, strong) UILabel *separatorLabel;
@end

@implementation SeparatorView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.separator = [[UIView alloc] init];
        [self addSubview:self.separator];

        self.separatorLabel = [[UILabel alloc] init];
        self.separatorLabel.font = [UIFont systemFontOfSize:12];
        self.separatorLabel.backgroundColor = [UIColor clearColor];
        self.separatorLabel.textAlignment = NSTextAlignmentRight;
        self.separatorLabel.textColor = [UIColor colorWithWhite:0.14f alpha:1.0f];

        [self addSubview:self.separatorLabel];
    }

    return self;
}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect separatorFrame = CGRectMake(70, 0, CGRectGetWidth(self.bounds), 1);
    CGFloat separatorMinX = CGRectGetMinX(separatorFrame);

    self.separator.center = CGPointMake(CGRectGetMidX(separatorFrame), CGRectGetMidY(self.bounds));
    separatorFrame.origin = CGPointZero;
    self.separator.bounds = separatorFrame;

    [self.separatorLabel sizeToFit];

    CGFloat spacing = 4.0f;

    CGFloat labelXCenter = separatorMinX - CGRectGetWidth(self.separatorLabel.bounds) + CGRectGetMidX(self.separatorLabel.bounds) - spacing;

    self.separatorLabel.center = CGPointMake(labelXCenter, CGRectGetMidY(self.bounds));
}

#pragma mark - Applying layout Attributes

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];

    if ([layoutAttributes isKindOfClass:[CalendarLayoutAttributes class]]) {
        CalendarLayoutAttributes *calendarLayoutAttributes = (CalendarLayoutAttributes *) layoutAttributes;

        self.separator.backgroundColor = calendarLayoutAttributes.separatorColor;
        self.separatorLabel.text = calendarLayoutAttributes.separatorText;
        [self setNeedsLayout];
    }
}
@end
