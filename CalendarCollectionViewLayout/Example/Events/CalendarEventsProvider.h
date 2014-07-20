//
//  Created by Pawel Dudek on 02/07/14.
//  Copyright (c) 2014 Dudek. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalendarEventsProvider : NSObject

@property(nonatomic, readonly) NSDate *displayedDay;

- (instancetype)initWithDisplayedDay:(NSDate *)displayedDay;


- (NSArray *)calendarEvents;

@end
