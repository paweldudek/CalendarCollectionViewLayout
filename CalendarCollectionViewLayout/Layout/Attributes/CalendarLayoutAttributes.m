/*
 * Copyright 2014 Taptera Inc. All rights reserved.
 */


#import "CalendarLayoutAttributes.h"


@implementation CalendarLayoutAttributes

- (id)copy {
    CalendarLayoutAttributes *attributes = (CalendarLayoutAttributes *) [super copy];
    attributes.separatorColor = self.separatorColor;
    attributes.separatorText = self.separatorText;
    return attributes;
}

- (BOOL)isEqual:(id)other {
    BOOL equal = [super isEqual:other];
    if (equal) {
        if (self.separatorColor && [other separatorColor]) {
            equal &= [self.separatorColor isEqual:[other separatorColor]];
        }
        else if (self.separatorColor || [other separatorColor]) {
            equal &= NO;
        }
        else {
            equal &= YES;
        }
        

        if (self.separatorText && [other separatorText]) {
            equal &= [self.separatorText isEqual:[other separatorText]];
        }
        else if (self.separatorText || [other separatorText]) {
            equal &= NO;
        }
        else {
            equal &= YES;
        }
    }
    return equal;
}

@end
