//
//  LMTScoop.m
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 2/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#import "LMTScoop.h"
#import "LMTImage.h"

@interface LMTScoop ()

@property (strong, nonatomic) LMTImage *azureImage;

@end

@implementation LMTScoop

// Properties
-(UIImage *) photo{
    return self.azureImage.image;
}

-(void) setPhoto:(UIImage *)photo{
    
    self.azureImage.image = photo;
}

//Class Methods

+(instancetype) scoopWithTitle: (NSString *) title
                    identifier: (NSString *) identifier
                          body: (NSString *) body
                        author: (NSString *) author
                    authorName: (NSString *) authorName
                   photoString: (NSString *) photoString
                     published: (BOOL) published
             preparedToPublish: (BOOL) preparedToPublish
                        rating: (int) rating{
    
    return [[self alloc] initWithTitle:title
                            identifier: (NSString *) identifier
                                  body:body
                                author:author
                            authorName:authorName
                               photoString:photoString
                             published:published
                     preparedToPublish:preparedToPublish
                                rating:rating];
    
}

+(instancetype) scoopWithTitle: (NSString *) title
                    identifier: (NSString *) identifier
                          body: (NSString *) body
                        author: (NSString *) author
                    authorName: (NSString *) authorName
                   photoString: (NSString *) photoString
                     published: (BOOL) published{
    
    return [[self alloc] initWithTitle:title
                            identifier: (NSString *) identifier
                                  body:body
                                author:author
                            authorName:authorName
                           photoString:photoString
                             published:published];
}

+(instancetype) scoopWithTitle: (NSString *) title
                    identifier: (NSString *) identifier
                          body: (NSString *) body
                        author: (NSString *) author
                    authorName: (NSString *) authorName
                     published: (BOOL) published{
    
    return [[self alloc] initWithTitle:title
                            identifier: (NSString *) identifier
                                  body:body
                                author:author
                            authorName:authorName
                             published:published];
}


+(NSArray *) observableKeys{
    return @[@"title", @"body", @"author", @"photo", @"azureImage", @"rating"];
}


//Designated Init

-(id) initWithTitle: (NSString *) title
         identifier: (NSString *) identifier
               body: (NSString *) body
             author: (NSString *) author
         authorName: (NSString *) authorName
        photoString: (NSString *) photoString
          published: (BOOL) published
  preparedToPublish: (BOOL) preparedToPublish
             rating: (int) rating{
    
    if (self = [super init]) {
        _title = title;
        _identifier = identifier;
        _body = body;
        _author = author;
        _authorName = authorName;
        _photoString = photoString;
        _azureImage = [LMTImage imageWithPhotoString:photoString];
        _published = published;
        _preparedToPublish = preparedToPublish;
        _rating = rating;
    }
    return self;
}

-(id) initWithTitle: (NSString *) title
         identifier: (NSString *) identifier
               body: (NSString *) body
             author: (NSString *) author
         authorName: (NSString *) authorName
        photoString:(NSString *) photoString
          published: (BOOL) published{
    
    return [self initWithTitle:title
                    identifier:identifier
                          body:body
                        author:author
                    authorName:authorName
                   photoString:photoString
                     published:published
             preparedToPublish:NO
                        rating:NO_RATING];
}

-(id) initWithTitle: (NSString *) title
         identifier: (NSString *) identifier
               body: (NSString *) body
             author: (NSString *) author
         authorName: (NSString *) authorName
          published: (BOOL) published{
    
    return [self initWithTitle:title
                    identifier:identifier
                          body:body
                        author:author
                    authorName:authorName
                   photoString:@""
                     published:published
             preparedToPublish:NO
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
