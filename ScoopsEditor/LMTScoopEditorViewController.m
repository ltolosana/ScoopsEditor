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

@property (nonatomic, copy) NSString *photoName;

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
    
    self.photoName = @"image01";
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

- (IBAction)saveScoop:(id)sender {
    [self uploadScoopToAzure];
}

- (IBAction)publishScoop:(id)sender {
    
    self.model.preparedToPublish = YES;
    [self uploadScoopToAzure];
    
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
    
//    if (self.model.photo) {
//        
//        [self uploadPhotoToAzure];
//    }
    
    MSTable *news = [self.client tableWithName:@"news"];
    //    Scoop *scoop = [[Scoop alloc]initWithTitle:self.titleText.text
    //                                      andPhoto:nil
    //                                         aText:self.boxNews.text
    //                                      anAuthor:@""
    //                                         aCoor:CLLocationCoordinate2DMake(0, 0)];
    
    if (self.model.identifier) {
        // Si la noticia ya existe, la actualizamos
        NSDictionary *scoop = @{@"id" : self.model.identifier, @"titulo" : self.model.title, @"noticia" : self.model.body, @"photostring" : self.photoName, @"published" : @(self.model.published), @"preparedToPublish" : @(self.model.preparedToPublish)};
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
        NSDictionary *scoop = @{@"titulo" : self.model.title, @"noticia" : self.model.body, @"photostring" : self.photoName, @"published" : @(self.model.published), @"preparedToPublish" : @(self.model.preparedToPublish)};
        [news insert:scoop
          completion:^(NSDictionary *item, NSError *error) {
              
              if (error) {
                  NSLog(@"Error %@", error);
              } else {
                  //Actualizamos con el photoName
                  self.model.identifier = item[@"id"];
                  self.photoName = self.model.identifier;
                  NSLog(@"OK");
                  
                  // Y actualizamos el remoto
                  NSDictionary *scoop = @{@"id" : self.model.identifier, @"photostring" : self.photoName};
                  [news update:scoop
                    completion:^(NSDictionary *item, NSError *error) {
                        if (error) {
                            NSLog(@"Error %@", error);
                        } else {
                            //Si hemos podido actualizar bien, subimos la foto
                            [self uploadPhotoToAzure];
                        }
                        
                    }];
                  
              }
              
          }];
        
    }
    

}


-(void) uploadPhotoToAzure{
    
    //Obtenemos la sasurl
    [self.client invokeAPI:@"getsasurl"
                      body:nil
                HTTPMethod:@"PUT"
                parameters:@{@"blobName":self.photoName}
                   headers:nil
                completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
        
        if (!error) {
            
        
        NSLog(@"%@", result);
        NSURL *sasURL = [NSURL URLWithString:result[@"sasUrl"]];
                         
        [self handleImageToUploadAzureBlob:sasURL
                                   blobImg:self.model.photo
                      completionUploadTask:^(id result, NSError *error) {
                          
                          if (!error) {
                              NSLog(@"%@", result);
                          }
                      }];
        
        }
    }];

    
}

- (void)handleImageToUploadAzureBlob:(NSURL *)theURL blobImg:(UIImage*)blobImg completionUploadTask:(void (^)(id result, NSError * error))completion{
    
    
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:theURL];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    NSData *data = UIImageJPEGRepresentation(blobImg, 1.f);
    
    NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSLog(@"resultado --> %@", response);
            
//            [self uploadScoopToAzureUsingPhotoString];
            
        }
        
    }];
    [uploadTask resume];
}

//-(void) uploadScoopToAzureUsingPhotoString{
//    
//
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
