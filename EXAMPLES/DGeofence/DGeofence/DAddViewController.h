//
//  DAddViewController.h
//  DGeoFence
//
//  Created by Darshan Sonde on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DAddProtocol<NSObject>
-(void) addPinWithIdentifier:(NSString*) identifier
                      radius:(double) radius
                    accuracy:(double)accuracy;
@end

@interface DAddViewController : UIViewController
- (IBAction)cancelClicked:(id)sender;
- (IBAction)doneClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *identifierTextField;
@property (strong) NSObject<DAddProtocol> *delegate;
@property (strong, nonatomic) IBOutlet UISlider *radiusSlider;
@property (strong, nonatomic) IBOutlet UILabel *radiusLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *accuracySegment;

@end
