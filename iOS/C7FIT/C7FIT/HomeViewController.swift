//
//  HomeViewController.swift
//  C7FIT
//
//  Created by Brandon Lee on 12/21/16.
//  Copyright © 2016 Brandon Lee. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 98/255, green: 65/255, blue: 133/255, alpha: 1)
        
        self.view.addSubview(homeView)
        setupConstraints()
        self.view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupConstraints() {
        homeView.translatesAutoresizingMaskIntoConstraints = false
        let topView = homeView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomView = homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let leftView = homeView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightView = homeView.rightAnchor.constraint(equalTo: view.rightAnchor)
        NSLayoutConstraint.activate([topView, bottomView, leftView, rightView])
    }
}
