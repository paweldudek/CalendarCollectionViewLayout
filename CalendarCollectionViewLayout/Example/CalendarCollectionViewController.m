//
//  Created by Pawel Dudek on 02/07/14.
//  Copyright (c) 2014 Dudek. All rights reserved.
//


#import <MTDates/NSDate+MTDates.h>
#import "CalendarCollectionViewController.h"
#import "CalendarEventsProvider.h"
#import "CalendarCollectionViewCell.h"
#import "ExampleCalendarEvent.h"


@implementation CalendarCollectionViewController

- (instancetype)initWithCalendarEventsProvider:(CalendarEventsProvider *)calendarEventsProvider {
    CalendarCollectionViewLayout *layout = [[CalendarCollectionViewLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _calendarEventsProvider = calendarEventsProvider;

        self.calendarEvents = [self.calendarEventsProvider calendarEvents];
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CalendarCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark - UICollectionView Delegate & Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.calendarEvents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    ExampleCalendarEvent *event = self.calendarEvents[(NSUInteger) indexPath.row];
    cell.textLabel.text = event.name;

    return cell;
}

#pragma mark -

- (NSDate *)startOfDisplayedDateForCalendarCollectionViewLayout:(CalendarCollectionViewLayout *)layout {
    return [self.calendarEventsProvider.displayedDay mt_startOfCurrentDay];
}

- (NSDate *)endOfDisplayedDateForCalendarCollectionViewLayout:(CalendarCollectionViewLayout *)layout {
    return [self.calendarEventsProvider.displayedDay mt_endOfCurrentDay];
}

- (NSArray *)calendarEventsForCalendarCollectionViewLayout:(CalendarCollectionViewLayout *)layout {
    return self.calendarEvents;
}

- (NSDate *)beadViewDateForCalendarCollectionViewLayout:(CalendarCollectionViewLayout *)layout {
    return [NSDate date];
}

@end
