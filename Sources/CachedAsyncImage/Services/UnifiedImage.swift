//
//  UnifiedImage.swift
//
//
//  Created by Ian on 20/10/2023.
//

import SwiftUI

#if os(iOS)
import UIKit

public typealias UnifiedImage = UIImage

extension Image {
    init(unifiedImage: UnifiedImage) {
        self.init(uiImage: unifiedImage)
    }
}

extension UIImage {
    convenience init?(named: String, in bundle: Bundle?) {
        self.init(named: named, in: bundle, with: nil)
    }
}
#endif

#if os(macOS)
import AppKit

public typealias UnifiedImage = NSImage

extension Image {
    init(unifiedImage: UnifiedImage) {
        self.init(nsImage: unifiedImage)
    }
}

extension NSImage {
    convenience init?(named: String, in bundle: Bundle?) {
        print(bundle?.path(forResource: named, ofType: "jpg"))
        guard let path = bundle?.path(forResource: named, ofType: "jpg") else {
            return nil
        }
        self.init(contentsOfFile: path)
    }
    
    func pngData() -> Data? {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        let newRep = NSBitmapImageRep(cgImage: cgImage)
        newRep.size = self.size // if you want the same size
        guard let pngData = newRep.representation(using: .png, properties: [:]) else {
            return nil
        }
        return pngData
    }
}
#endif
