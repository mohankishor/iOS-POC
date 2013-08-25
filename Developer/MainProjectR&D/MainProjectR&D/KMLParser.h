//
//  KMLParser.h
//  MainProjectR&D
//
//  Created by test on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMLParser : NSObject<NSXMLParserDelegate>
{
    NSXMLParser *xmlParser;
}
-(NSMutableArray *)parseKML;
@property BOOL checkSimpleData;
@property(nonatomic,strong) NSMutableArray *arrayOfFacilityDetails;
@end
