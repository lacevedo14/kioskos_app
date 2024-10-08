//
//  BinahCameraPreview.swift
//  binah_flutter_sdk
//
//  Created by Giora Vered on 26/03/2023.
//

import Foundation
import Combine

class BinahCameraPreview: UIImageView, FlutterPlatformView {
    
    private var imageDataSource: ImageDataSource?
    private var cancellable: AnyCancellable? = nil

    
    func setDataSource(imageDataSource: ImageDataSource?) {
        self.imageDataSource = imageDataSource
        cancellable = self.imageDataSource?.images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageData in
                self?.image = imageData.image
            }
            
    }
    
    func view() -> UIView {
        return self
    }
    
}
