//
//  FirstViewController.swift
//  Bitdate
//
//  Created by Drew Patel on 5/13/18.
//  Copyright © 2018 Drew Patel. All rights reserved.
//

import UIKit
import stellarsdk
import FontAwesome_swift

class FirstViewController: UITableViewController {

    @IBOutlet weak var firstItemImage: UIImageView!
    @IBOutlet weak var secondItemImage: UIImageView!
    @IBOutlet weak var thirdItemImage: UIImageView!
    
    override func viewDidLoad() {
        // Init the SDK with an url of a horizon server using the testnet
        writeWallet()
        //writeDNA()
        readDNA()
        queryBlockchain()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func queryBlockchain(){
        let sdk = StellarSDK()
        sdk.assets.getAssets(for: "GCWSSMVXQAUWYODSD32IHYUMVCOAYRRRZ3YSYW3QVNTMKOJ3SRYHLZ7I") { (response) -> (Void) in
            switch response {
            case .success(let pageResponse): // PageResponse<AssetResponse>
                for nextAssetResponse in pageResponse.records {
                    print("Asset code: \(nextAssetResponse.assetCode!)")
                    print("Asset issuer: \(nextAssetResponse.assetIssuer!)")
                }
            case .failure(let error):
                StellarSDKLog.printHorizonRequestErrorMessage(tag:"Get assets", horizonRequestError: error)
            }
        }
        
    }
    
    func writeWallet(){
        UserDefaults.standard.set("SD7TNDQ3K35RCB6DQSOXW7CF63IDOXDKCPRUU5N3AI4AGTU4MGMKPK3T", forKey: "privateKey")
    }
    
    func readDNA(){
        var privateKey = UserDefaults.standard.string(forKey: "privateKey")
        let sdk = StellarSDK()
        do {
            let sourceAccountKeyPair = try KeyPair(secretSeed:privateKey!)
            let name = "DNA"
            let value = "GCATTAAGGAGTGCTCTGGGCAGGACAACTCGCATAGTGAGAGTTACATGTTCGTTGGGCTCTT"
            
            // load the account from horizon to be sure that we have the current sequence number.
            sdk.accounts.getAccountDetails(accountId: sourceAccountKeyPair.accountId) { (response) -> (Void) in
                switch response {
                case .success(let accountResponse):
                    do {
                        
                        for (key, value) in accountResponse.data {
                            if(key == "DNA"){
                                print("\(key): \(value.base64Decoded() ?? "")")
                                
                                UserDefaults.standard.set(value.base64Decoded(), forKey: "DNA")
                            
                            }
                        }
                    } catch {
                        // ...
                    }
                case .failure(let error): // error loading account details
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"Error", horizonRequestError: error)
                }
            }
        } catch {
            //handle error
            print(error)
        }
        
    }
    
    func writeDNA(){
        let sdk = StellarSDK()
        do {
            let sourceAccountKeyPair = try KeyPair(secretSeed:"SD7TNDQ3K35RCB6DQSOXW7CF63IDOXDKCPRUU5N3AI4AGTU4MGMKPK3T")
            let name = "DNA"
            let value = "GCATTAAGGAGTGCTCTGGGCAGGACAACTCGCATAGTGAGAGTTACATGTTCGTTGGGCTCTT"
            
            // load the account from horizon to be sure that we have the current sequence number.
            sdk.accounts.getAccountDetails(accountId: sourceAccountKeyPair.accountId) { (response) -> (Void) in
                switch response {
                case .success(let accountResponse):
                    do {
                        // build a manage data operation, provide key and value
                        let manageDataOperation = ManageDataOperation(name:name, data:value.data(using: .utf8))
                        
                        // build the transaction that contains our operation.
                        let transaction = try Transaction(sourceAccount: accountResponse,
                                                          operations: [manageDataOperation],
                                                          memo: Memo.none,
                                                          timeBounds:nil)
                        
                        // sign the transaction.
                        try transaction.sign(keyPair: sourceAccountKeyPair, network: Network.testnet)
                        
                        // submit the transaction to the stellar network.
                        try sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                            switch response {
                            case .success(_):
                                print("Success")
                            case .failure(let error):
                                StellarSDKLog.printHorizonRequestErrorMessage(tag:"Error: ", horizonRequestError:error)
                            }
                        }
                        
                        for (key, value) in accountResponse.data {
                            print("data: \(key) value: \(value.base64Decoded() ?? "")")
                        }
                    } catch {
                        // ...
                    }
                case .failure(let error): // error loading account details
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"Error", horizonRequestError: error)
                }
            }
        } catch {
            //handle error
            print(error)
        }

}
}

