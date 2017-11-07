//
//  LibraryDetailView.swift
//  Pixelford
//
//  Created by Ron Buencamino on 11/3/17.
//  Copyright © 2017 Ron Buencamino. All rights reserved.
//

import UIKit

class LibraryDetailView: UIViewController {
    
    var navBarImage:UIImageView {
        return UIImageView(image: UIImage(named: "Icon-Only")!)
    }
    
    @IBOutlet weak var toolbar:UIToolbar!
    
    var selectedImage:UIImage?
    
    @IBOutlet fileprivate weak var imageView:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        checkForUnlockedFilters()
    }
    
    func setupView() {
        self.navigationItem.titleView = navBarImage
        self.navigationItem.rightBarButtonItem = uploadButton()
        self.view.backgroundColor = Colors.darkGray
        
        imageView.image = selectedImage
        
        toolbar.setItems(toolbarItems(), animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Upload button
    func uploadButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(image: UIImage(named: "Upload"), style: .plain, target: self, action: #selector(uploadImage))
        button.tintColor = Colors.darkGray
        return button
    }
    
    @objc func uploadImage() {
        showPurchaseAlert()
    }
    
    func showPurchaseAlert() {
        let alert = UIAlertController(title: "Need Credits", message: "You need to purchase more credits to use this feature. Please visit our store.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Filter toolbar
    func toolbarItems() -> [UIBarButtonItem] {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let copy = UIBarButtonItem(image: UIImage(named: "Filter-Copy"), landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
        copy.tintColor = Colors.darkGray
        let layer = UIBarButtonItem(image: UIImage(named: "Filter-Layer"), landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
        layer.tintColor = Colors.darkGray
        
        return [copy, layer, flexibleSpace]
    }
    
    func checkForUnlockedFilters() {
        
    }
}
