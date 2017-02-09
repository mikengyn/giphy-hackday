//
//  ViewController.swift
//  Sample
//
//  Created by Michael Nguyen on 2017-02-08.
//  Copyright © 2017 AsyncDisplayKit. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ViewController: UIViewController, MosaicCollectionViewLayoutDelegate, ASCollectionDelegate, ASCollectionDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    
    var _sections = [[JMGiphy]]()
    let _collectionNode: ASCollectionNode!
    let _layoutInspector = MosaicCollectionViewLayoutInspector()
    lazy var searchBar:UISearchBar = UISearchBar()
    var inSearchMode: Bool = false
    var sectionTitleName = "Trending GIFs"
    
    // mock data
    let gif1 = JMGiphy(name: "", url: "", previewUrl: "https://media2.giphy.com/media/suz7EO1YweWfC/giphy-downsized.gif", width: 250, height: 140)
    let gif2 = JMGiphy(name: "", url: "", previewUrl: "https://media4.giphy.com/media/l3q2IvVBwYBneYlu8/200w.gif", width: 200, height: 112)
    let gif3 = JMGiphy(name: "", url: "", previewUrl: "https://media2.giphy.com/media/1hVi7JFFzplHW/200w.gif", width: 200, height: 150)
    let gif4 = JMGiphy(name: "", url: "", previewUrl: "https://media3.giphy.com/media/Y5GVgQZCluUWQ/200w.gif", width: 200, height: 184)
    
    var gifs: [JMGiphy] = []    // Load all our JMGiphy objects here
    
    required init?(coder aDecoder: NSCoder) {
        let layout = MosaicCollectionViewLayout()
        
        // Customize spacing and insets of the collection view
        layout.numberOfColumns = 2
        layout.columnSpacing = 6
        layout.headerHeight = 40.0 //viewcontroller
        layout._sectionInset = UIEdgeInsetsMake(10.0, 0, 10.0, 0)
        layout.interItemSpacing = UIEdgeInsetsMake(6, 0, 6, 0)
        _collectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(coder: aDecoder)
        layout.delegate = self
        
        // Mock data
        self.gifs = [gif1, gif2, gif3, gif4, gif1, gif2, gif3, gif4, gif1, gif2, gif1, gif2, gif3, gif4, gif1, gif2, gif1, gif2, gif3, gif4, gif1, gif2]
        self.loadGifs()
        
        _collectionNode.dataSource = self
        _collectionNode.delegate = self
        _collectionNode.view.layoutInspector = _layoutInspector
        _collectionNode.backgroundColor = .white
        _collectionNode.view.isScrollEnabled = true
        _collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
    }
    
    deinit {
        _collectionNode.dataSource = nil
        _collectionNode.delegate = nil
    }
    
    func loadGifs(){
        _sections.append([]);
        for idx in 0 ..< gifs.count {
            _sections[0].append(gifs[idx])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubnode(_collectionNode!)
        self.layoutSearchBar()
    }
    
    override func viewWillLayoutSubviews() {
        _collectionNode.frame = self.view.bounds;
    }
    
    // Renders a search bar in the navigation Bar
    func layoutSearchBar(){
        
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = " Search GIPHY..."
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        self.toggleCancelButton(inSearchMode: false)
    }
    
    
    // Logic to toggle the Cancel/Done button, overriding the default behaviours
    func toggleCancelButton(inSearchMode: Bool){
        
        for subView in self.searchBar.subviews {
            for view in subView.subviews {
                if view.isKind(of:NSClassFromString("UIButton")!) {
                    if let cancelButton = view as? UIButton {
                        var cancelText = ""
                        cancelText = (inSearchMode) ? "Cancel" : "Done"
                        cancelButton.setTitle(cancelText, for: .normal)
                        cancelButton.titleLabel?.lineBreakMode = .byClipping
                        searchBar.setNeedsLayout()
                        cancelButton.isEnabled = true
                        self.inSearchMode = inSearchMode
                    }
                    
                }
            }
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let giphyObject = _sections[indexPath.section][indexPath.item]
        return GifCellNode(with: giphyObject)
    }
    
    
    // Collection view Header
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        let textAttributes : NSDictionary = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
            NSForegroundColorAttributeName: UIColor.gray
        ]
        let textInsets = UIEdgeInsets(top: 6, left: 11, bottom: 6, right: 0)
        let textCellNode = ASTextCellNode(attributes: textAttributes as! [AnyHashable : Any], insets: textInsets)
        //        textCellNode.text = String(format: "Section %zd", indexPath.section + 1)
        textCellNode.text = self.sectionTitleName
        
        return textCellNode;
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return _sections.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return _sections[section].count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout: MosaicCollectionViewLayout, originalItemSizeAtIndexPath: IndexPath) -> CGSize {
        
        let currentGif = _sections[originalItemSizeAtIndexPath.section][originalItemSizeAtIndexPath.item]
        return CGSize(width: currentGif.width, height: currentGif.height)
    }
    
    // Enables infinite scrolling
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return true
    }
    
    // Load more gifs (Pagination) - triggered when user is scrolling towards the bottom of the collection view
    func loadMore(context: ASBatchContext){
        
        // Load more Gifs, append them to our dataSource and insert the items into the collectionView
        
        // Perform more API calls to get the next page of gifs
        let newGifs = [gif1, gif2]
        var indexes: [IndexPath] = []
        
        for (_, gif) in newGifs.enumerated() {
            _sections[0].append(gif)
            indexes.append(IndexPath(item: _sections[0].count - 1, section: 0)) // Insert rows into the bottom
        }
        
        DispatchQueue.main.async {
            self._collectionNode.insertItems(at: indexes)
            context.completeBatchFetching(true) // required
        }
    }
    
    // Trigger loading of more gifs while scrolling
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        self.loadMore(context: context)
    }
    
    
    // Search bar Delegate Methods
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.toggleCancelButton(inSearchMode: true)
        return true
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.toggleCancelButton(inSearchMode: false)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // Searching
        if (self.inSearchMode == true){
            self.searchBar.text = nil
            self.searchBar.endEditing(true) // This will call DidEndEditing
            self.toggleCancelButton(inSearchMode: false)
            
        } else {
            // Dismiss presented VC
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        self.toggleCancelButton(inSearchMode: false)
        
        // Perform search calls, reload the collection view with our new datasource!
        
    }
    
    // hide the keyboard when scrolling and when the search field is empty
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.searchBar.resignFirstResponder()
    }
    
}

