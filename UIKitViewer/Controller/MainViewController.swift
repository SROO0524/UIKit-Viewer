//
//  ViewController.swift
//  UIKitViewer
//
//  Created by cskim on 2020/01/31.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  let flowLayout = UICollectionViewFlowLayout()
  lazy var collectionView = UICollectionView(
    frame: view.frame , collectionViewLayout: flowLayout
  )
  let objects = properties.keys
    .filter { $0 != "UICollectionViewFlowLayout" && $0 != "CALayer" }
    .sorted()
  
  private enum UI {
    static let itemSpacing: CGFloat = 10.0
    static let lineSpacing: CGFloat = 10.0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupCollectionView()
    setupFlowLayout()
  }
  
  private func setupUI() {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    self.navigationItem.title = "UIKit Viewer"
  }
  
  private func setupCollectionView() {
    
    collectionView.backgroundColor = ColorReference.background
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: ThumbnailCell.identifier)
    view.addSubview(collectionView)
  }
  
  private func setupFlowLayout() {
    flowLayout.itemSize = CGSize(width: collectionView.frame.width / 2 - (UI.itemSpacing * 2.5),
                                 height: 180)
    flowLayout.minimumInteritemSpacing = UI.itemSpacing
    flowLayout.minimumLineSpacing = UI.lineSpacing
    flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
  }
}
//MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return objects.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.identifier, for: indexPath) as! ThumbnailCell
    cell.configure(title: objects[indexPath.item])
    return cell
  }
}
//MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let object = ObjectType(rawValue: objects[indexPath.item]) else { return }
    let operationVC = OperationViewController()
    ObjectManager.shared.object = object
    navigationController?.pushViewController(operationVC, animated: true)
  }
}