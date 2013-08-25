//
//  Created by Björn Sållarp on 2009-06-14.
//  NO Copyright 2009 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "LocationsParser.h"


@implementation LocationsParser

@synthesize managedObjectContext;

-(id) initWithContext: (NSManagedObjectContext *) managedObjContext
{
	self = [super init];
	[self setManagedObjectContext:managedObjContext];
	
	return self;
}


- (BOOL)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error
{
	BOOL result = YES;
	
	// /Applications/MyExample.app/MyFile.xml
	NSLog(@"URL--%@",URL);
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
	NSLog(@"parser--%@",parser);

    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [parser setDelegate:self];
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
		result = NO;
    }
    
    [parser release];
	
	return result;
}

-(void) emptyDataContext
{
	// Get all counties, It's the top level object and the reference cascade deletion downward
	NSMutableArray* mutableFetchResults = [CoreDataHelper getObjectsFromContext:@"County" :@"Name" :NO :managedObjectContext];
	NSLog(@"mutableFetchResults--%@",mutableFetchResults);

	// Delete all Counties
	for (int i = 0; i < [mutableFetchResults count]; i++) {
		[managedObjectContext deleteObject:[mutableFetchResults objectAtIndex:i]];
		
	}

	
	// Update the data model effectivly removing the objects we removed above.
	NSError *error;
	if (![managedObjectContext save:&error]) {
		
		// Handle the error.
		NSLog(@"%@", [error domain]);
	}
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
	
	// If it's the start of the XML, remove everything we've stored so far
	if([elementName isEqualToString:@"loc"])
	{
		[self emptyDataContext];
		return;
	}
    
	// Create a new County
    if ([elementName isEqualToString:@"county"]) 
	{
        currentCounty = (County *)[NSEntityDescription insertNewObjectForEntityForName:@"County" inManagedObjectContext:managedObjectContext];
		[currentCounty setName:[attributeDict objectForKey:@"name"]];
		
        return;
    }
	// Create a new Province
	else if ([elementName isEqualToString:@"province"])
	{
		currentProvince = (Province *)[NSEntityDescription insertNewObjectForEntityForName:@"Province" inManagedObjectContext:managedObjectContext];
		[currentProvince setName:[attributeDict objectForKey:@"name"]];
		
		// Add the province as a child to the current County
		[currentCounty addCountyToProvinceObject:currentProvince];
    } 
	else if([elementName isEqualToString:@"city"])
	{
		City *c = (City *)[NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:managedObjectContext];
		[c setName:[attributeDict objectForKey:@"name"]];
		[c setDescription:[attributeDict objectForKey:@"desc"]];
		[c setInhabitants:[NSNumber numberWithInt:[[attributeDict objectForKey:@"inhabitants"] intValue]]];
		[c setEmail:[attributeDict objectForKey:@"email"]];
		[c setPhone:[attributeDict objectForKey:@"phone"]];

		[currentProvince addProvinceToCityObject:c];

	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
    if (qName) {
        elementName = qName;
    }
    
	// If we're at the end of a county. Save changes to object model
	if ([elementName isEqualToString:@"county"]) 
	{
		// Sanity check
		if(currentCounty != nil)
		{
			NSError *error;
			
			// Store what we imported already
			if (![managedObjectContext save:&error])
			{
				
				// Handle the error.
				NSLog(@"%@", [error domain]);
			}
		}
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	// We're not reading any text-element data.
}

-(void)dealloc
{
	[managedObjectContext release];
	[super dealloc];
}



@end
