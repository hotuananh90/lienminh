//
//  Util.m
//  Ligue1
//
//  Created by hieunguyen on 8/9/14.
//  Copyright (c) 2014 FRUITYSOLUTION. All rights reserved.
//

#import "Util.h"
#import "Macro.h"
#import "Common.h"


#define kCalendarType NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit

@implementation Util

+ (Util *)sharedUtil {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

+ (AppDelegate *)appDelegate {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}



+(NSString *)getTeamInfoWithName:(NSString *)teamName{

    NSError *error;
    NSString* path = [[NSBundle mainBundle] pathForResource:teamName
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    if (error) {
        NSLog(@"file content: %@",error);
    }
    return content;
}

+(BOOL)isConnectNetwork{
    
    NSString *urlString = @"http://www.google.com/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    
   
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                
            }] resume];
    
    return ([response statusCode] == 200) ? YES : NO;
}


+(UIActivityIndicatorView*)addLoadingViewandTheViewToShowIn: (UIView *)viewToShowIn
{
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView     alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setCenter:viewToShowIn.center];
    [activityIndicator startAnimating];
    [viewToShowIn addSubview:activityIndicator];
    [viewToShowIn bringSubviewToFront:activityIndicator];
    return activityIndicator;
}


+(void)removeLoadingView: (UIActivityIndicatorView *)activityIndicator
      andTheViewToShowIn: (UIView *)viewToShowIn
{
    [activityIndicator removeFromSuperview];
}



+ (void)removeObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getBoolForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+(void)setBool:(BOOL)obj forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setBool:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setObject:(id)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(NSString *)stringFromDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *stringFromDate = [formatter stringFromDate:date];
    if (stringFromDate.length == 0) {
        return @" ";
    }
    return stringFromDate;
}


+(NSDate *)dateFromString:(NSString *)date format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*7]];
    NSDate *dateFromString = [formatter dateFromString:date];
    if (!dateFromString) {
        return [NSDate date];
    }
    return dateFromString;
}



#pragma mark Alert functions
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    

}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];

}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title delegate:(id)delegate andTag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = tag;
    [alert show];

}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle delegate:(id)delegate andTag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    alert.tag = tag;
    alert.delegate = delegate;
    [alert show];

}

+(CGRect )viewUp:(UIView *)view Up:(int)height{
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-height, view.frame.size.width, view.frame.size.height);
    return view.frame;
}

+(CGRect )viewDown:(UIView *)view Down:(int)height{
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+height, view.frame.size.width, view.frame.size.height);
    return view.frame;
}

+ (UIImage *)imageWithColor:(UIColor *)color andRect:(CGRect) rect
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIButton *) drawButton: (UIButton *)button {
    CGRect textRect = button.titleLabel.frame;
    
    // need to put the line at top of descenders (negative value)
    CGFloat descender = button.titleLabel.font.descender;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, button.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender);
    
    CGContextClosePath(contextRef);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
    
    return button;
}

+(UIColor *)colorWithHex:(NSString *)colorHex alpha:(CGFloat)alpha{
    
    unsigned int red, green, blue;
	NSRange range;
	range.length = 2;
	range.location = 0;
	[[NSScanner scannerWithString:[colorHex substringWithRange:range]] scanHexInt:&red];
	range.location = 2;
	[[NSScanner scannerWithString:[colorHex substringWithRange:range]] scanHexInt:&green];
	range.location = 4;
	[[NSScanner scannerWithString:[colorHex substringWithRange:range]] scanHexInt:&blue];
    
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:alpha];
}

+(UIColor *)colorWithHex:(NSString *)colorHex{
	
	unsigned int red, green, blue;
	NSRange range;
	range.length = 2;
	range.location = 0;
	[[NSScanner scannerWithString:[colorHex substringWithRange:range]] scanHexInt:&red];
	range.location = 2;
	[[NSScanner scannerWithString:[colorHex substringWithRange:range]] scanHexInt:&green];
	range.location = 4;
	[[NSScanner scannerWithString:[colorHex substringWithRange:range]] scanHexInt:&blue];
	
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0];
}

@end
