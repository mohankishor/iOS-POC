    //
//  Employee.m
//  CustomCellTableView
//
//  Created by Anand Kumar Y N on 26/08/10.
//  Copyright 2010 Sourcebits Technologies. All rights reserved.
//

#import "Employee.h"


@implementation Employee
//@synthesize myName;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		
				
    }
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	
		UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
		[mainView setBackgroundColor:[UIColor whiteColor]];
		self.view = mainView;
		[mainView release];
	//	
	myImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
	[self.view addSubview:myImageView];
	
	myName = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 250, 20)];
	[self.view addSubview:myName];
	
	
	myAddress = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 250, 20)];
	[self.view addSubview:myAddress];

	myDesignation = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, 250, 20)];
	[self.view addSubview:myDesignation];
	
	myContact = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 250, 20)];
	[self.view addSubview:myContact];
	myEmail = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 250, 20)];
	[self.view addSubview:myEmail];

		
	NSString *str =[[NSBundle mainBundle] pathForResource:@"EmployeeDB" ofType:@"plist"];
	
	myArray=[[NSMutableArray alloc]init];
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:str];
	[myArray addObjectsFromArray:[dic objectForKey:@"Employee"]];
	NSDictionary *dict=[myArray objectAtIndex:myNumber];
	[dic release];
	
			
		myName.text=[NSString  stringWithFormat:@"Name:%@",[dict objectForKey:@"Name"]];
	myAddress.text=[NSString  stringWithFormat:@"Address:%@",[dict objectForKey:@"Address"]];
	myDesignation.text=[NSString  stringWithFormat:@"Designation:%@",[dict objectForKey:@"Designation"]];
	
	myContact.text=[NSString  stringWithFormat:@"Contact:%@",[dict objectForKey:@"Contact"]];
	myEmail.text=[NSString  stringWithFormat:@"E_Mail:%@",[dict objectForKey:@"E_Mail"]];
	
	//NSString *imageName = [dic objectForKey:@"Photo"];
//	NSLog(@"image=%@",imageName);
//	myImageView.image=[UIImage imageNamed:@"image1.png"];
	
	
	
		
	
	
}

-(void)viewAtIndexForCell:(NSInteger)inIndex
{
//NSLog(@"%d",inIndex);
	myNumber=inIndex;
	NSLog(@"number= %d",myNumber);
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[myAddress release];
	[myArray release];
	[myContact release];
	[myEmail release];
	[myImageView release];
	[myName release];
    [super dealloc];
}


@end
