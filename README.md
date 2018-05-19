<img src="docs/ic_launcher.png" alt="Starbucks Finder icon" title="Starbucks Finder" align="right" height="96" width="96"/>

Starbucks Finder - iOS
====================================

An iOS app to list all nearby Starbucks.
Click on the list will open the Starbucks location on a map.
The app will search nearby Starbucks with current GPS position by default, click the top-right icon to change the search location.

See also: [Android version](https://github.com/CHico-Lee/Starbucks-Finder-Android)


Screenshot
--------------
![Alt text](docs/starbucks_list.png?raw=true "Starbucks on List")
![Alt text](docs/starbucks_map.png?raw=true "Starbucks on Map")


Implementation
------------

- Get the last GPS location for Lat and long using *CLLocationManager*.
- Using *URLSession Class* to download JSON data from *Places API for Web*.
- Using *JSONSerialization* Class to parse JSON data.
- List nearby Starbucks using *UITableView*.
- Using *Maps API for iOS* to plot the location on a map.
- Using *Places API for iOS* to get location position search by text.


Requirements
------------

- App should show a list of the local Starbucks, using Google or any other API.
- App should allow user to click on a Starbucks and load a map.
- App should allow returning back to the Starbucks list from the map.
- App should not crash under any situation.
- App should have proper commenting and code structure.
- App should look nice and polished.


Pre-requisites
--------------

- Xcode 9
- Swift 4.0
- [Maps SDK for iOS](https://developers.google.com/maps/documentation/ios-sdk/intro)
- [Places API for iOS](https://developers.google.com/places/ios-sdk/intro)
- [Places API for Web](https://developers.google.com/places/web-service/intro)


Required Permission
--------------

- GPS location access
- Internet access


Steps to run
--------------

To run on Xcode:

1. Installing the Maps and Places SDK:

    Install CocoaPods tool by running the following command:
    ```
    sudo gem install cocoapods
    ```

    Go to the directory containing the Podfile (project directory):
    ```
    cd <path-to-project>
    ```

    Install the APIs specified in the Podfile:
    ```
    pod install
    ```


2. Get API Keys from [Google API Console](https://console.developers.google.com/):

    - API Key for **Places API for Web**
    - API Key for **Maps SDK for iOS** and **Google Places API for iOS**

    Paste API keys into `starbucksfinder\keys.plist`
    ```xml
    <!--keys.plist-->
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>webPlacesApiKey</key>
        <string>
            Places Web Service API KEY HERE
        </string>
        <key>gmsIosApiKey</key>
        <string>
            iOS Maps and Places API KEY HERE
        </string>
    </dict>
    </plist>
    ```
