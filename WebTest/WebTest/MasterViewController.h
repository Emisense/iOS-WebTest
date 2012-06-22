//
//  MasterViewController.h
//  WebTest
//
//  Created by Joe Fitzpatrick on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *urlTextField;
}

- (IBAction)openStore:(id)sender;

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, retain) UITextField *urlTextField;
@end
