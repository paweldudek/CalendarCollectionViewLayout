//
//  Created by Pawel Dudek on 02/07/14.
//  Copyright (c) 2014 Dudek. All rights reserved.
//


#import "ExampleCalendarEvent.h"


@implementation ExampleCalendarEvent
@synthesize startDate, endDate;

+ (instancetype)eventWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    ExampleCalendarEvent *event = [[self alloc] init];
    event.startDate = startDate;
    event.endDate = endDate;

    return event;
}

@end
