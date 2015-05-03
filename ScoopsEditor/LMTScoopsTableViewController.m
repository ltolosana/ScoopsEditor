//
//  LMTScoopsTableViewController.m
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#import "LMTScoopsTableViewController.h"
#import "LMTScoops.h"
#import "LMTScoopViewController.h"
//#import "LMTScoop.h"

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AzureKeys.h"

@interface LMTScoopsTableViewController ()


@end

@implementation LMTScoopsTableViewController

#pragma mark - Init
-(id) initWithModel: (LMTScoops *) aModel style: (UITableViewStyle) aStyle{
    
    if (self = [super initWithStyle:aStyle]) {
        _model= aModel;
        
        self.title = @"Lector de Noticias";
    }
    
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupKVO];

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
    [self tearDownKVO];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.model.scoopCount;
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
    LMTScoop *scoop = [self.model scoopAtIndex:indexPath.row];
    

    // Sincronizar celda (vista) y modelo
    cell.imageView.image = scoop.photo;
    cell.textLabel.text = scoop.title;
    cell.detailTextLabel.text = scoop.authorName;
    
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
    
    LMTScoop *scoop = [self.model scoopAtIndex:indexPath.row];
    LMTScoopViewController *scoopVC = [[LMTScoopViewController alloc] initWithModel:scoop];
    
    [self.navigationController pushViewController:scoopVC
                                         animated:YES];
    
}


#pragma mark - Azure connect, setup, login etc...

-(void)warmupMSClient{
    MSClient *client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                 applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    NSLog(@"%@", client.debugDescription);
}

- (void)populateModelFromAzure{
}
    


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -  Notifications
-(void) setupNotifications{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(notifyThatScoopsDidChange:)
               name:LMTSCOOPS_DID_CHANGE_NOTIFICATION
             object:nil];
    
}

-(void) tearDownNotifications{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

//LMTSCOOPS_DID_CHANGE_NOTIFICATION
-(void)notifyThatScoopsDidChange:(NSNotification*) notification{
    
    [self.tableView reloadData];
}

#pragma mark - KVO
-(void) setupKVO{
    
    // Observamos todas las propiedades EXCEPTO modificationDate
    for (NSString *key in [[LMTScoop class] observableKeys]) {
        
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:NULL];
    }
    
}

-(void) tearDownKVO{
    
    // Me doy de baja de todas las notificaciones
    for (NSString *key in [[LMTScoop class] observableKeys]) {
        
        [self removeObserver:self
                  forKeyPath:key];
    }
    
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    [self.tableView reloadData];
    
}

@end
