//
//  LMTScoopsEditorsTableViewController.m
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#import "LMTScoopsEditorsTableViewController.h"
#import "LMTScoopsEditor.h"
#import "LMTScoopEditorViewController.h"

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AzureKeys.h"

@interface LMTScoopsEditorsTableViewController (){
    MSClient * client;
    NSString *userFBId;
    NSString *tokenFB;
}

@end

@implementation LMTScoopsEditorsTableViewController

#pragma mark - Init
-(id) initWithModel: (LMTScoopsEditor *) aModel style: (UITableViewStyle) aStyle{
    
    if (self = [super initWithStyle:aStyle]) {
        _model= aModel;
        
        self.title = @"Editor de noticias";
        
        [self addNewScoopButton];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    //Para que al echar hacia atras desde el scoopEditorVC se actualice la tabla
    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];

    [super viewWillAppear:animated];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //Login
    [self loginFB];

//    [self.tableView reloadData];
    //Para que al echar hacia atras desde el scoopEditorVC se actualice la tabla sin hacer un reloadData completo
    if (selectedRowIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[selectedRowIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // Llamamos a los metodos de Azure para crear y configurar la conexion
    [self warmupMSClient];
    
    // Alta en notificaciones
    [self setupNotifications];
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [self tearDownNotifications];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == UNPUBLISHED_SECTION) {
        return self.model.unpublishedScoopCount;
    }else {
        return self.model.publishedScoopCount;
    }

}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == UNPUBLISHED_SECTION) {
        return @"Unpublished news";
    }else {
        return @"Published news";
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Tenemos que crearla a mano
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Sacamos la noticia
    LMTScoop *scoop = nil;
    if (indexPath.section == UNPUBLISHED_SECTION) {
        scoop = [self.model unpublishedScoopAtIndex:indexPath.row];
    }else {
        scoop = [self.model publishedScoopAtIndex:indexPath.row];
    }
    
    
    // Sincronizar celda (vista) y modelo (vino)
    cell.imageView.image = scoop.photo;
    cell.textLabel.text = scoop.title;
    cell.detailTextLabel.text = scoop.author;
    
    // La devolvemos
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LMTScoop *scoop = nil;
    
    if (indexPath.section == UNPUBLISHED_SECTION) {
        scoop = [self.model unpublishedScoopAtIndex:indexPath.row];
    }else {
        scoop = [self.model publishedScoopAtIndex:indexPath.row];
    }

    LMTScoopEditorViewController *scoopVC = [[LMTScoopEditorViewController alloc] initWithModel:scoop];
    
    [self.navigationController pushViewController:scoopVC
                                         animated:YES];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Utils
-(void) addNewScoopButton{
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addNewScoop:)];
    self.navigationItem.rightBarButtonItem = add;
    
}


#pragma mark - Actions
-(void) addNewScoop:(id) sender{
    
    LMTScoop *newScoop = [LMTScoop scoopWithTitle:@"New scoop"
                                             body:nil
                                           author:@"Autor"
                                            photo:nil];
    
//    LMTScoopEditorViewController *newScoopVC = [[LMTScoopEditorViewController alloc] initWithModel:newScoop];
//    
//    [self.navigationController pushViewController:newScoopVC
//                                         animated:YES];
    
    [self.model insertUnpublishedScoop:newScoop];

}

#pragma mark - Azure connect, setup, login etc...

-(void)warmupMSClient{
    client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                           applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    NSLog(@"%@", client.debugDescription);
}

#pragma mark - Login
- (void)loginFB {
    //login
    
    
    [self loginAppInViewController:self withCompletion:^(NSArray *results) {
        
        NSLog(@"Resultados ---> %@", results);
        
    }];
}


- (void)loginAppInViewController:(UIViewController *)controller withCompletion:(completeBlock)bloque{
    
    [self loadUserAuthInfo];
    
    if (client.currentUser){
        [client invokeAPI:@"getuserinfofromauthprovider" body:nil HTTPMethod:@"GET" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
            
            //tenemos info extra del usuario
            NSLog(@"%@", result);
//            self.profilePicture = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
            self.title = [@"Editor de noticias: " stringByAppendingString:result[@"name"]];
        }];
        
        return;
    }
    
    [client loginWithProvider:@"facebook"
                   controller:controller
                     animated:YES
                   completion:^(MSUser *user, NSError *error) {
                       
                       if (error) {
                           NSLog(@"Error en el login : %@", error);
                           bloque(nil);
                       } else {
                           NSLog(@"user -> %@", user);
                           
                           [self saveAuthInfo];
                           [client invokeAPI:@"getuserinfofromauthprovider" body:nil HTTPMethod:@"GET" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                               
                               //tenemos info extra del usuario
                               NSLog(@"%@", result);
//                               self.profilePicture = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
                               self.title = [@"Editor de noticias: " stringByAppendingString:result[@"name"]];
                               
                           }];
                           
                           bloque(@[user]);
                       }
                   }];
    
}


- (BOOL)loadUserAuthInfo{
     
    userFBId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    tokenFB = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
    
    if (userFBId) {
        client.currentUser = [[MSUser alloc]initWithUserId:userFBId];
        client.currentUser.mobileServiceAuthenticationToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
        
        
        
        return TRUE;
    }
    
    return FALSE;
}


- (void) saveAuthInfo{
    [[NSUserDefaults standardUserDefaults]setObject:client.currentUser.userId forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults]setObject:client.currentUser.mobileServiceAuthenticationToken
                                             forKey:@"tokenFB"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}


#pragma mark -  Notifications
-(void) setupNotifications{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(notifyThatScoopsEditorDidChange:)
               name:LMTSCOOPSEDITOR_DID_CHANGE_NOTIFICATION
             object:nil];
    
}

-(void) tearDownNotifications{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

//LMTSCOOPSEDITOR_DID_CHANGE_NOTIFICATION
-(void)notifyThatScoopsEditorDidChange:(NSNotification*) notification{
    
    [self.tableView reloadData];

}

@end
