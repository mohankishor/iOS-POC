//
//  ViewEvents.h
//  CalendarEventsTry
//
//  Created by test on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventKit/EventKit.h"
#import "EventKitUI/EventKitUI.h"
@interface ViewEvents : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    EKEventStore *eventStore;
	
    EKCalendar *defaultCalendar;
	
    NSMutableArray *eventsList;
    
    EKEventViewController *detailViewController;
}

@property (nonatomic, retain) EKEventStore *eventStore;

@property (nonatomic, retain) EKCalendar *defaultCalendar;

@property (nonatomic, retain) NSMutableArray *eventsList;

@property (nonatomic, retain) EKEventViewController *detailViewController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (NSArray *)fetchEventsForToday;

@end
