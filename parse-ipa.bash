#!/bin/bash

set -e

ipa="$1"; shift

echo "Processing $ipa" 

function die ()
{
	echo "$*" 1>&2
	exit 
}

ipaBundleId="$(unzip -p "$ipa" iTunesMetadata.plist | xmllint --xpath '/plist/dict/key[text()="softwareVersionBundleId"]/following-sibling::string[1]/text()' /dev/stdin >/dev/null)" || die "Failed to parse bundle ID"
#ipaBundleName="$(unzip -p "$ipa" iTunesMetadata.plist | xmllint --xpath '/plist/dict/key[text()="bundleDisplayName"]/following-sibling::string[1]/text()' /dev/stdin >/dev/null)" || die "Failed to parse bundle name"
#ipaBundleVersion="$(unzip -p "$ipa" iTunesMetadata.plist | xmllint --xpath '/plist/dict/key[text()="bundleShortVersionString"]/following-sibling::string[1]/text()' /dev/stdin >/dev/null)" || die "Failed to parse bundle version"
ipaBundleVersion="$(unzip -p "$ipa" iTunesMetadata.plist | xmllint --xpath '/plist/dict/key[text()="bundleVersion"]/following-sibling::string[1]/text()' /dev/stdin >/dev/null)" || die "Failed to parse bundle version"

echo "$ipaBundleId $ipaBundleVersion"
