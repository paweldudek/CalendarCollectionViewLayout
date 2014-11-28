//
//  Created by Pawel Dudek on 02/07/14.
//  Copyright (c) 2014 Dudek. All rights reserved.
//


#import <MTDates/NSDate+MTDates.h>
#import "CalendarCollectionViewLayout.h"
#import "BeadView.h"
#import "CalendarLayoutAttributes.h"
#import "SeparatorView.h"


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
    [self registerClass:[SeparatorView class]
forDecorationViewOfKind:CalendarCollectionViewLayoutDecorationKindSeparator];

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

- (void)calculateCellLayoutAttributesForEvents:(NSArray *)events {
    NSMutableArray *cellAttributes = [NSMutableArray array];

    for (NSUInteger index = 0; index < [self.collectionView numberOfItemsInSection:0]; ++index) {
        id <CalendarEvent> event = events[index];

        NSInteger eventStartingPosition = [self.startOfDisplayedDay mt_minutesUntilDate:event.startDate];
        NSInteger eventDuration = [event.startDate mt_minutesUntilDate:event.endDate];


        CGPoint eventCenter = CGPointMake(CGRectGetMidX(self.collectionView.bounds), eventStartingPosition + eventDuration / 2);
        eventCenter.y = roundf(eventCenter.y);

        NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
        UICollectionViewLayoutAttributes *attributes = [[[self class] layoutAttributesClass] layoutAttributesForCellWithIndexPath:path];

        attributes.center = eventCenter;
        attributes.size = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), eventDuration);

        [cellAttributes addObject:attributes];
    }

    self.cachedCellAttributes = [cellAttributes copy];
}

- (void)calculateSeparatorsLayoutAttributes {
    NSMutableArray *separatorAttributes = [NSMutableArray array];

    NSInteger numberOfFullHours = [self.startOfDisplayedDay mt_hoursUntilDate:self.endOfDisplayedDay] + 1;
    NSInteger attributeItem = 0;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];


    for (NSUInteger index = 0; index < numberOfFullHours; ++index) {
        NSDate *hourDate = [self.startOfDisplayedDay mt_dateHoursAfter:index];

        CalendarLayoutAttributes *attributes = [self separatorAttributesAtIndex:attributeItem withDate:hourDate];

        attributes.separatorText = [dateFormatter stringFromDate:hourDate];
        attributes.separatorColor = [UIColor colorWithWhite:0.75f alpha:1.0f];

        [separatorAttributes addObject:attributes];

        attributeItem++;

        NSDate *halfHourDate = [hourDate mt_dateMinutesAfter:30];
        attributes = [self separatorAttributesAtIndex:attributeItem withDate:halfHourDate];
        attributes.separatorColor = [UIColor colorWithWhite:0.87f alpha:1.0f];

        [separatorAttributes addObject:attributes];

        attributeItem++;
    }
    self.cachedSeparatorsAttributes = [separatorAttributes copy];
}

- (CalendarLayoutAttributes *)separatorAttributesAtIndex:(NSInteger)attributesIndex withDate:(NSDate *)date {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:attributesIndex inSection:0];
    CalendarLayoutAttributes *attributes = [[[self class] layoutAttributesClass] layoutAttributesForDecorationViewOfKind:CalendarCollectionViewLayoutDecorationKindSeparator
                                                                                                           withIndexPath:indexPath];
    attributes.frame = CGRectMake(0, 0, CGRectGetWidth(self.collectionView.bounds), 20);
    attributes.zIndex = -2;

    CGFloat yPosition = [self.startOfDisplayedDay mt_minutesUntilDate:date];
    attributes.center = CGPointMake(CGRectGetMidX(self.collectionView.frame), yPosition);

    return attributes;
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
    [attributes addObjectsFromArray:self.cachedCellAttributes];
    [attributes addObjectsFromArray:self.cachedSeparatorsAttributes];

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
    UICollectionViewLayoutAttributes *attributes = [[[self class] layoutAttributesClass] layoutAttributesForDecorationViewOfKind:CalendarCollectionViewLayoutDecorationKindBead
                                                                                                                   withIndexPath:indexPath];

    NSInteger minutes = [[self startOfDisplayedDay] mt_minutesUntilDate:self.beadViewDate];

    CGRect timeIndicatorFrame = CGRectZero;

    timeIndicatorFrame.size = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 1);
    timeIndicatorFrame.origin.y = minutes;

    attributes.frame = timeIndicatorFrame;
    attributes.zIndex = 1;

    return attributes;
}

#pragma mark -

+ (Class)layoutAttributesClass {
    return [CalendarLayoutAttributes class];
}

@end
