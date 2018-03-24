//
//  LibraryController.swift
//  Pixelford
//
//  Created by Ron Buencamino on 11/3/17.
//  Copyright © 2017 Ron Buencamino. All rights reserved.
//

import UIKit

class LibraryController: UITableViewController {
    
    var navBarImage:UIImageView {
        return UIImageView(image: UIImage(named: "Icon-Only")!)
    }
    
    var small_images:[UIImage] {
        return [
            UIImage(named: "01_sm.png")!,
            UIImage(named: "02_sm.png")!,
            UIImage(named: "03_sm.png")!,
            UIImage(named: "04_sm.png")!,
            UIImage(named: "05_sm.png")!
        ]
    }
    
    var large_images:[UIImage] {
        return [
            UIImage(named: "01_lg.png")!,
            UIImage(named: "02_lg.png")!,
            UIImage(named: "03_lg.png")!,
            UIImage(named: "04_lg.png")!,
            UIImage(named: "05_lg.png")!
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        self.navigationItem.titleView = navBarImage
        self.tableView.backgroundColor = Colors.darkGray
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return small_images.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.backgroundColor = Colors.darkGray
        cell?.layer.borderColor = Colors.mediumGray.cgColor
        cell?.layer.borderWidth = 1.0
        cell?.layer.cornerRadius = 5.0
        
        let imageView = cell?.viewWithTag(1) as! UIImageView
        imageView.image = small_images[indexPath.section]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LibraryDetailView") as? LibraryDetailView {
            vc.selectedImage = large_images[indexPath.section]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
