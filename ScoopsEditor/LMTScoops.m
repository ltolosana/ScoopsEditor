//
//  LMTScoops.m
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#import "LMTScoops.h"
#import "LMTScoop.h"

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AzureKeys.h"


@interface LMTScoops ()

@property (strong, nonatomic) NSMutableArray *scoops;

@end

@implementation LMTScoops

#pragma mark - Properties
-(int) scoopCount{
    
    return [self.scoops count];
}


#pragma mark - Init
-(id) init{
    if (self = [super init]) {
        
//        LMTScoop *noticia1 = [LMTScoop scoopWithTitle:@"Noticia 1"
//                                                 body:@"Esta es una noticia  1 importante"
//                                               author:@"Yo mismo"
//                                                photo:nil];
//
//        
//        LMTScoop *noticia2 = [LMTScoop scoopWithTitle:@"Noticia 2"
//                                                 body:@"Esta es una noticia 2 importante"
//                                               author:@"Yo mismo"
//                                                photo:nil];
// 
//        LMTScoop *noticia3 = [LMTScoop scoopWithTitle:@"Noticia"
//                                                 body:@"Esta es una noticia 3 importante"
//                                               author:@"Yo mismo"
//                                                photo:nil];
//
//        
//        self.scoops = @[noticia1, noticia2, noticia3];
        
 
//            for (id item in items) {
//                NSLog(@"item -> %@", item);
//                Scoop *scoop = [[Scoop alloc]initWithTitle:item[@"titulo"] andPhoto:nil aText:item[@"noticia"] anAuthor:@"nil" aCoor:CLLocationCoordinate2DMake(0, 0)];
//                [model addObject:scoop];
//            }
//            [self.collectionView reloadData];

        
        _scoops = [@[] mutableCopy];
        
        MSClient *  client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                                 applicationKey:AZUREMOBILESERVICE_APPKEY];
        
        MSTable *table = [client tableWithName:@"news"];
        
        MSQuery *queryModel = [[MSQuery alloc]initWithTable:table];
        [queryModel orderByDescending:@"__updatedAt"];
        [queryModel readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
            
            [self serializaModelFromItemsDict:items];
            
        }];
        
    }
    
    return self;
    
}


-(LMTScoop *) scoopAtIndex: (int) index{
    
    return [self.scoops objectAtIndex:index];
}


#pragma mark - Utils
-(void) serializaModelFromItemsDict: (NSArray *)items{
    
    for (id item in items) {
        NSLog(@"item -> %@", item);
        
        LMTScoop *scoop = [LMTScoop scoopWithTitle:item[@"titulo"]
                                        identifier:item[@"id"]
                                              body:item[@"noticia"]
                                            author:nil
                                             photo:nil
                                         published:item[@"published"]];
        
        [self.scoops addObject:scoop];
        
    }
    [self notifyChanges];

}

#pragma mark - Notifications
-(void) notifyChanges{
        
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc postNotificationName:LMTSCOOPS_DID_CHANGE_NOTIFICATION
                      object:self];
}



@end
