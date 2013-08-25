//
//  XMl_parser_exampleViewController.m
//  XMl parser example
//
//  Created by Neelam Verma on 07/09/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "XMl_parser_exampleViewController.h"
#import "tinyXML.h"

@implementation XMl_parser_exampleViewController



// The designated initializer. Override to perform setup that is required before the view is loaded.
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
//		
//		
//        // Custom initialization
//    }
//    return self;
//}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	NSArray *getData = [self parseXML:@"http://maps.google.com/maps/geo?q=current&output=xml"];
	NSLog(@"count ---- #### %d ",[getData count]);
	NSLog(@"XML is ------  #### %@",getData);
	
	[super viewDidLoad];
}

- (NSMutableArray *)parseXML:(NSString *)aURLString
{
	NSURL  *url=[NSURL URLWithString:aURLString];
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
	
	NSURLResponse* myURLResponse = nil; 
	NSError* myError = nil; 
	NSData* dataResult = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&myURLResponse error:& myError];
	
	if(myError)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry! The server is not responding. Please try again later." message:nil
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alertView show];
		
		return NULL;
	}
	
	NSString *xmlString = [[NSString alloc] initWithData:dataResult encoding:NSMacOSRomanStringEncoding];
	if(!xmlString)
		xmlString = [NSString stringWithString:@"<HTML><BODY></BODY></HTML>"];
	
	TiXmlDocument* pXMLDoc = new TiXmlDocument();
	
	pXMLDoc->Parse([xmlString UTF8String], 0, TIXML_ENCODING_LEGACY);
	
	[xmlString release];
	
	if(! pXMLDoc->Error())
	{
		
		TiXmlElement* rootElem = pXMLDoc->RootElement();
		TiXmlElement* staticElem = NULL; 
		
		resultArray=[[NSMutableArray alloc]init];
		//resultDictionary=[[NSMutableDictionary alloc] init];
			//To parse the root XML Tag
		for (staticElem = rootElem->FirstChildElement(); staticElem != 0; staticElem = staticElem->NextSiblingElement())
		{
			//TiXmlElement* resultElement = NULL; 
				//NSLog(@"%@",staticElem);
			//NSMutableDictionary *resultDictionary=[[NSMutableDictionary alloc] init];
				//To parse each result Tag
			//for (resultElement = staticElem->FirstChildElement(); resultElement != 0; resultElement = resultElement->NextSiblingElement())
//			
//			{   TiXmlElement *nextElm = NULL;
//				for (nextElm = resultElement->FirstChildElement(); nextElm != 0; nextElm = nextElm->NextSiblingElement())
//				{ 
//					
//					TiXmlElement *nextElmElm = NULL;
//					for (nextElmElm = nextElm->FirstChildElement(); nextElmElm != 0; nextElmElm = nextElmElm->NextSiblingElement())
//					{ 
//						
//						
//						
//						NSString* eleName2=[NSString stringWithCString:nextElmElm->Value() encoding:NSUTF8StringEncoding];
//						if(nextElmElm->GetText() )
//							[resultDictionary setObject:[NSString stringWithCString:nextElmElm->GetText() encoding:NSUTF8StringEncoding] forKey:eleName2];
//						else
//						{
//							[resultDictionary setObject:@"" forKey:eleName2];
//						}
//							//NSLog(@"dictionary -- --- ",resultDictionary);
//					}
//					
//					
//					NSString* eleName1=[NSString stringWithCString:nextElm->Value() encoding:NSUTF8StringEncoding];
//					if(nextElm->GetText() )
//						[resultDictionary setObject:[NSString stringWithCString:nextElm->GetText() encoding:NSUTF8StringEncoding] forKey:eleName1];
//					else
//					{
//						[resultDictionary setObject:@"" forKey:eleName1];
//					}
//						//NSLog(@"dictionary -- --- ",resultDictionary);
//				}
//					
//				
//				NSString* eleName=[NSString stringWithCString:resultElement->Value() encoding:NSUTF8StringEncoding];
//				if(resultElement->GetText() )
//					[resultDictionary setObject:[NSString stringWithCString:resultElement->GetText() encoding:NSUTF8StringEncoding] forKey:eleName];
//				else
//				{
//					[resultDictionary setObject:@"" forKey:eleName];
//				}
//				
//			}
//			
//			if([resultDictionary count])
//				[resultArray addObject:resultDictionary];
//			[resultDictionary release];
			[self getTree:staticElem];
			
		}
		
		delete pXMLDoc;
		return resultArray;
	}
	else
	{	
		delete pXMLDoc;
		return NULL;
		
	}
}

-(void)getTree:(TiXmlElement*)tElem
{ 
	if(tElem->FirstChildElement() == NULL)
	{
		return;
	}
	TiXmlElement *nextElmElm = NULL;
	for (nextElmElm = tElem->FirstChildElement(); nextElmElm != 0; nextElmElm = nextElmElm->NextSiblingElement())
	{ 
		
		NSMutableDictionary* resultDictionary=[[NSMutableDictionary alloc] init];
		
		NSString* eleName2=[NSString stringWithCString:nextElmElm->Value() encoding:NSUTF8StringEncoding];
		if(nextElmElm->GetText() )
			[resultDictionary setObject:[NSString stringWithCString:nextElmElm->GetText() encoding:NSUTF8StringEncoding] forKey:eleName2];
		else
		{
			[resultDictionary setObject:@"" forKey:eleName2];
		}
			//NSLog(@"dictionary -- --- ",resultDictionary);
		if([resultDictionary count])
			[resultArray addObject:resultDictionary];
		[resultDictionary release];
	
		[self getTree:nextElmElm];
	}
	
	

}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[resultArray release];
    [super dealloc];
}

@end
