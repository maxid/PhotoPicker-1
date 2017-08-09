//
//  PhotoPickerController.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/5.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

enum PageType{
    case List
    case RecentAlbum
    case AllAlbum
}

protocol PhotoPickerControllerDelegate: class{
    func onImageSelectFinished(images: [PHAsset])
}

class PhotoPickerController: UINavigationController {
    
    // the select image max number
    static var imageMaxSelectedNum = 4
    
    // already select total
    static var alreadySelectedImageNum = 0
    
    
    weak var imageSelectDelegate: PhotoPickerControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(type:PageType){
        let rootViewController = PhotoAlbumsTableViewController(style:.plain)
        // clear cache
        PhotoImage.instance.selectedImage.removeAll()
        super.init(rootViewController: rootViewController)
        
        if type == .RecentAlbum || type == .AllAlbum {
            let currentType = type == .RecentAlbum ? PHAssetCollectionSubtype.smartAlbumRecentlyAdded : PHAssetCollectionSubtype.smartAlbumUserLibrary
            let results = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype:currentType, options: nil)
            if results.count > 0 {
                if let model = self.getModel(collection: results[0]) {
                    if model.count > 0 {
                        let layout = PhotoCollectionViewController.configCustomCollectionLayout()
                        let controller = PhotoCollectionViewController(collectionViewLayout: layout)
                        
                        controller.fetchResult = model as? PHFetchResult<PHObject>;
                        self.pushViewController(controller, animated: false)
                    }
                }
            }
        }
    }
    
    
    private func getModel(collection: PHAssetCollection) -> PHFetchResult<PHAsset>?{
        let fetchResult = PHAsset.fetchAssets(in: collection, options: PhotoFetchOptions.shareInstance)
        if fetchResult.count > 0 {
            return fetchResult
        }
        return nil
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func imageSelectFinish(){
        if self.imageSelectDelegate != nil {
            self.dismiss(animated: true, completion: nil)
            self.imageSelectDelegate?.onImageSelectFinished(images: PhotoImage.instance.selectedImage)
        }
    }
    
    
    

}
