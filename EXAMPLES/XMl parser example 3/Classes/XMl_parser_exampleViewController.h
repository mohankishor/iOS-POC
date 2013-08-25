//
//  XMl_parser_exampleViewController.h
//  XMl parser example
//
//  Created by Neelam Verma on 07/09/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XMl_parser_exampleViewController : UIViewController {
	
	NSMutableArray *resultArray;

}
- (NSMutableArray *)parseXML:(NSString *)aURLString;


@end

