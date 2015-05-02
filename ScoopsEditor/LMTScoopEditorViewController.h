//
//  LMTScoopEditorViewController.h
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

@import UIKit;
#import "LMTScoop.h"

@interface LMTScoopEditorViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;

@property (nonatomic, strong) LMTScoop *model;

-(id) initWithModel: (LMTScoop *) aModel;

-(IBAction)hideKeyboard:(id)sender;

@end