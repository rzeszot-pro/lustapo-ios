//
//  Bundle.swift
//  Lubelskie Stacje Pogodowe
//
//  Copyright (c) 2016-2019 Damian Rzeszot
//  Copyright (c) 2016 Piotr Woloszkiewicz
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

extension Bundle {

    // MARK: - Bundle Configuration

    /**
     The release or version number of the bundle.

     This key is a user-visible string for the version of the bundle. The required format is three period-separated integers, such as 10.14.1.
     The string can only contain numeric characters (0-9) and periods.
     Each integer provides information about the release in the format [Major].[Minor].[Patch]:
     Major: A major revision number.
     Minor: A minor revision number.
     Patch: A maintenance release number.
     This key is used throughout the system to identify the version of the bundle.
     */
    final var version: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    /**
     The version of the build that identifies an iteration of the bundle.

     This key is a machine-readable string composed of one to three period-separated integers, such as 10.14.1.
     The string can only contain numeric characters (0-9) and periods.
     Each integer provides information about the build version in the format [Major].[Minor].[Patch]:
     Major: A major revision number.
     Minor: A minor revision number.
     Patch: A maintenance release number.
     You can include more integers but the system ignores them.
     You can also abbreviate the build version by using only one or two integers, where missing integers in the format are interpreted as zeros.
     For example, 0 specifies 0.0.0, 10 specifies 10.0.0, and 10.5 specifies 10.5.0.
     This key is required by the App Store and is used throughout the system to identify the version of the build. For macOS apps, increment the build version before you distribute a build.
     */
    final var build: String? {
        return infoDictionary?[kCFBundleVersionKey as String] as? String
    }

    /**
     The user-visible name for the bundle, used by Siri and visible on the iOS Home screen.

     Use this key if you want a product name that's longer than `CFBundleName`.
     */
    final var displayName: String? {
        return infoDictionary?["CFBundleDisplayName"] as? String
    }

    //

    /**
     A user-visible short name for the bundle.

     This name can contain up to 15 characters. The system may display it to users if `CFBundleDisplayName` isn't set.
    */
    final var name: String? {
        return infoDictionary?[kCFBundleNameKey as String] as? String
    }

}
