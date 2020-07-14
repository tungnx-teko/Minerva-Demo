#!/bin/bash

cd GatewayDemo
xcodebuild archive -scheme GatewayDemo -destination generic/platform=iOS\ Simulator SKIP_INSTALL=NO -archivePath ./GatewayDemo-iphonesimulator.xcarchive

xcodebuild archive -scheme GatewayDemo -destination generic/platform=iOS SKIP_INSTALL=NO -archivePath ./GatewayDemo-iphoneos.xcarchive

xcodebuild -create-xcframework -framework ./GatewayDemo-iphoneos.xcarchive/Products/Library/Frameworks/GatewayDemo.framework  -framework ./GatewayDemo-iphonesimulator.xcarchive/Products/Library/Frameworks/GatewayDemo.framework -output ./GatewayDemo.xcframework

FRAMEWORK_NAME="Minerva.framework"
EMBEDED_FRAMEWORKS=( "$@" ) # Example: ("Core" "Foundation")

for directory in *; do
    if [ -d "${directory}" ]; then
        for frameworkName in "${EMBEDED_FRAMEWORKS[@]}"; do
            find "${directory}/${FRAMEWORK_NAME}/Modules" -name "*-apple-*.swiftinterface" -exec sed -i -e "/${frameworkName}/d" {} \;
        done
    fi
done
