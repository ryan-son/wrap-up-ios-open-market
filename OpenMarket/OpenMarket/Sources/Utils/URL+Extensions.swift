//
//  Extensions.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/30.
//

import Foundation
import MobileCoreServices

extension URL {

    func mimeType() -> String {
        let pathExtension = self.pathExtension

		if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue(),
		   let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
			return mimeType as String
		}

        return "application/octet-stream"
    }
}
