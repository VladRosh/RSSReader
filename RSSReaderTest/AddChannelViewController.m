//
//  AddChannelViewController.m
//  RSSReaderTest
//
//  Created by VLAD on 28/06/2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "AddChannelViewController.h"
#import "CustomTextfield.h"
#import "CoreDataManager.h"


@interface AddChannelViewController ()

@property (weak, nonatomic) IBOutlet CustomTextfield *titleTextField;
@property (weak, nonatomic) IBOutlet CustomTextfield *urlTextField;

@end

@implementation AddChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (void) textValidationInTextField: (CustomTextfield *) textField {
    
    if (textField.text.length) {
        
        [textField setNormState];
        
    } else {
        
        [textField setWarnState];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 0) {
        
        [self.urlTextField becomeFirstResponder];
        
    } else {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Notification

- (void) addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidEndEditingNotification:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChangeNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void) textFieldTextDidEndEditingNotification: (NSNotification *) notification {
    
    [self textValidationInTextField:notification.object];
}

- (void) textFieldTextDidChangeNotification: (NSNotification *) notification {
    
    [self textValidationInTextField:notification.object];
}


#pragma mark - Actions

- (IBAction)saveButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    BOOL titleExistlength = self.titleTextField.text.length;
    BOOL urlExistlength = self.urlTextField.text.length;
    
    if (titleExistlength && urlExistlength) {
        
        [[CoreDataManager sharedManager] addRssChannelWithTitle:self.titleTextField.text
                                                         andUrl:self.urlTextField.text
                                                 successHandler:^{
                                                     
                                                     
                                                [self.delegate addChannelViewController:self newChannelAdded:self.titleTextField.text];
                                                     
                                                     [self dismissViewControllerAnimated:YES completion:nil];
                                                     
                                                 } andFailureHandler:^(NSError *error) {
                                                     
                                                     NSLog(@"error: %@", error);
                                                 }];
    } else {
        
        if (!titleExistlength) {
            
            [self.titleTextField setWarnState];
        }
        
        if (!urlExistlength) {
            
            [self.urlTextField setWarnState];
        }
    }
    
}




@end
