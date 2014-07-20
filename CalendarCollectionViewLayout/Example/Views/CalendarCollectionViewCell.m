/*
 * Copyright 2014 Taptera Inc. All rights reserved.
 */


#import "CalendarCollectionViewCell.h"


@interface CalendarCollectionViewCell ()
@property(nonatomic, readwrite) UILabel *textLabel;
@end

@implementation CalendarCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6f];
        self.layer.cornerRadius = 6.0f;
        self.layer.masksToBounds = YES;

        self.textLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.textLabel];
    }

    return self;
}

#pragma mark - 

- (void)layoutSubviews {
    [super layoutSubviews];

    [[self textLabel] sizeToFit];

    CGRect textFrame = self.textLabel.bounds;
    textFrame.origin.x = 20;
    textFrame.origin.y = roundf((CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(textFrame)) / 2);

    self.textLabel.frame = textFrame;
}

@end
