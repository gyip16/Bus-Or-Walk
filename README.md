# Bus-Or-Walk

iOS application that determines if it is faster to walk to ur destination bus station or to wait at your current bus station location based on Translink API.

Built for BCIT COMP4977 iOS Development Course

### Requirements:
- iOS 10.3+
- Designed on Swift 4.0

### CocoaPods Used
- EVReflection
- AlamoFire

### Known Issues
- Currently, app grabs all bus stops within 2 KM of your input bus station location that the bus you are looking for services. However it cannot differentiate which directions the buses are going, nor can it reliably determine if the bus arriving at the destination bus stop is the same as the one you are expecting, making it inaccurate.
