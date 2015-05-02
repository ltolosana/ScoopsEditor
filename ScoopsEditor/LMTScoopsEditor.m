//
//  LMTScoopsEditor.m
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#import "LMTScoopsEditor.h"
#import "LMTScoop.h"

@interface LMTScoopsEditor ()

@property (strong, nonatomic) NSArray *unpublishedScoops;
@property (strong, nonatomic) NSArray *publishedScoops;

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
        
        LMTScoop *noticia1 = [LMTScoop scoopWithTitle:@"Noticia 1 Editor"
                                                 body:@"Esta es una noticia  1 importante"
                                               author:@"Yo mismo"
                                                photo:nil];
        
        
        LMTScoop *noticia2 = [LMTScoop scoopWithTitle:@"Noticia 2 Editor"
                                                 body:@"Esta es una noticia 2 importante"
                                               author:@"Yo mismo"
                                                photo:nil];
        
        LMTScoop *noticia3 = [LMTScoop scoopWithTitle:@"Noticia 3 Editor"
                                                 body:@"Esta es una noticia 3 importante"
                                               author:@"Yo mismo"
                                                photo:nil];
        
        
        self.unpublishedScoops = @[noticia1, noticia2];
        self.publishedScoops = @[noticia3];
        
    }
    
    return self;
    
}



-(LMTScoop *) unpublishedScoopAtIndex: (int) index{
    
    return [self.unpublishedScoops objectAtIndex:index];
}

-(LMTScoop *) publishedScoopAtIndex: (int) index{
    
    return [self.publishedScoops objectAtIndex:index];
}


@end
