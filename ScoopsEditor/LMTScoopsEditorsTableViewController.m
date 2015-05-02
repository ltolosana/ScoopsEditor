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


@interface LMTScoopsEditorsTableViewController ()

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    
    
}


@end
