//
//  LMTScoopsEditor.m
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#import "LMTScoopsEditor.h"
#import "LMTScoop.h"

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AzureKeys.h"

@interface LMTScoopsEditor ()

@property (strong, nonatomic) NSMutableArray *unpublishedScoops;
@property (strong, nonatomic) NSMutableArray *publishedScoops;

@end

@implementation LMTScoopsEditor


#pragma mark - Properties
-(int) unpublishedScoopCount{
    
    return [self.unpublishedScoops count];
}

-(int) publishedScoopCount{
    
    return [self.publishedScoops count];
}


#pragma mark - Init
-(id) init{
    if (self = [super init]) {
        
//        LMTScoop *noticia1 = [LMTScoop scoopWithTitle:@"Noticia 1 Editor"
//                                                 body:@"Esta es una noticia  1 importante"
//                                               author:@"Yo mismo"
//                                                photo:nil];
//        
//        
//        LMTScoop *noticia2 = [LMTScoop scoopWithTitle:@"Noticia 2 Editor"
//                                                 body:@"Esta es una noticia 2 importante"
//                                               author:@"Yo mismo"
//                                                photo:nil];
//        
//        LMTScoop *noticia3 = [LMTScoop scoopWithTitle:@"Noticia 3 Editor"
//                                                 body:@"Esta es una noticia 3 importante"
//                                               author:@"Yo mismo"
//                                                photo:nil];
//        
//        
//        self.unpublishedScoops = @[noticia1, noticia2];
//        self.publishedScoops = @[noticia3];
        
        _unpublishedScoops = [@[] mutableCopy];
        _publishedScoops = [@[] mutableCopy];

        
        MSClient *  client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                                 applicationKey:AZUREMOBILESERVICE_APPKEY];
        
        MSTable *table = [client tableWithName:@"news"];
        
        MSQuery *queryModel = [[MSQuery alloc]initWithTable:table];
        [queryModel readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
            
            [self serializaModelFromItemsDict:items];
            
        }];

        
    }
    
    return self;
    
}



-(LMTScoop *) unpublishedScoopAtIndex: (int) index{
    
    return [self.unpublishedScoops objectAtIndex:index];
}

-(LMTScoop *) publishedScoopAtIndex: (int) index{
    
    return [self.publishedScoops objectAtIndex:index];
}

-(void) insertUnpublishedScoop: (LMTScoop *) scoop{
    
    [self.unpublishedScoops addObject:scoop];
    
    [self notifyChanges];
}

#pragma mark - Utils
-(void) serializaModelFromItemsDict: (NSArray *)items{
    
    for (id item in items) {
        NSLog(@"item -> %@", item);
        
        LMTScoop *scoop = [LMTScoop scoopWithTitle:item[@"titulo"]
                                        identifier:item[@"id"]
                                              body:item[@"noticia"]
                                            author:nil
                                             photo:nil];
        
        //Comprobamos si esta publicada o no y la metemos en  el array correspondiente
        if (scoop.published == YES) {
            
            [self.publishedScoops addObject:scoop];
        }else{
            [self.unpublishedScoops addObject:scoop];
        }
    }
    
    [self notifyChanges];
    
}


#pragma mark - Notifications
-(void) notifyChanges{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc postNotificationName:LMTSCOOPSEDITOR_DID_CHANGE_NOTIFICATION
                      object:self];
}

@end
