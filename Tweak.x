
#import <libactivator/libactivator.h>

#define LASendEventWithName(eventName) [LASharedActivator sendEventToListener:[LAEvent eventWithName:eventName mode:[LASharedActivator currentEventMode]]]
static NSString *kGateCaller_eventName = @"GateCaller";

@interface BBBulletin : NSObject
@property (copy) NSString * title;
@property (copy) NSString * message;
@property (nonatomic,copy) NSString * publisherBulletinID;
@property (copy) NSString * bulletinID;
@property (copy) NSString * sectionID;
@property (nonatomic,copy) NSString * recordID;
@property (nonatomic,retain) NSDate * date;
-(NSString *)section;
@end


@interface GateCallerDataSource : NSObject <LAEventDataSource> {}
+ (id)sharedInstance;
@end

@implementation GateCallerDataSource
+ (id)sharedInstance {
	static id sharedInstance = nil;
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		sharedInstance = [self new];
	});
	return sharedInstance;
}

+ (void)load {
	[self sharedInstance];
}

- (id)init {
	if ((self = [super init])) {
		[LASharedActivator registerEventDataSource:self forEventName:kGateCaller_eventName];
	}
	return self;
}

- (NSString *)localizedTitleForEventName:(NSString *)eventName {
	return @"GateCaller";
}

- (NSString *)localizedGroupForEventName:(NSString *)eventName {
	return @"GPS";
}

- (NSString *)localizedDescriptionForEventName:(NSString *)eventName {
	return @"Triggers when a reminder with the title \"GateCaller\" is fired";
}

- (void)dealloc {
	[LASharedActivator unregisterEventDataSourceWithEventName:kGateCaller_eventName];
}
@end




%hook BBServer
- (void)publishBulletinRequest:(BBBulletin *)bulletin destinations:(unsigned long long)arg2 {
	%orig;
	if ([[bulletin section] isEqualToString:@"com.apple.reminders"]){
    if([[bulletin title] isEqualToString:@"GateCaller"]){
      //HBLogDebug(@"[GateCaller]test");
      LASendEventWithName(kGateCaller_eventName);
    }
	}
}
%end
