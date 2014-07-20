//
//  Created by Pawel Dudek on 02/07/14.
//  Copyright (c) 2014 Dudek. All rights reserved.
//


#import <MTDates/NSDate+MTDates.h>
#import "CalendarCollectionViewController.h"
#import "CalendarEventsProvider.h"


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
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark - UICollectionView Delegate & Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.calendarEvents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6f];
    cell.layer.cornerRadius = 6.0f;
    cell.layer.masksToBounds = YES;
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
