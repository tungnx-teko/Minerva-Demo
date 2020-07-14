#!/bin/bash

buildFramework() {
    SCHEME_NAME="${1}"
    rm -rf ./build/${SCHEME_NAME}.xcframework
    xcodebuild archive -scheme ${SCHEME_NAME} -destination generic/platform=iOS\ Simulator -archivePath ./build/${SCHEME_NAME}-iphonesimulator.xcarchive SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

    xcodebuild archive -scheme ${SCHEME_NAME} -destination generic/platform=iOS -archivePath ./build/${SCHEME_NAME}-iphoneos.xcarchive SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

    xcodebuild -create-xcframework -framework ./build/${SCHEME_NAME}-iphoneos.xcarchive/Products/Library/Frameworks/${SCHEME_NAME}.framework -framework ./build/${SCHEME_NAME}-iphonesimulator.xcarchive/Products/Library/Frameworks/${SCHEME_NAME}.framework -output ./build/${SCHEME_NAME}.xcframework

    rm -rf ./build/${SCHEME_NAME}-iphonesimulator.xcarchive
    rm -rf ./build/${SCHEME_NAME}-iphoneos.xcarchive
    
    echo "----- BUILD ${SCHEME_NAME} COMPLETED -----"
}

stripRedundantImport() {
    FRAMEWORK_NAME="${1}"
    EMBEDED_FRAMEWORKS=("$@") # Example: ("Core" "Foundation")

    for directory in "build/${FRAMEWORK_NAME}.xcframework/"*; do
        if [ -d "${directory}" ]; then
            for frameworkName in "${EMBEDED_FRAMEWORKS[@]:1}"; do
                find "${directory}/${FRAMEWORK_NAME}.framework/Modules" -name "*-apple-*.swiftinterface" -exec sed -i -e "/${frameworkName}/d" {} \;
            done
        fi
    done
}

buildFramework "GatewayDemo"
buildFramework "MinervaDemo"
stripRedundantImport "MinervaDemo" "GatewayDemo"


