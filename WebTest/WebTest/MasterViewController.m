//
//  MasterViewController.m
//  WebTest
//
//  Created by Joe Fitzpatrick on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize urlTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Workouts", @"Workouts");
    }
    return self;
}
							
- (void)dealloc
{
    [_detailViewController release];
    [_objects release];
    [urlTextField release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated                
{
    // If we just became the current view, clear the web view to an empty page
    if (navigationController.visibleViewController == self)
    {
        [self.detailViewController.webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Text Field crap...
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self openStore:self];
	return NO;
}

- (IBAction)openStore:(id)sender
{
    if (!self.detailViewController) {
        self.detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
    }

	[urlTextField resignFirstResponder];
    self.detailViewController.detailItem = urlTextField.text;
    self.detailViewController.title = @"PEAR Store";
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    self.navigationController.navigationBar.hidden = YES;    
}

- (IBAction)downLoadPress:(id)sender
{
    NSURL *URL;
    
	[urlTextField resignFirstResponder];
    URL = [NSURL URLWithString:urlTextField.text];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:20];
    
    [request setHTTPMethod: @"GET"];
    
    NSData *webData;
    NSLog(@"Start Download");
    webData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"Stop Download");
    NSLog(@"Download size: %d", [webData length]);
}

@end
