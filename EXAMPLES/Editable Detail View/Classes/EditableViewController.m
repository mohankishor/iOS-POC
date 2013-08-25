/*
 Disclaimer: IMPORTANT:  This About Objects software is supplied to you by
 About Objects, Inc. ("AOI") in consideration of your agreement to the 
 following terms, and your use, installation, modification or redistribution
 of this AOI software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this AOI software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, AOI grants you a personal, non-exclusive
 license, under AOI's copyrights in this original AOI software (the
 "AOI Software"), to use, reproduce, modify and redistribute the AOI
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the AOI Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the AOI Software.
 Neither the name, trademarks, service marks or logos of About Objects, Inc.
 may be used to endorse or promote products derived from the AOI Software
 without specific prior written permission from AOI.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by AOI herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the AOI Software may be incorporated.
 
 The AOI Software is provided by AOI on an "AS IS" basis.  AOI
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE AOI SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL AOI BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE AOI SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF AOI HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) About Objects, Inc. 2009. All rights reserved.
 */
#import "EditableViewController.h"

@implementation EditableViewController

@synthesize itemValue = _itemValue;

- (void)loadView
{
    [super loadView];
    
    CGFloat margin = 20.0;
    
    CGRect viewRect = { margin, 40.0, 280.0, 150.0  };
    UIView *view = [[UIView alloc] initWithFrame:viewRect];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    [view setOpaque:YES];
    [self setView:view];
        
    CGRect labelRect = { margin, 15.0, 240.0, 28.0 };
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    [label setBackgroundColor:[UIColor lightGrayColor]];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setFont:[UIFont boldSystemFontOfSize:16.0]];
    [label setOpaque:YES];
    [label setText:@"My Item"];
    [view addSubview:label];
    
    CGRect textFieldRect = { margin, 45.0, 240.0, 28.0 };
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setBorderStyle:UITextBorderStyleBezel];
    [textField setOpaque:YES];
    [textField setPlaceholder:@"Enter text..."];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setEnablesReturnKeyAutomatically:YES];
    [textField setTag:1];
    [textField setDelegate:self];
    [view addSubview:textField];
    
    CGRect labelRect2 = { margin, 80.0, 120.0, 24.0 };
    UILabel *label2 = [[UILabel alloc] initWithFrame:labelRect2];
    [label2 setBackgroundColor:[UIColor lightGrayColor]];
    [label2 setOpaque:YES];
    [label2 setTextColor:[UIColor grayColor]];
    [label2 setText:@"Current Value:"];
    [view addSubview:label2];
    
    CGRect textFieldRect2 = { 135.0, 82.0, 120.0, 28.0 };
    UITextField *textField2 = [[UITextField alloc] initWithFrame:textFieldRect2];
    [textField2 setBackgroundColor:[UIColor lightGrayColor]];
    [textField2 setTextColor:[UIColor grayColor]];
    [textField2 setEnabled:NO];
    [textField2 setBorderStyle:UITextBorderStyleNone];
    [textField2 setOpaque:YES];
    [textField2 setTag:2];
    [view addSubview:textField2];
    
    CGFloat width = 60.0;
    CGFloat x = [view center].x - (width / 2.0) - (margin / 2.0);
    CGRect buttonRect = { x, 115.0, width, 24.0 };
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:buttonRect];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(save)
     forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [view release];
    [label release];
    [textField release];
}

- (void)save
{
    UITextField *textField1 = (UITextField *)[[self view] viewWithTag:1];
    NSString *text = [textField1 text];
    
    [textField1 resignFirstResponder];
    
    NSLog(@"TextField: %@\nValue: %@", textField1, text);
    
    UITextField *textField2 = (UITextField *)[[self view] viewWithTag:2];
    [textField2 setText:text];
    
    [self setItemValue:text];
}

#pragma mark -
#pragma mark UITextFieldDelegate Protocol

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"In %s -- calling save", _cmd);
    [self save];
    
    return YES;
}

@end
