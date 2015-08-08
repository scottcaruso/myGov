//
//  createDictionary.m
//  myGov
//
//  Copyright (c) 2013 Scott Caruso. All rights reserved.
//

#import "createDictionary.h"

@implementation createDictionary

-(NSMutableDictionary*)makeDictionary:(NSString*)name party:(NSString*)party hometown:(NSString*)hometown birthday:(NSString*)birthday tookOffice: (NSString*)tookOffice website: (NSString*)website twitter: (NSString*)twitter facebook: (NSString*)facebook bioguidePhoto: (NSString*) bioguide contactForm: (NSString*) contactForm
{
    NSMutableDictionary *thisDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:name,@"Name",party,@"Party",hometown,@"Hometown",birthday,@"Birthday",tookOffice,@"TookOffice",website,@"Website",twitter,@"Twitter",facebook,@"Facebook",bioguide,@"Photo",contactForm,@"Contact Form",nil];
    return thisDictionary;
}
@end
