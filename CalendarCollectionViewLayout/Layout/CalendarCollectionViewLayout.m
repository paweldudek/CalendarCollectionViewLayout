//
//  Created by Pawel Dudek on 02/07/14.
//  Copyright (c) 2014 Dudek. All rights reserved.
//


#import "CalendarCollectionViewLayout.h"


@interface CalendarCollectionViewLayout ()
@property(nonatomic, readwrite) CGFloat minuteToPixelRatio;

@property(nonatomic, readwrite) NSDate *startOfDisplayedDay;
@property(nonatomic, readwrite) NSDate *endOfDisplayedDay;

@property(nonatomic, strong) NSArray *cachedSeparatorsAttributes;
@property(nonatomic, strong) NSArray *cachedCellAttributes;

@end

NSString *const CalendarCollectionViewLayoutDecorationKindBead;
NSString *const CalendarCollectionViewLayoutDecorationKindSeparator;

@implementation CalendarCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];

    [self registerClass:[UIView class] forDecorationViewOfKind:CalendarCollectionViewLayoutDecorationKindBead];
    [self registerClass:[UIView class] forDecorationViewOfKind:CalendarCollectionViewLayoutDecorationKindSeparator];

    id <CalendarCollectionViewLayoutDelegate> delegate = (id <CalendarCollectionViewLayoutDelegate>) self.collectionView.delegate;

    if ([delegate respondsToSelector:@selector(minuteToPixelRatioForCalendarColleviewViewLayout:)]) {
        self.minuteToPixelRatio = [delegate minuteToPixelRatioForCalendarColleviewViewLayout:self];
    }

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
    return collectionViewContentSize;
}

#pragma mark - Elements in rect

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];

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
    return nil;
}

@end
