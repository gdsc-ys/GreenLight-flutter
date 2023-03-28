# GreenLight

## Actually, this app is made for Galaxy phone maybe Galaxy note 8.
## But ridiculuously, the designers designed it with iPhone size.
## We are going to modify those non-senses soon.

### 1. Set up

앱 완성되면
VM ware에서 window 하나 열고 테스트 한 뒤에 적을게요

### 2. Firebase Services

> * Authentication - Email & Password
> * Firestore
>> Here are several tables for our database.

------------------------------
![DB Diagram](GreenLight.png)
------------------------------


> * Storage - red_lights/{uid_timestamp} photo files


### 3. Branches

> * main - comprehensive outputs
> * Yu - design to dart files
> * map - focused on map and feed 
> * sm - focused on home and group

### 4. Descriptions of Core files

ㅡㅡ models
ㅡㅡㅡㅡ map.dart, user.dart: each file is a custom data structure.

##### Some of device/emulator descerted files are have certain issues.
##### Such as a getting location issue, a pedometer sensor issue. 

ㅡㅡ screens/home
ㅡㅡㅡㅡ homeview_for_device.dart: provide comprehensive data for users
ㅡㅡㅡㅡ feedview.dart: provide news and others users' activities
ㅡㅡㅡㅡ mapview_for_device.dart: provide user's current location on map, red/greenlight markers, on camera actions
ㅡㅡㅡㅡ groupview.dart: ~~~~~~~


### 5. Actual app running shots

완성되면 올릴게요~