//
//  LMTScoopEditorViewController.m
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#import "LMTScoopEditorViewController.h"
#import "LMTScoop.h"

@interface LMTScoopEditorViewController ()

@end

@implementation LMTScoopEditorViewController

#pragma mark - Init
-(id) initWithModel: (LMTScoop *) aModel{
    
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        
        _model = aModel;
        
        self.title = aModel.title;
        
    }
    return self;
}


#pragma mark - Lifecycle
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self syncModelWithView];
    
    self.titleTextField.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Utils
-(void)syncModelWithView{
    
    self.titleTextField.text = self.model.title;
    self.authorLabel.text = self.model.author;
    self.bodyTextView.text = self.model.body;
    self.photoView.image = self.model.photo;
    
}

-(IBAction)hideKeyboard:(id)sender{
    
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
