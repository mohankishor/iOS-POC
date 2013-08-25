//
//  MentorMateDemoJSViewController.m
//  MentorMateDemoJS
//
//
//  Created by Iordan Iordanov on 2/26/10.
//  Copyright MentorMate 2010. All rights reserved.
//

#import "MentorMateDemoJSViewController.h"

@implementation MentorMateDemoJSViewController


@synthesize imgWebView, updateBtn;

#pragma mark Constants Definitions
static NSString *IMG_URL_TYPEDATE=@"http://www.vvidget.org/cgi-bin/nph-pvs?&EMAIL&chart&2&860,730&chart_type=6&chart_subtype=0&chart_format_type=1&title=%@&y_title=%@&x_title=%@";

static NSString *TEST_DATA = @"&data_1= 1265886924.5 59 1265973324.5 17 1266059724.5 34 1266146124.5 32 1266232524.5 27 1266318924.5 37 1266405324.5 49 1266491724.5 95 1266577928.9 95 1266664328.9 95 1266750728.9 95 1266837128.9 95 1266923528.9 95 1267009928.9 6 1267096328.9 24 1267182728.9 95&data_2= 1265886924.5 29 1265973324.5 29 1266059724.5 29 1266146124.5 29 1266232524.5 29 1266318924.5 29 1266405324.5 29 1266491724.5 28 1266577928.9 29 1266664328.9 29 1266750728.9 29 1266837128.9 29 1266923528.9 29 1267009928.9 29 1267096328.9 29 1267182728.9 30&data_3= 1265886924.5 57 1265973324.5 60 1266059724.5 67 1266146124.5 88 1266232524.5 83 1266318924.5 84 1266405324.5 87 1266491724.5 90 1266577928.9 83 1266664328.9 83 1266750728.9 88 1266837128.9 72 1266923528.9 84 1267009928.9 86 1267096328.9 77 1267182728.9 74&data_4= 1265886924.5 95 1265973324.5 5 1266059724.5 5 1266146124.5 50 1266232524.5 27 1266318924.5 37 1266405324.5 23 1266491724.5 95 1266577928.9 95 1266664328.9 7 1266750728.9 95 1266837128.9 13 1266923528.9 95 1267009928.9 6 1267096328.9 24 1267182728.9 95 ";

#pragma mark -
#pragma mark View
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
	[self showWebView];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [super dealloc];
}

- (IBAction) updateBtnClicked:(id)sender
{
	[self showWebView];
}
#pragma mark -
#pragma mark Graph Methods
/*****************************************************************************
 * Graph Methods
 ****************************************************************************/
-(void)showWebView
{
	[NSTimer scheduledTimerWithTimeInterval:(1) target:self selector:@selector(showWebViewOnTimer:) userInfo:nil repeats:YES];
}

-(void) showWebViewOnTimer:(NSTimer *)timer 
{
	//----- Retreeve Service from timer User Info
	NSString *title = @"Stored Data!";
	NSString *y_title = @"Title Y";
	NSString *x_title = @"Tytle X";
		
	NSMutableString *theGraphURL = [[[NSString stringWithFormat:IMG_URL_TYPEDATE
									  , title, y_title, x_title] mutableCopy] autorelease];
	[theGraphURL appendString:TEST_DATA];
	
	[theGraphURL appendString:@"&start_period_seconds=sunrise&end_period_seconds=sunset"];
	
	//----- A white space delimited list of values representing the x and y values of points in a sequence for curve index I where I starts at 1. The x values are in units of seconds from 1970 and the y values are unitless.
	
	[self getGraph:theGraphURL];
	
	[timer  invalidate];
}



-(void) getGraph:(NSMutableString *)graphURL 
{
	
	NSMutableString *htmlLegent = [NSString stringWithFormat:@"%@",[self getLegendTable]];
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	NSMutableString *pageStr = [[@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n " mutableCopy] autorelease];
	[pageStr appendString:@"<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"en-US\" xml:lang=\"en-US\">\n"];
	
	[pageStr appendString:@"<head>\n"];
	[pageStr appendString:@"<title>MigraineMate Paint Graph</title>\n"];
	[pageStr appendString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n"];
	[pageStr appendString:@"<link href=\"default.css\" rel=\"stylesheet\" type=\"text/css\" />\n"];
	[pageStr appendString:@"<script type=\"text/javascript\" src=\"mgnm.js\"></script>\n"];
	[pageStr appendString:@"<script type=\"text/javascript\" src=\"imgprogress.js\"></script>\n"];
	[pageStr appendString:@"</head>\n"];
	[pageStr appendString:@"<body onload=\"showhide();return(false);\">\n"];
	
	[pageStr appendString:@"<div id=\"notification\">\n"];
	[pageStr appendString:@"<h1>Please Wait</h1>\n"];
	[pageStr appendString:@"<h2>Graph may take a moment to load</h2>\n"];
	[pageStr appendString:@"</div>\n"];
	
	[pageStr appendString:@"<div style=\"display: none;\" id=\"graph\">\n"];
	[pageStr appendString:[NSString stringWithFormat:@"<img alt=\"Graph\" src=\"%@\" width=860px height=730px border=0/>\n", graphURL]];
	[pageStr appendString:@"</div>\n"];
	[pageStr appendString:[NSString stringWithFormat:@"%@\n", htmlLegent]];
	[pageStr appendString:@"</body>\n"];
	[pageStr appendString:@"</html>\n"];
	
	
	
	
	//fullHTMLString = [NSString stringWithFormat:@"<img src=\"%@\" width=%dpx height=%dpx border=0></div>\n%@</body></html>", graphURL,  GRAPH_WIDTH, GRAPH_HEIGHT, htmlStr];
	NSLog(@"->fullHTMLString=%@", pageStr);
	[[self imgWebView]  setBackgroundColor:[UIColor clearColor]];
	[[self imgWebView]  setOpaque:NO];
	[[self imgWebView] loadHTMLString:pageStr baseURL:baseURL];
}


-(NSString *) getLegendTable
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM/dd/yyyy"];
	NSString *stringStartDate = [formatter stringFromDate:[formatter dateFromString:@"02/11/2010"] ];
	NSString *stringEndDate = [formatter stringFromDate:[formatter dateFromString:@"01/26/2010"]];
	NSMutableString *htmlStr = [[@"<div>" mutableCopy] autorelease];
	[htmlStr appendString:@"<table style=\"margin:10px;padding:20px;font-family:Verdana;font-size:28px;color:#FFFFFF;font-weight:bold;\" cellpadding=\"1\" width=\"100%\">"];
	[htmlStr appendString:@"<tbody style=\"margin:10px;padding:20px;font-family:Verdana;font-size:28px;color:#FFFFFF;font-weight:bold;\">"];
	/*[htmlStr appendString:@"<tr>"];
	 
	 [htmlStr appendString:@"<td colspan=\"3\" align=\"Center\">Stored migraine data graph.</td>"];
	 [htmlStr appendString:@"</tr>"];*/
	[htmlStr appendString:@"<tr>"];
	[htmlStr appendString:@"<td></td>"];
	[htmlStr appendString:@"<td>Period:</td>"];
	[htmlStr appendString:[NSString stringWithFormat:@"<td colspane\"2\" style=\"font-weight:normal;\">From %@ to %@</td>", stringStartDate, stringEndDate]];
	[htmlStr appendString:@"</tr>"];
	[htmlStr appendString:@"<tr>"];
	[htmlStr appendString:@"<td align=\"right\" valign=\"top\" rowspan=\"4\">"]; 
	[htmlStr appendString:@"<a href=\"http://mentormate.com\" target=\"_blank\"><img src=\"http://mentormate.com/img/main_logo.png\" border=\"0\" height=\"130\" width=\"130\"></a> </td>"];
	[htmlStr appendString:@"<td>Lines:</td>"];
	/*[htmlStr appendString:@"<td></td>"];
	 [htmlStr appendString:@"</tr>"];
	 [htmlStr appendString:@"<tr>"];
	 [htmlStr appendString:@"<td></td>"];*/
	[htmlStr appendString:[NSString stringWithFormat:@"<td style=\"background:#C94118; color:#FFFFFF;font-weight:normal;\">%@</td>", @"Data 1" ]];
	[htmlStr appendString:@"</tr>"];
	[htmlStr appendString:@"<tr>"];
	[htmlStr appendString:@"<td></td>"];
	[htmlStr appendString:[NSString stringWithFormat:@"<td style=\"background:#5A7BBA; color:#FFFFFF;font-weight:normal;\">%@</td>", @"Data 2"]];
	[htmlStr appendString:@"</tr>"];
	[htmlStr appendString:@"<tr>"];
	[htmlStr appendString:@"<td></td>"];
	[htmlStr appendString:[NSString stringWithFormat:@"<td style=\"background:#B76FB8; color:#FFFFFF;font-weight:normal;\">%@</td></tr>", @"Data 3"]];
	[htmlStr appendString:@"<tr>"];
	[htmlStr appendString:@"<td></td>"];
	[htmlStr appendString:[NSString stringWithFormat:@"<td style=\"background:#58D3DB; color:#FFFFFF;font-weight:normal;\">%@</td></tr>", @"Data 4"]];
	[htmlStr appendString:@"</tbody></table></div>"];
	
	
	return htmlStr;
	
}
@end
