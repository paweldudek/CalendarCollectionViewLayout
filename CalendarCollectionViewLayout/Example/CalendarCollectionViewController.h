//
//  Created by Pawel Dudek on 02/07/14.
//  Copyright (c) 2014 Dudek. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CalendarCollectionViewLayout.h"

@class CalendarEventsProvider;


@interface CalendarCollectionViewController : UICollectionViewController <CalendarCollectionViewLayoutDelegate>
@property(nonatomic, strong) CalendarEventsProvider *calendarEventsProvider;
@property(nonatomic, strong) NSArray *calendarEvents;

- (instancetype)initWithCalendarEventsProvider:(CalendarEventsProvider *)calendarEventsProvider;


@end
