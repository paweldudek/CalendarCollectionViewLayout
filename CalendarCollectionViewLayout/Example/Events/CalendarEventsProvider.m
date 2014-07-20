///
//  Created by Pawel Dudek on 02/07/14.
//  Copyright (c) 2014 Dudek. All rights reserved.
//


#import "CalendarEventsProvider.h"
#import "ExampleCalendarEvent.h"
#import "NSDate+MTDates.h"


@implementation CalendarEventsProvider

- (instancetype)initWithDisplayedDay:(NSDate *)displayedDay {
    self = [super init];
    if (self) {
        _displayedDay = displayedDay;
    }

    return self;
}

- (NSArray *)calendarEvents {
    ExampleCalendarEvent *event1 = [ExampleCalendarEvent eventWithStartDate:[self.displayedDay mt_dateHoursAfter:8]
                                                                    endDate:[self.displayedDay mt_dateHoursAfter:9]];
    event1.name = @"TDD Workshop Summary";

    ExampleCalendarEvent *event2 = [ExampleCalendarEvent eventWithStartDate:[self.displayedDay mt_dateHoursAfter:10]
                                                                    endDate:[self.displayedDay mt_dateHoursAfter:11]];
    event2.name = @"UICollectionView Workshop Summary";

    ExampleCalendarEvent *event3 = [ExampleCalendarEvent eventWithStartDate:[self.displayedDay mt_dateHoursAfter:14]
                                                                    endDate:[self.displayedDay mt_dateHoursAfter:15]];
    event3.name = @"Animations Workshop Outline";

    return @[event1, event2, event3];
}

@end
