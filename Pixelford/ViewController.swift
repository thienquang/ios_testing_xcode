//
//  ViewController.swift
//  Pixelford
//
//  Created by Ron Buencamino on 11/2/17.
//  Copyright © 2017 Ron Buencamino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var navBarImage:UIImageView {
        return UIImageView(image: UIImage(named: "Wordmark-Only")!)
    }
    
    var menuItems:[String] {
        return [
            "Your Library",
            "Pixelford Store"
        ]
    }
    
    var menuColors:[UIColor] {
        return [
            Colors.mediumPurple,
            Colors.mediumGray,
            Colors.lightBrown
        ]
    }
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        self.navigationItem.titleView = navBarImage
        self.navigationController?.navigationBar.barTintColor = Colors.lightGray
        self.view.backgroundColor = Colors.darkGray
        tableView.backgroundColor = Colors.darkGray
    }
    
    func presentStore() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreTableView") as? StoreTableViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func presentLibrary() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LibraryController") as? LibraryController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell!.backgroundColor = menuColors[indexPath.section]
        
        let label = cell!.viewWithTag(1) as! UILabel
        label.text = menuItems[indexPath.section]
        label.textColor = UIColor.white
        
        cell!.layer.borderColor = Colors.lightGray.cgColor
        cell!.layer.borderWidth = 1.0
        cell!.layer.cornerRadius = 5.0
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            presentLibrary()
        case 1:
            presentStore()
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

