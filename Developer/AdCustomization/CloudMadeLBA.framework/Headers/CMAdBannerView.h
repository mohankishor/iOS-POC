
//
//  CMAdBannerView.h
//  
//
//  Created by CloudMade on 12/9/10.
//  Copyright 2011 __CloudMade__. All rights reserved.
//

/** CMAdBannerViewProtocol
 * 
 * CMAdBannerViewProtocol is required to conform - to pass your API Key
 * which is required to authorize to CloudMade Ad services. Also you can change CMAdBannerView behavoiur 
 * and optimize user experience by implementing methods to control your app behavior 
 * depending on how user interacts with banner. Find more on CloudMade API keys at 
 * http://support.cloudmade.com/answers/api-keys-and-authentication page.
 * 
 */


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol CMADBannerViewProtocol

///----------------------------------------------
/// @name CMADBannerViewProtocol required method
///----------------------------------------------


/** Required method to pass the API key to the libraty.
*
* This is only required method to make Ads working properly. You have to provide your own API key. 
* To find more information on CloudMade API keys and to retrieve one visit http://support.cloudmade.com/answers/api-keys-and-authentication page.
* 
* @return Returns a valid CloudMade API Key.
*/
-(NSString*) bannerViewApiKey;

@optional

///-----------------------------------------------
/// @name CMADBannerViewProtocol optional methods
///-----------------------------------------------


/** Enables location-based advertisement
 *
 * Each time a new banner should be loaded user location is used to improve quality of displayed ads and connect them to actual user location. 
 * Enabling user location for ads will increase your revenues!
 */

-(CLLocationCoordinate2D) bannerViewEnableLocation;

/** Allows to customize advertisement refresh rate
 *
 * Implement this method to adjust CMAdBannerView refresh rate. 
 * Return value will be considered as time in seconds. Framework limits the minimum time interval between banner refreshes as 22 seconds to avoid banner download overlaps. 
 * Default rate is 45 seconds which is considered to be optimal for CTR and impressions.  
 */
-(NSTimeInterval) bannerViewRefreshRate;


/** Allows to display default banner while real ads are loading.
 *
 * Called to check if a default CloudMade banner should be shown prior to the first real banner being obtained.
 * This option is returns NO by default. Return YES to enable default banner in testing.  
 */
-(BOOL) bannerViewAllowDefaultBanner;

/** Notifies the receiver just after a new banner appeared.  */
-(void) bannerViewDidLoadAd;

/** Notifies the receiver when user has tapped the banner and asks for permision to show ads content.
 *
 * Use this method to stop or pause heavy processes in your application. 
 * This will improve user experience during watching ads and your revenue as result.
 *
 * @see bannerViewActionDidFinish
 */
-(BOOL) bannerViewActionShouldBegin;

/** Notifies the receiver when user's closed the ads content. 		
 *
 * This method is used to resume any previously paused processes and restore desired application state after user has watched ads.
 *
 * @see bannerViewActionShouldBegin
 */
-(void) bannerViewActionDidFinish;

/** Notifies the receiver that ad's are failed to load */
-(void) bannerViewDidFailToLoad;

/** Allows to switch between test banners and real ads. 
 *
 * This may help you to test your app before release to public.
 * Also, take care to remove this method or return NO when preparing your application for publishing.
 *
 * @return Return YES to make your app display test banners.
 */
-(BOOL) bannerViewShouldUseTestMode;

/** Allows to set first gradient color for banner space. White color by default.
 * @warning If you want to make backround transpatent, you have to use CMAdBannerView instance's alpha property, 
 * as you do usually for any UIView.
 * @see bannerViewSecondaryGradientColor
 */
-(UIColor*) bannerViewPrimaryGradientColor;

/** Allows to set second gradient color for banner space. Black color by default. 
 * @see bannerViewPrimaryGradientColor
 */
-(UIColor*) bannerViewSecondaryGradientColor;


@end

/** CMAdBannerView 
 *
 * The only class you need to use. Pay attention to CMADBannerViewProtocol to pass a valid API key to authenticate
 * with CloudMade LBA service. Please, note, we strictly recommend you to use fixed banner sizes, 320x50 (or 460x50 landscape)
 * for iPhones and iPads - as 320x50 is the most common banner size and your users will see banners of that size in the
 * most of cases.
 *
 * *Inherits* UIView
 *
 * As CMAdBannerView inherits UIView, you can operate with it, as with view in the most of cases. 
 * As well, you can make your banner view instance transparent, by changing alpha property - this will affect view frame, 
 * but not the banner image inside view, so, if CMAdBannerView instance has frame 320x50 and it displays banner of size 300x50 
 * the part of the view not covered by banner image (10 pixels on each side of the CMAdBannerView frame) will be trasparent.
 *
 * *Important*
 *
 * Banner view should pause the ads rotation when it is not actually displayed on the screen. So, when willMoveToSuperview message
 * arrives, CMAdBannerView will set it's delegate to nil and pause ads rotation for you. 
 * If you want to turn ads rotatin back - set it's delegate again using _delegate_ property.
 *
 * *Releasing CMAdBannerView*
 * You shouldn't release CMAdBannerView while user watches ads. To avoid this situation use bannerViewActionDidFinish delegate method to be notified on the action.
 *
 */
@interface CMAdBannerView : UIView 
{
    id<CMADBannerViewProtocol> delegate;
	id _private;
}

/** CMADBannerViewProtocol delegate 
 *
 * This delegate is required to make CMAdBannerView work properly and authorize to CloudMade ads service with a valid API Key.
 * Also, CMAdBannerView sets this property to nil on _willMoveToSuperview_ message. 
 * So, you have to set delegate back after hiding banner or moving it to another view.
 *
 */
@property(nonatomic, assign) IBOutlet id<CMADBannerViewProtocol> delegate;

/** CMAdBannerView init method 
 *
 * Use this init method to create CMAdBannerView instance from your code.
 *
 * @param givenDelegate should implement CMADBannerViewProtocol to control your CMAdBannerView behavior and provide 
 * a valid CloudMade API key via bannerViewApiKey method.
 *
 * @see CMADBannerViewProtocol
 */
- (id) initWithDelegate:(id<CMADBannerViewProtocol>) givenDelegate;

@end
