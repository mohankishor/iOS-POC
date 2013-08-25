


#import "DCommon.h"

enum RssParserStage {
	ParsingRoot = 0,
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
};

@interface Item : NSManagedObject
{
	
}
@property(nonatomic,retain) NSString *title;
@end

@interface XMLParser : NSObject <NSXMLParserDelegate> {
	NSPersistentStoreCoordinator *mStore;
	NSManagedObjectContext *mContext;
	
	NSXMLParser *mParser;
	
	NSMutableString *mCurrentString;
	
	enum RssParserStage mParserStage;
}

-(void) parseRss:(NSString *) url;
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict ;
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string ;
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName ;
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock ;

-(void) setManagedObjectContext:(NSManagedObjectContext *) context;
-(void) setStore:(NSPersistentStoreCoordinator*) store;
@end







