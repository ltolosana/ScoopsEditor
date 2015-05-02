//
//  LMTScoop.m
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#import "LMTScoop.h"

@implementation LMTScoop

//Class Methods

+(instancetype) scoopWithTitle: (NSString *) title
                          body: (NSString *) body
                        author: (NSString *) author
                         photo: (UIImage *) photo
                     published: (BOOL) published
                        rating: (int) rating{
    
    return [[self alloc] initWithTitle:title
                                  body:body
                                author:author
                                 photo:photo
                             published: published
                                rating:rating];
    
}

+(instancetype) scoopWithTitle: (NSString *) title
                          body: (NSString *) body
                        author: (NSString *) author
                         photo: (UIImage *) photo{
    
    return [[self alloc] initWithTitle:title
                                  body:body
                                author:author
                                 photo:photo];
}


+(NSArray *) observableKeys{
    return @[@"title", @"body", @"author", @"photo", @"rating"];
}


//Designated Init

-(id) initWithTitle: (NSString *) title
               body: (NSString *) body
             author: (NSString *) author
              photo: (UIImage *) photo
          published: (BOOL) published
             rating: (int) rating{
    
    if (self = [super init]) {
        _title = title;
        _body = body;
        _author = author;
        _photo = photo;
        _published = published;
        _rating = rating;
    }
    return self;
}

-(id) initWithTitle: (NSString *) title
               body: (NSString *) body
             author: (NSString *) author
              photo: (UIImage *) photo{
    
    return [self initWithTitle:title
                          body:body
                        author:author
                         photo:photo
                     published:NO
                        rating:NO_RATING];
}


//#pragma mark - Notifications
//-(void) notifyChanges{
//    
//    NSNotification *n = [NSNotification
//                         notificationWithName:SCOOP_DID_CHANGE_NOTIFICATION
//                         object:self
//                         userInfo:@{SCOOP_KEY : self}];
//    
//    [[NSNotificationCenter defaultCenter] postNotification:n];
//    
//    
//    
//}

//#pragma mark - KVO
//-(void) setupKVO{
//    
//    // Observamos todas las propiedades EXCEPTO modificationDate
//    for (NSString *key in [[self class] observableKeys]) {
//        
//        [self addObserver:self
//               forKeyPath:key
//                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
//                  context:NULL];
//    }
//    
//}
//
//-(void) tearDownKVO{
//    
//    // Me doy de baja de todas las notificaciones
//    for (NSString *key in [[self class] observableKeys]) {
//        
//        [self removeObserver:self
//                  forKeyPath:key];
//    }
//    
//}


@end
