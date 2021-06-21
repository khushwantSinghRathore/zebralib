# Setting up Capacitor Plugin with Zebra SDK

1. Add libZSDK_API.a to Plugin project
2. Add all the required Zebra's header files



## Integration with Ionic App
1. Add section below to Info.plist
```
<key>UISupportedExternalAccessoryProtocols</key>
	<array>
		<string>com.zebra.rawport</string>
	</array>
```