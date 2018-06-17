//
//  BaseController.swift
//  ScalingCarousel
//
//  Created by Matthew Yannascoli on 10/21/17.
//  Copyright © 2017 RGA. All rights reserved.
//

import UIKit

class BaseController: UIViewController {
    fileprivate let collectionView: UICollectionView = {
        let layout = ScaleInFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.itemSpacing = 50
        layout.maxScale = 1.5
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let verticalBoundaryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let horizontalBoundaryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        wire()
    }
    
    fileprivate func randomColor() -> UIColor {
        let hex = arc4random_uniform(0xFFFFFF)
        let redComponent = (hex & 0xFF0000) >> 16
        let greenComponent = (hex & 0x00FF00) >> 8
        let blueComponent = hex & 0x0000FF
        
        let r = CGFloat(redComponent)/255.0
        let g = CGFloat(greenComponent)/255.0
        let b = CGFloat(blueComponent)/255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate -
extension BaseController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dequeued = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CELL", for: indexPath) as? ScalingCell
        
        guard let cell = dequeued else {
            preconditionFailure("")
        }
        
        cell.backgroundColor = randomColor()
        return cell
    }
}


//MARK: - Layout -
extension BaseController {
    fileprivate func layout() {
        view.addSubview(verticalBoundaryView)
        verticalBoundaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verticalBoundaryView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        verticalBoundaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(horizontalBoundaryView)
        horizontalBoundaryView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        horizontalBoundaryView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        horizontalBoundaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.backgroundColor = .green
        view.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true        
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

//MARK: - Wire -
extension BaseController {
    fileprivate func wire() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ScalingCell.self, forCellWithReuseIdentifier: "CELL")
    }
}
