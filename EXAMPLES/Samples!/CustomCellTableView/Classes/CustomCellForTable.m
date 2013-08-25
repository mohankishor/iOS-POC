//
//  CustomCellForTable.m
//  CustomCellTableView
//
//  Created by Anand Kumar Y N on 26/08/10.
//  Copyright 2010 Sourcebits Technologies. All rights reserved.
//

#import "CustomCellForTable.h"


@implementation CustomCellForTable

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		//self.backgroundColor = [UIColor yellowColor];
		
		mName = [[UILabel alloc] init];
		[mName setFont:[UIFont fontWithName:@"Verdana" size:18]];
		[self addSubview:mName];
		
		mDesignation = [[UILabel alloc] init];
		[mDesignation setFont:[UIFont fontWithName:@"Verdana" size:15]];
		[self addSubview:mDesignation];
		
		
		mAddress = [[UILabel alloc] init];
		[mAddress setFont:[UIFont fontWithName:@"Verdana" size:15]];
		//[mAddress setFont:[UIFont systemFontOfSize:20]];
		[self addSubview:mAddress];
		
		mImageView  = [[UIImageView alloc] init];
		mImageView.backgroundColor = [UIColor grayColor];
		[self addSubview:mImageView];
		
		
		
		//UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(150, 10, 50, 25)];
//		[button setBackgroundColor:[UIColor purpleColor]];
//		[button addTarget:super.superview action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
//		[self addSubview:button];
//		[button release];
    }
    return self;
}

-(void)displayCell:(NSMutableDictionary *)details
{
	mName.text = [details objectForKey:@"Name"];
	
	mAddress.text = [details objectForKey:@"Address"];
	mDesignation.text=[details objectForKey:@"Designation"];

	
	NSString *imageName = [details objectForKey:@"Photo"];
		mImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
			
	}


-(void)layoutSubviews
{
	
	[mName setFrame:CGRectMake(90, 10, 80, 20)];
	[mDesignation setFrame:CGRectMake(90, 30, 150, 20)];
	[mAddress setFrame:CGRectMake(90, 50, 100, 20)];
	[mImageView setFrame:CGRectMake(10,10, 80, 50)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





- (void)dealloc {
    [super dealloc];
}


@end
