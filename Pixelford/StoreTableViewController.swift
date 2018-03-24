//
//  StoreTableViewController.swift
//  Pixelford
//
//  Created by Ron Buencamino on 11/2/17.
//  Copyright © 2017 Ron Buencamino. All rights reserved.
//

import UIKit
import StoreKit

class StoreTableViewController: UITableViewController {
    
    var navBarImage:UIImageView {
        return UIImageView(image: UIImage(named: "Icon-Only")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        self.navigationItem.titleView = navBarImage
        self.tableView.backgroundColor = Colors.darkGray
        
        let restore = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restorePurchases))
        self.navigationItem.rightBarButtonItem = restore
    }
    
    @objc func dismissFromPresentingViewController() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func restorePurchases() {
        IAPManager.sharedInstance.restorePreviousPurchases()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return IAPManager.sharedInstance.products.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.layer.borderColor = Colors.mediumGray.cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 5.0
        cell.backgroundColor = Colors.lightGray
        
        let title = cell.viewWithTag(1) as! UILabel
        title.textColor = Colors.darkGray
        
        let description = cell.viewWithTag(2) as! UILabel
        description.textColor = Colors.darkGray
        
        let price = cell.viewWithTag(3) as! UILabel
        price.textColor = Colors.mediumPurple
        
        let product = IAPManager.sharedInstance.products[indexPath.section]
        
        title.text = product.localizedTitle
        description.text = product.localizedDescription
        price.text = ProductManager.priceStringForProduct(locale: product.priceLocale, price: product.price)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = IAPManager.sharedInstance.products[indexPath.section]
        IAPManager.sharedInstance.createPaymentRequestForProduct(product: product)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

