//
//  ViewController.m
//
//  Copyright (c) 2012 Peter Bakhirev <peter@byteclub.com>
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "ViewController.h"
#import "UITextView+Utils.h"
#import "NetworkController.h"


#pragma mark - Private properties and methods

@interface ViewController ()
- (void)displayMessage:(NSString*)message;
@end


@implementation ViewController

#pragma mark - Private methods

- (void)displayMessage:(NSString*)message {
  // These two came from UITextView+Utils.h
  [textViewOutput appendTextAfterLinebreak:message];
  [textViewOutput scrollToBottom];
}


#pragma mark - Public methods

- (IBAction)connect:(id)sender {
  [[NetworkController sharedInstance] connect];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Enable input and show keyboard as soon as connection is established.
  [NetworkController sharedInstance].connectionOpenedBlock = ^(NetworkController* connection){
    [textInput setUserInteractionEnabled:YES];
    [textInput becomeFirstResponder];
    [self displayMessage:@">>> Connection opened <<<"];
  };

  // Disable input and hide keyboard when connection is closed.
  [NetworkController sharedInstance].connectionClosedBlock = ^(NetworkController* connection){
    [textInput resignFirstResponder];
    [textInput setUserInteractionEnabled:NO];
    [self displayMessage:@">>> Connection closed <<<"];
  };

  // Display error message and do nothing if connection fails.
  [NetworkController sharedInstance].connectionFailedBlock = ^(NetworkController* connection){
    [self displayMessage:@">>> Connection FAILED <<<"];
  };

  // Append incoming message to the output text view.
  [NetworkController sharedInstance].messageReceivedBlock = ^(NetworkController* connection, NSString* message){
    [self displayMessage:message];
  };
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  [NetworkController sharedInstance].connectionOpenedBlock = nil;
  [NetworkController sharedInstance].connectionFailedBlock = nil;
  [NetworkController sharedInstance].connectionClosedBlock = nil;
  [NetworkController sharedInstance].messageReceivedBlock = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations.
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}


#pragma mark - UITextFieldDelegate methods
// Called when user taps 'enter' on the on-screen keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [[NetworkController sharedInstance] sendMessage:textField.text];
  [self displayMessage:textField.text];
  [textField setText:@""];
  return YES;
}

@end
