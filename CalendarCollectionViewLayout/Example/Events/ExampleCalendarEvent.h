//
//  Created by Pawel Dudek on 02/07/14.
//  Copyright (c) 2014 Dudek. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CalendarCollectionViewLayout.h"


@interface ExampleCalendarEvent : NSObject <CalendarEvent>
+ (instancetype)eventWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
@end
