//
//  CEViewController.h
//  CalendarEventsTry
//
//  Created by test on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventKit/EventKit.h"
#import "EventKitUI/EventKitUI.h"
#import "ViewEvents.h"
#import "EditEvents.h"
@interface CEViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    EKEventStore *eventStore;
	
    EKCalendar *defaultCalendar;
	
    NSMutableArray *eventsList;
}

@property (nonatomic, retain) EKEventStore *eventStore;

@property (nonatomic, retain) EKCalendar *defaultCalendar;

@property (nonatomic, retain) NSMutableArray *eventsList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataSource;

@end
