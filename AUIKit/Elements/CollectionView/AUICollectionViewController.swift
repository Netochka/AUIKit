//
//  AUICollectionViewController.swift
//  PocketDoc
//
//  Created by branderstudio on 10/29/18.
//  Copyright © 2018 BRANDER. All rights reserved.
//

import UIKit

open class AUICollectionViewController: AUIDefaultScrollViewController {
  
  // MARK: - Proxies
  
  private let delegateProxy = AUICollectionViewDelegateProxy()
  private let dataSourceProxy = AUICollectionViewDataSourceProxy()
  private let dataSourcePrefetchProxy = AUICollectionViewDataSourcePrefetchingProxy()
  private var isBatchUpdates = false
  
  open weak var scrollDelegate: AUIScrollViewDelegate? {
    set { delegateProxy.scrollDelegate = newValue }
    get { return delegateProxy.scrollDelegate }
  }
  open weak var scrollWillBeginDraggingDelegate: AUIScrollWillBeginDraggingDelegate? {
    set { delegateProxy.scrollWillBeginDraggingDelegate = newValue }
    get { return delegateProxy.scrollWillBeginDraggingDelegate }
  }
  
  // MARK: - Controllers
  
  open var cellControllers: [AUICollectionViewCellController] = []
  
  // MARK: - View
  
  open var collectionView: UICollectionView? {
    set { view = newValue }
    get { return view as? UICollectionView }
  }
  
  // MARK: - Setup
  
  override open func setup() {
    super.setup()
    delegateProxy.delegate = self
    dataSourceProxy.delegate = self
    dataSourcePrefetchProxy.delegate = self
  }
  
  override open func setupView() {
    super.setupView()
    collectionView?.dataSource = dataSourceProxy
    collectionView?.delegate = delegateProxy
    collectionView?.prefetchDataSource = dataSourcePrefetchProxy
    collectionView?.reloadData()
  }
  
  override open func unsetupView() {
    collectionView?.dataSource = nil
    collectionView?.delegate = nil
    collectionView?.prefetchDataSource = nil
  }
  
  // MARK: - Reload
  
  open func reload() {
    collectionView?.reloadData()
  }
  
  open func reloadAnimated(oldCount: Int, newCount: Int) {
    isBatchUpdates = true
    let oldIndexPathes = createIndexPathes(count: oldCount)
    let newIndexPathes = createIndexPathes(count: newCount)
    collectionView?.performBatchUpdates({ [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.collectionView?.deleteItems(at: oldIndexPathes)
      strongSelf.collectionView?.insertItems(at: newIndexPathes)
    }, completion: { [weak self] result in
      guard let strongSelf = self else { return }
      strongSelf.isBatchUpdates = false
    })
    
  }
  
  private func createIndexPathes(count: Int, section: Int = 0) -> [IndexPath] {
    var indexPathes: [IndexPath] = []
    for index in 0..<count {
      indexPathes.append(IndexPath(item: index, section: section))
    }
    return indexPathes
  }
}

// MARK: - AUICollectionViewDelegateProxyDelegate

extension AUICollectionViewController: AUICollectionViewDelegateProxyDelegate {
  
  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    cellControllers[indexPath.row].didSelectCell()
  }
  
  open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    cellControllers[indexPath.row].willDisplayCell(cell, indexPath: indexPath)
  }
  
  open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      cellControllers[indexPath.row].didEndDisplayCell()
  }
  
  open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return cellControllers[indexPath.row].size
  }
  
}

// MARK: - AUICollectionViewDataSourceProxyDelegate

extension AUICollectionViewController: AUICollectionViewDataSourceProxyDelegate {
  
  open func numberOfItems(_ collectionView: UICollectionView) -> Int {
    return cellControllers.count
  }
  
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return cellControllers[indexPath.row].cellForRowAtIndexPath(indexPath, collectionView: collectionView)
  }
  
}

// MARK: - AUICollectionViewDataSourcePrefetchingProxyDelegate

extension AUICollectionViewController: AUICollectionViewDataSourcePrefetchingProxyDelegate {
  
  open func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    
  }
  
}
