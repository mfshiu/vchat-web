#!/usr/bin/env bash

set -ex

echo "Linking js-sdk"
git clone --depth 1 --branch $JS_SDK_BRANCH "$JS_SDK_REPO" js-sdk
cd js-sdk
yarn link
yarn --network-timeout=100000 install
cd ../

echo "Linking react-sdk"
git clone --depth 1 --branch $REACT_SDK_BRANCH "$REACT_SDK_REPO" react-sdk
cd react-sdk
yarn link
yarn link matrix-js-sdk
yarn --network-timeout=100000 install
cd ../

echo "Setting up element-web with react-sdk and js-sdk packages"
yarn link matrix-js-sdk
yarn link matrix-react-sdk
