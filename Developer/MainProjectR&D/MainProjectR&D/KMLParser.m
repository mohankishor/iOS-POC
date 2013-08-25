//
//  KMLParser.m
//  MainProjectR&D
//
//  Created by test on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KMLParser.h"

@implementation KMLParser
@synthesize checkSimpleData;
@synthesize arrayOfFacilityDetails;
- (NSMutableArray *)parseKML
{
    arrayOfFacilityDetails = [[NSMutableArray alloc]init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"facility_boundaries_generalized" ofType:@"kml"];
    NSURL *url = [NSURL fileURLWithPath:path];
    xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    return self.arrayOfFacilityDetails;
}
#pragma NSXMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    if([elementName isEqualToString:@"SimpleData"]) {
        self.checkSimpleData = YES;
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.checkSimpleData) {
        [arrayOfFacilityDetails addObject:string]; 
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if([elementName isEqualToString:@"kml"])
    {
 		return;	
    }
    if ([elementName isEqualToString:@"SimpleData"]) {
        self.checkSimpleData = NO;
    }
}

@end
