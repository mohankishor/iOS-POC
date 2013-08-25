//
//  View_ControllerViewController.m
//  View_Controller
//
//  Created by Anand Kumar Y N on 11/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import "View_ControllerViewController.h"
#import "myFile1.h"
@implementation View_ControllerViewController

@synthesize colorNames;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	self.colorNames=[[NSArray alloc]initWithObjects:@" RED APPLE" ,@" GREEN APPLE",@"PEAR",@"ORANGE",@"STRAWBERRY ",@"SUN FLOWER ",nil ];
	
	//create UIView
	UIView *mainView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
	[mainView setBackgroundColor:[UIColor blackColor]];
	[mainView setAutoresizesSubviews:YES];
	 
	self.view=mainView;
	[mainView release];
	
	table=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewCellStyleValue1 ];
	table.delegate=self;
	table.dataSource=self;
	//[table setBackgroundColor:[UIColor lightGrayColor]];
	//[table setAutoresizesSubviews:YES];
	[self.view addSubview:table];
}


- (void)viewWillAppear:(BOOL)animated    // Called when the view is about to made visible. Default does nothing
{
	self.title=@"Fruits";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *ident=@"Identifier";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
	if(cell == nil)
	{
		cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident]autorelease];
	}
	
	cell.backgroundView.backgroundColor=[UIColor redColor];
	cell.textLabel.text=[colorNames objectAtIndex:indexPath.row];	
	cell.imageView.image=[UIImage imageNamed:@"Yoruba Mask.gif"];
	cell.detailTextLabel.text=[NSString stringWithFormat:@" ALL About %@ ",[colorNames objectAtIndex:indexPath.row]];
	
	
	UIButton *myButton=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[myButton setTitle:@"Next" forState:UIControlStateNormal];
	myButton.tag=indexPath.row;
	[myButton addTarget:self action:@selector(showNextController:) forControlEvents:UIControlEventTouchUpInside];
	cell.accessoryView=myButton;
	
	
		return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.colorNames count];
}

-(void)showNextController:(id)sender
{
	
	UITableViewCell *cell=(UITableViewCell *)[sender superview];
	NSIndexPath *indexPath=[table indexPathForCell:cell];
	myFile1 *myfile=[[myFile1 alloc]init];

	switch (indexPath.row) {
		case 0:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
		case 1:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
		case 2:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
		case 3:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
		case 4:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
		case 5:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
			
		default:
			break;
			
			[myfile release];
	}

}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	myFile1 *myfile=[[myFile1 alloc]init];
	NSLog(@" %d",indexPath.row);
	
	switch (indexPath.row) {
		case 0:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
		case 1:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
		case 2:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
		case 3:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
		case 4:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
		case 5:
			[myfile viewIndex:indexPath.row];
			[self.navigationController pushViewController:myfile animated:YES];
			break;
			
			
		default:
			break;
	}
	[myfile release];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [super dealloc];
}

@end
