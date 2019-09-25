# SDFAB
Fully programatic ObjC replication of the [Speed Dial Floating Action Button from the Framework7 web framework](https://v1.framework7.io/docs/floating-action-button.html), generated dynamically from a remote JSON config file.

## Speed Dial Floating Action Button in Framework7:
![](FABSpeedDialDemo.gif)

## My Speed Dial Floating Action Button replicated programatically in ObjC:
![](demo.gif)

# Why?
Was tasked to replicate a Speed Dial Floating Action Button to implement into a dylib in private development.
###### (This is just an empty single view xCode Project that contains PopOverView.m and PopOverView.h. The only two files necessary to include into that dylib.)

# What?
SDFAB is an animated collection of links called a Speed Dial Floating Action Button (SDFAB) that can be remotely controlled.

All elements are created OTF (On-The-Fly) as soon as the initial `[popOverView getRemote];` method is called. This method gets a JSON file from a webserver, which itself is a basic config file. This allows any currently deployed applications to recieve the most up-to-date configuration data, as it may change often or quickly, not requiring constant redeployment of applications.

Tapping the large blue `+` button causes new buttons to appear with the given remote config contents. The buttons will be shown in reverse order to simulate them "popping out" of the main button.

Tapping the new `X` collapses the button list back.

Tapping any of the buttons will take you to a given external link.

# SET UP:
To add to your own ObjC project, you will need the `PopOverView.h` and `PopOverView.m` files.

```
import "PopOverView.h"

//create a PopOverView object:
PopOverView *tempView = [[PopOverView alloc] init];

//call the config parsing instance method:
[tempView getRemote];

//and finally, when you want to show the PopOver, call:
[tempView prePopOver];

//normally, the PopOverView will auto-hide after the given "displayTime" in the config file
//to hide manually, you can call:
[tempView hidePopOver];
```

Currently the PopOverView config is retreived locally, no need to set up a webserver to test.

But in deployment `#define kPopOverRemoteURL @"https://examp.le/popOverInfo.json"` should point to the location of the webserver hosting the JSON config file.

# JSON config example:
```
{
    "displayTime": 10.0,
    "linkContents": {
        "1": {
            "name": "Example",
            "link": "https://examp.le",
            "iconLink": "https://examp.le/example.png",
            "color": "orange"
        },
        "2": {
            "name": "Twitter",
            "link": "https://twitter.com/appvalley_vip",
            "iconLink": "https://examp.le/twitterTransparent.png",
            "color": "blue"
        }
    }
}
```
`displayTime` can be used to control the time, in seconds, the `PopOverView` is shown on screen before fading out. `linkContents` contains each link, image, color, & name. The keys are intentionally ascending integers starting at 1. (Utilizing tags.)

# CONSTRAINTS:
The project goal was to have this popOver be packaged into a dylib, under the assumption only that the dylib will be dynamically loaded into *an* iOS application, not *which* application(s). All I know is the dylib, or dynamic library, should be compiled to be packaged, linked, and dynamically loaded into an .ipa file to run on iOS 10+. I do not know the rotation, size, or the currently presented UIViewController of each application.

For this SDFAB specifically, I also am under the assumption that it is unknown how many links will be needed for the popped-out UIButton's. Only that it will be of a reasonable amount.
