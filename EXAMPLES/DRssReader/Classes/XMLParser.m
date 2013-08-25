
#import "XMLParser.h"

@implementation Item
@dynamic title;
@end

@implementation XMLParser
-(id) init {
	self = [super init];
	if(self) {
	}
	return self;
}
-(void) dealloc {
	[mParser release];
	[super dealloc];
}

-(void) parseRss:(NSString *)url 
{
	NSLog(@"Starting to parser: %@",url);

	
	if(mParser) {
		[mParser release];
	}
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	
	mParser = [[NSXMLParser alloc] initWithData:data];
	[mParser setDelegate:self];
	[mParser setShouldResolveExternalEntities:YES];
	[mParser parse];
	NSLog(@"Finished Parsing");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	NSLog(@"start %@",elementName);
	if([elementName isEqualToString:@"xml"]) {
		mParserStage = ParsingXml;
	} else if ([elementName isEqualToString:@"rss"]) {
		mParserStage = ParsingRss;
	} else if ([elementName isEqualToString:@"channel"]) {
		mParserStage = ParsingChannel;
	}else if ([elementName isEqualToString:@"item"]) {
		mParserStage = ParsingItem;
	}  else if ([elementName isEqualToString:@"title"]) {
		if(mParserStage >= ParsingItem) {
			mParserStage = ParsingItemTitle;
		} else if (mParserStage >= ParsingChannel) {//this has to be else if.
			mParserStage = ParsingChannelTitle;
		}
	} else if([elementName isEqualToString:@"link"]) {
		if(mParserStage >= ParsingItem) {
			mParserStage = ParsingItemLink;
		} else if (mParserStage >= ParsingChannel) {//this has to be else if.
			mParserStage = ParsingChannelLink;
		}
	} else if ([elementName isEqualToString:@"description"]) {
		if(mParserStage >= ParsingItem) {
			mParserStage = ParsingItemDescription;
		} else if (mParserStage >= ParsingChannel) {//this has to be else if.
			mParserStage = ParsingChannelDescription;
		}
		
	} else if ([elementName isEqualToString:@"pubDate"]) {
		if(mParserStage >= ParsingItem) {
			mParserStage = ParsingItemPubDate;
		} else if (mParserStage >= ParsingChannel) {//this has to be else if.
			mParserStage = ParsingChannelPubDate;
		}
	} else if ([elementName isEqualToString:@"category"]) {
		if(mParserStage >= ParsingItem) {
			mParserStage = ParsingItemCategory;
		} else if (mParserStage >= ParsingChannel) {//this has to be else if.
			mParserStage = ParsingChannelCategory;
		}
	} else if ([elementName isEqualToString:@"lastBuildDate"]) {
		mParserStage = ParsingChannelLastBuildDate;
	} 
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//	NSLog(@"foundChar %@", string);
	switch (mParserStage) {
		case ParsingItemTitle:
		//case ParsingChannelTitle:
				NSLog(@"foundTitle %@", string);
			
			NSEntityDescription *desc=[NSEntityDescription entityForName:@"ItemEntity" inManagedObjectContext:mContext];
			
			Item *item = [[Item alloc] initWithEntity:desc insertIntoManagedObjectContext:mContext];
			item.title = string;
			
			NSError *saveError = nil;
			[mContext save:&saveError];
			[item release];
			break;
/*		case ParsingItemLink:
			break;
		case ParsingItemDescription:
			break;
		case ParsingItemPubDate:
			break;
		case ParsingItemGuid:
			break;
			ParsingItemCategory			break;*/
		default:
			break;
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
/*	NSString *temp=[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
	//NSLog(@"Cdata %@",temp);
	
	switch (mParserStage) {
			
		case ParsingRoot = 0,
			ParsingXml,
			ParsingRss,
			ParsingChannel,
			ParsingChannelTitle,
			ParsingChannelLink,
			ParsingChannelDescription,
			ParsingChannelCategory,
			ParsingChannelLanguage,
			ParsingChannelPubDate,
			ParsingChannelLastBuildDate,
			ParsingItem,
			ParsingItemTitle,
			ParsingItemLink,
			ParsingItemDescription,
			ParsingItemPubDate,
			ParsingItemGuid,
			ParsingItemCategory
			
		default:
			break;
	}
	[temp release];*/
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//NSLog(@"end %@", elementName);
	/*if([elementName isEqualToString:@"xml"]) {
		mParserStage = 0;
	} else if ([elementName isEqualToString:@"rss"]) {
		mParserStage = 0;
	} else if ([elementName isEqualToString:@"channel"]) {
		mParserStage = 0;
	} else if ([elementName isEqualToString:@"title"]) {
		if(mParserStage >= ParsingItem) {
			mParserStage = 0;
		} else if (mParserStage >= ParsingChannel) {//this has to be else if.
			mParserStage = 0;
		}
	} else if([elementName isEqualToString:@"link"]) {
		if(mParserStage >= ParsingItem) {
			mParserStage = 0;
		} else if (mParserStage >= ParsingChannel) {//this has to be else if.
			mParserStage = 0;
		}
	} else if ([elementName isEqualToString:@"description"]) {
		if(mParserStage >= ParsingItem) {
			mParserStage = 0;
		} else if (mParserStage >= ParsingChannel) {//this has to be else if.
			mParserStage = 0;
		}
		
	} else if ([elementName isEqualToString:@"pubDate"]) {
		if(mParserStage >= ParsingItem) {
			mParserStage = 0;
		} else if (mParserStage >= ParsingChannel) {//this has to be else if.
			mParserStage = 0;
		}
	} else if ([elementName isEqualToString:@"category"]) {
		if(mParserStage >= ParsingItem) {
			mParserStage = 0;
		} else if (mParserStage >= ParsingChannel) {//this has to be else if.
			mParserStage = 0;
		}
	} else if ([elementName isEqualToString:@"lastBuildDate"]) {
		mParserStage = 0;
	} */
}

-(void) setManagedObjectContext:(NSManagedObjectContext *) context
{
	mContext = context;
}
-(void) setStore:(NSPersistentStoreCoordinator*) store
{
	mStore = store;
}
@end
