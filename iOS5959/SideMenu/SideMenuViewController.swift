//
//  SideMenuViewController.swift
//  iOS5959
//
//  Created by 최혜선 on 2019/12/29.
//  Copyright © 2019 5959. All rights reserved.
//

import UIKit
import SideMenu

let selectCollectionNotification = NSNotification.Name(rawValue: "selectCollectionNotification")
let selectWholeCollectionNotification = NSNotification.Name(rawValue: "selectWholeDataNotification")

class SideMenuViewController: UIViewController {
    
    fileprivate var collectionList = Singleton.shared.collectionList
    fileprivate let wholeCollection = CollectionItem(collectionID: -1,
                                                     collectionType: .nonDefaultType,
                                                     title: "전체보기", color: "#000000")
    @IBOutlet fileprivate weak var sideMenuTableView: SideMenuTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionList.insert(wholeCollection, at: 0)
        sideMenuTableView.newCollectDelegate = self
        sideMenuTableView.itemDelegate = self
        sideMenuTableView.collectionList = collectionList
        sideMenuTableView.reloadData()
    }
}

extension SideMenuViewController: SideMenuItemDelegate {
    func modifyCollection(index: Int) {
        showModifyCollectionSetting()
    }
    
    func selectCollection(index: Int) {
        // 콜렉션 선택
        if index == 0 {
            print("전체보기")
            NotificationCenter.default.post(
            name: selectWholeCollectionNotification,
            object: nil,
            userInfo: nil)
        } else {
            print("콜렉션 선택")
            NotificationCenter.default.post(
                name: selectCollectionNotification,
                object: nil,
                userInfo: ["selectCollection": index])
        }
        
        Singleton.shared.currentCollection = collectionList[index]
        SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func showModifyCollectionSetting() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // 삭제
        let deleteAction = UIAlertAction(title: "콜렉션 삭제", style: .destructive) { (_) in
            self.showAlertController(title: "콜렉션 삭제", description: "해당 콜렉션을 삭제하시겠습니까?\n콜렉션 내 모든 상품도 함께 삭제됩니다.")
        }
        // 기본 설정
        let setDefaultAction = UIAlertAction(title: "기본 콜렉션으로 설정", style: .default) { (_) in
            self.showAlertController(title: "기본 콜렉션으로 설정", description: "기본 콜렉션으로 설정하시겠습니까?")
        }
        // 수정
        let modifyAction = UIAlertAction(title: "콜렉션 수정", style: .default) { (_) in
            let modifyCollectionViewController = ModifyCollectionViewController()
            modifyCollectionViewController.editMode = .modify
            DispatchQueue.main.async {
                self.present(modifyCollectionViewController, animated: true, completion: nil)
            }
        }
        // 취소
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(setDefaultAction)
        alertController.addAction(modifyAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertController(title: String?, description message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "예", style: .default) { (_) in
            // TODO: Handler
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SideMenuViewController: SideMenuTableViewDelegate {
    func makeNewCollection() {
        let modifyCollectionViewController = ModifyCollectionViewController()
        modifyCollectionViewController.editMode = .create
        DispatchQueue.main.async {
            self.present(modifyCollectionViewController, animated: true, completion: nil)
        }
    }
}
