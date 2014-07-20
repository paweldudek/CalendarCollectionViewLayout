//
//  Created by Pawel Dudek on 02/07/14.
//  Copyright (c) 2014 Dudek. All rights reserved.
//


#import <MTDates/NSDate+MTDates.h>
#import "CalendarCollectionViewLayout.h"
#import "BeadView.h"


@interface CalendarCollectionViewLayout ()
@property(nonatomic, readwrite) NSDate *startOfDisplayedDay;
@property(nonatomic, readwrite) NSDate *endOfDisplayedDay;

@property(nonatomic, strong) NSArray *cachedSeparatorsAttributes;
@property(nonatomic, strong) NSArray *cachedCellAttributes;

@property(nonatomic, readwrite) NSDate *beadViewDate;
@end

NSString *const CalendarCollectionViewLayoutDecorationKindBead = @"CalendarCollectionViewLayoutDecorationKindBead";
NSString *const CalendarCollectionViewLayoutDecorationKindSeparator = @"CalendarCollectionViewLayoutDecorationKindSeparator";

@implementation CalendarCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];

    [self registerClass:[BeadView class] forDecorationViewOfKind:CalendarCollectionViewLayoutDecorationKindBead];
    [self registerClass:[UIView class] forDecorationViewOfKind:CalendarCollectionViewLayoutDecorationKindSeparator];

    id <CalendarCollectionViewLayoutDelegate> delegate = (id <CalendarCollectionViewLayoutDelegate>) self.collectionView.delegate;

    if ([delegate respondsToSelector:@selector(startOfDisplayedDateForCalendarCollectionViewLayout:)]) {
        self.startOfDisplayedDay = [delegate startOfDisplayedDateForCalendarCollectionViewLayout:self];
    }
    else {
        NSAssert(NO, @"%@ has to implement base calendar layout mehtods!", delegate);
    }

    if ([delegate respondsToSelector:@selector(endOfDisplayedDateForCalendarCollectionViewLayout:)]) {
        self.endOfDisplayedDay = [delegate endOfDisplayedDateForCalendarCollectionViewLayout:self];
    }
    else {
        NSAssert(NO, @"%@ has to implement base calendar layout mehtods!", delegate);
    }

    NSArray *events;

    if ([delegate respondsToSelector:@selector(calendarEventsForCalendarCollectionViewLayout:)]) {
        events = [delegate calendarEventsForCalendarCollectionViewLayout:self];
    }
    else {
        NSAssert(NO, @"%@ has to implement base calendar layout mehtods!", delegate);
    }

    if ([delegate respondsToSelector:@selector(beadViewDateForCalendarCollectionViewLayout:)]) {
        self.beadViewDate = [delegate beadViewDateForCalendarCollectionViewLayout:self];
    }
    else {
        NSAssert(NO, @"%@ has to implement base calendar layout mehtods!", delegate);
    }

    [self calculateCellLayoutAttributesForEvents:events];
    [self calculateSeparatorsLayoutAttributes];
}

#pragma mark - Layout Preparation Helpers

- (void)calculateCellLayoutAttributesForEvents:(NSArray *)array {
    self.cachedCellAttributes = [NSArray array];
}

- (void)calculateSeparatorsLayoutAttributes {
    self.cachedSeparatorsAttributes = [NSArray array];
}

#pragma mark - Content Size

- (CGSize)collectionViewContentSize {
    CGSize collectionViewContentSize = [super collectionViewContentSize];
    NSInteger minutes = [self.startOfDisplayedDay mt_minutesUntilDate:self.endOfDisplayedDay];
    collectionViewContentSize.height = minutes;
    return collectionViewContentSize;
}

#pragma mark - Elements in rect

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    [attributes addObject:[self beadViewLayoutAttributes]];

    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cachedCellAttributes[(NSUInteger) indexPath.row];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    if ([decorationViewKind isEqualToString:CalendarCollectionViewLayoutDecorationKindBead]) {
        return [self beadViewLayoutAttributes];
    }

    return self.cachedSeparatorsAttributes[(NSUInteger) indexPath.row];
}

- (UICollectionViewLayoutAttributes *)beadViewLayoutAttributes {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:CalendarCollectionViewLayoutDecorationKindBead
                                                                                                               withIndexPath:indexPath];

    NSInteger minutes = [[self startOfDisplayedDay] mt_minutesUntilDate:self.beadViewDate];

    CGRect timeIndicatorFrame = CGRectZero;

    timeIndicatorFrame.size = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 1);
    timeIndicatorFrame.origin.y = minutes;

    attributes.frame = timeIndicatorFrame;
    attributes.zIndex = 1;

    return attributes;
}

@end
