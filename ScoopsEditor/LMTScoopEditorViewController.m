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
-(id) initWithModel: (LMTScoop *) aModel client:(MSClient *) aClient{
    
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        
        _model = aModel;
        _client = aClient;
        
        self.title = aModel.title;
        
    }
    return self;
}


#pragma mark - Lifecycle
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self syncViewWithModel];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    self.titleTextField.delegate = self;
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self syncModelWithView];
    
    [self uploadScoopToAzure];
    
    [self.tabBarController.tabBar setHidden:NO];
    
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
-(void) syncViewWithModel{
    
    self.titleTextField.text = self.model.title;
    self.authorLabel.text = self.model.author;
    self.bodyTextView.text = self.model.body;
    self.photoView.image = self.model.photo;
    
}

-(void)syncModelWithView{
    
    // Sincronizo vistas --> modelo
    self.model.title = self.titleTextField.text;
    self.model.body = self.bodyTextView.text;
    self.model.photo = self.photoView.image;
    

}

#pragma mark - Actions
-(IBAction)hideKeyboard:(id)sender{
    
    [self.view endEditing:YES];
}

- (IBAction)takePicture:(id)sender {
    
    // Creamos una UIImagePickerController
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // Lo configuro
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // Uso la camara
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        // Tiro del carrete
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    picker.delegate = self;
        
    // Lo muestro de forma modal
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                         // Esto se va a ejecutar cuando termine la animacion que muestra al picker.
                     }];
    
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
        
    // Sacamos la UIImage del diccionario
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // La muestro
    self.model.photo = img;
    
    // Quito de encima el controlador que estamos presentando
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 // Se ejecutara cuando se haya ocultado del todo
                             }];
    
}

#pragma mark - Azure

- (void)uploadScoopToAzure{
    MSTable *news = [self.client tableWithName:@"news"];
    //    Scoop *scoop = [[Scoop alloc]initWithTitle:self.titleText.text
    //                                      andPhoto:nil
    //                                         aText:self.boxNews.text
    //                                      anAuthor:@""
    //                                         aCoor:CLLocationCoordinate2DMake(0, 0)];
    
    if (self.model.identifier) {
        // Si la noticia ya existe, la actualizamos
        NSDictionary *scoop = @{@"id" : self.model.identifier, @"titulo" : self.model.title, @"noticia" : self.model.body, @"published" : @NO};
        [news update:scoop
          completion:^(NSDictionary *item, NSError *error) {
              
              if (error) {
                  NSLog(@"Error %@", error);
              } else {
                  NSLog(@"OK");
              }
              
          }];
    }else{
        //y si no, metemos una nueva
        NSDictionary *scoop = @{@"titulo" : self.model.title, @"noticia" : self.model.body, @"published" : @NO};
        [news insert:scoop
          completion:^(NSDictionary *item, NSError *error) {
              
              if (error) {
                  NSLog(@"Error %@", error);
              } else {
                  self.model.identifier = item[@"id"];
                  NSLog(@"OK");
              }
              
          }];
        
    }
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
