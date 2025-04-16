# inf_flutter_notification

## Getting Started

Read INotificationManager, especially setup()

## Android Release Notice
- Should use latest version
- Disable this plugin on Android < 26 due to zoneSchedule not available to prevent CRASH
- Add notification icon to drawable-nodpi
- Add res/raw/keep.xml to keep notification
```
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@drawable/ic_notification" />
```