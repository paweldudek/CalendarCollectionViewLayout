//
//  Created by Pawel Dudek on 02/07/14.
//  Copyright (c) 2014 Dudek. All rights reserved.
//


#import <Foundation/Foundation.h>

@class CalendarCollectionViewLayout;


@protocol CalendarEvent <NSObject>

@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;

@end


@protocol CalendarCollectionViewLayoutDelegate <UICollectionViewDelegate>

- (NSDate *)startOfDisplayedDateForCalendarCollectionViewLayout:(CalendarCollectionViewLayout *)layout;
- (NSDate *)endOfDisplayedDateForCalendarCollectionViewLayout:(CalendarCollectionViewLayout *)layout;

- (NSArray *)calendarEventsForCalendarCollectionViewLayout:(CalendarCollectionViewLayout *)layout;

@optional

- (CGFloat)minuteToPixelRatioForCalendarCollectionViewLayout:(CalendarCollectionViewLayout *)layout;

@end


@interface CalendarCollectionViewLayout : UICollectionViewLayout
@property(nonatomic, readonly) CGFloat minuteToPixelRatio;

@property(nonatomic, readonly) NSDate *startOfDisplayedDay;
@property(nonatomic, readonly) NSDate *endOfDisplayedDay;

@end
