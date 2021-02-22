//
//  ViewController.swift
//  BoxSDKDemo
//
//  Created by Saven Developer on 2/17/21.
//

import UIKit
import BoxSDK

class ViewController: UIViewController {

    private var btn_serviceCall : UIButton!
    private var btn_Upload : UIButton!
    
    let token = "u8uJeRGHK7T5efr03iGk3v4h72VzERNN"
    override func viewDidLoad() {
        super.viewDidLoad()
       createFolder(withName: "Recordings", parentID: "33333")
    //   loadButton()
    }

    func loadButton(){
        btn_serviceCall = {
            let modalView = UIButton()
            modalView.setTitle("Get Admin", for: .normal)
            modalView.backgroundColor = .blue
            modalView.addTarget(self, action: #selector(serviceCallForGetUser), for: .touchUpInside)
            modalView.translatesAutoresizingMaskIntoConstraints = false
            return modalView
        }()
        btn_Upload = {
            let modalView = UIButton()
            modalView.setTitle("Upload", for: .normal)
            modalView.backgroundColor = .blue
            modalView.addTarget(self, action: #selector(uploadFile), for: .touchUpInside)
            modalView.translatesAutoresizingMaskIntoConstraints = false
            return modalView
        }()
        view.addSubview(btn_serviceCall)
        view.addSubview(btn_Upload)
        btn_serviceCall.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btn_serviceCall.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        btn_serviceCall.widthAnchor.constraint(equalToConstant: 150).isActive = true
        btn_serviceCall.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn_Upload.topAnchor.constraint(equalTo: btn_serviceCall.bottomAnchor, constant:  30).isActive = true
        btn_Upload.leadingAnchor.constraint(equalTo: btn_serviceCall.leadingAnchor).isActive = true
        btn_Upload.widthAnchor.constraint(equalToConstant: 150).isActive = true
        btn_Upload.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func serviceCallForGetUser(){
        //Token = 1IrxHMdBzyYdloDHmItUnPuUtDBxaxaO
         let client = BoxSDK.getClient(token: token)
         client.users.getCurrent(fields:["name", "login"]) { (result: Result<User,BoxSDKError>) in
           guard case let .success(user) = result else {
               print("Error getting user information")
               return
           }
             print("Authenticated as \(String(describing: user.name!))")
         }
        sleep(5)
    }
    
    @objc func uploadFile(){
        let path = Bundle.main.path(forResource: "file", ofType: ".pdf")!
        let url = URL(fileURLWithPath: path)
        let data = NSData(contentsOf: url)
    //    let data = "My test Data".data(using: .utf8)
        
        let client = BoxSDK.getClient(token: token)
        let _: BoxUploadTask = client.files.upload(data: data! as Data, name: "My PDF", parentId: "0") { (result: Result<File, BoxSDKError>) in
            guard case .success( _) = result else {
                print("Error uploading file")
                return
            }

           print("File Uploaded")
        }
    }
    
    func createFolder(withName: String, parentID: String ){
        let client = BoxSDK.getClient(token: token)
        client.folders.create(name: withName, parentId: parentID) { (result: Result<Folder, BoxSDKError>) in
            guard case let .success(folder) = result else {
                print("Error creating folder")
                return
            }

            print("Created folder \"\(folder.name)\" inside of folder \"\(folder.parent?.name)\"")
        }
        sleep(5)
    }
    
//    func  getFiles() {
//        let client = BoxSDK.getClient(token: token)
//
//    }
    
    
}

