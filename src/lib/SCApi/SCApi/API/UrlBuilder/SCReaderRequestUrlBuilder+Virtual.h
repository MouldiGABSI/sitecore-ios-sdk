#ifndef SCApi_SCReaderRequestUrlBuilder_Virtual_h
#define SCApi_SCReaderRequestUrlBuilder_Virtual_h

#import "SCReaderRequestUrlBuilder.h"

@class SCReadItemsRequest;

@interface SCReaderRequestUrlBuilder(VirtualMethods)

-(NSArray*)getRestArgumentsList;

@end

#endif
