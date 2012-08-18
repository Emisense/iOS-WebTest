//
//  DetailViewController.m
//  WebTest
//
//  Created by Joe Fitzpatrick on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EffectsPlayer.h"
#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize webView = _webView;

- (void)dealloc
{
    [_detailItem release];
    [_detailDescriptionLabel release];
    [_webView release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];
    }
    
    // Update the view.
    [self configureView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
                                     navigationType:(UIWebViewNavigationType)navigationType
{
    // Grab request URL
    NSURL *url = [request URL];

    NSLog(@"New Request: %@", [url absoluteString]);
    
    if ([[url scheme] compare:@"pearsports"] == NSOrderedSame)
    {
        NSLog(@"Handling as pearsports...");
        
        if ([[[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] compare:@"Application"] == NSOrderedSame)
        {
            // Extract the query portion and convert it into a parameter dictionary
            NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
            
            for (NSString *param in [query componentsSeparatedByString:@"&"])
            {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if ([elts count] < 2)
                    continue;
                [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
            }
            
            // For now, look for 'cmd' and 'val'
            NSString *cmd = [params objectForKey:@"cmd"];
            NSString *val = [params objectForKey:@"val"];
            
            if ([cmd compare:@"sound"] == NSOrderedSame)
            {
                int sound = [val intValue];
                
                if (sound == 0)
                    [[EffectsPlayer instance] snap];
                else if (sound == 1)
                    [[EffectsPlayer instance] squish];
                else if (sound == 2)
                    [[EffectsPlayer instance] clank];
            }
            else if ([cmd compare:@"buy"] == NSOrderedSame)
            {
                UIAlertView *alertView;
                alertView = [[UIAlertView alloc] initWithTitle:@"In-App Purchase"
                                                       message:val
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles: nil];
                [alertView show];
                [alertView release];
                [self bail:self];
            }
            else if ([cmd compare:@"get"] == NSOrderedSame)
            {
                UIAlertView *alertView;
                alertView = [[UIAlertView alloc] initWithTitle:@"Download Plan"
                                                       message:val
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                [alertView show];
                [alertView release];
                
                [self bail:self];
            }
            else if ([cmd compare:@"exit"] == NSOrderedSame)
            {
                [self bail:self];
            }
            else
            {
                UIAlertView *alertView;
                alertView = [[UIAlertView alloc] initWithTitle:cmd
                                                       message:val
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }

        }
        
        return NO;
    }
    
    // Same subfolder on same server?
    NSRange lastslash = [self.detailItem rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *detailRoot = [self.detailItem substringToIndex:lastslash.location + 1];
    
    NSLog(@"Original URL: %@", self.detailItem);
    NSLog(@"Original Base: %@", detailRoot);
    
    NSString *absoluteURL = [[url absoluteURL] absoluteString];
    NSLog(@"New URL as absolute: %@", absoluteURL);
    
    if ([absoluteURL length] < [detailRoot length])
    {
        NSLog(@"Outside store...");
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    else
    {
        NSString *baseString = [absoluteURL substringToIndex:lastslash.location + 1];
        
        if ([ baseString compare:detailRoot] == NSOrderedSame)
        {
            NSLog(@"In Store...");
            return YES;
        }
        else 
        {
            NSLog(@"Outside store...");
            [[UIApplication sharedApplication] openURL:url];
            return NO;
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"Load Started");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Load Finished");
    
    if (self.navigationController.visibleViewController == self)
    {
        [_webView setHidden:NO];
        [_webView setNeedsDisplay];
    }
    else
        self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)bail:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self performSelector:@selector(bail:) withObject:self afterDelay:2.0];
}

- (void)configureView
{
    // Update the user interface for the detail item.   
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.detailItem]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:30];
        
        [_webView setHidden:YES];
        [_webView loadRequest:request];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
@end
