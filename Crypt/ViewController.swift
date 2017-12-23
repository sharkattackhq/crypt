//
//  ViewController.swift
//  Crypt
//
//  Created by Admin on 20/12/2017.
//  Copyright © 2017 Admin. All rights reserved.
//
import Foundation
import Cocoa


var fromArray = [String]()
var toArray = [String]()

var wallets:[Wallet] = []
var balances:[Balance] = []
var coinData = [String: NSDictionary]();

class ViewController: NSViewController {
    
    var timer = Timer()
    
    var counter: Int = 0
    
    
    @IBOutlet var fiatButtonView: NSButton!
    
    @IBOutlet var coinButtonView1: NSButton!
    
    @IBOutlet var coinButtonView2: NSButton!
    
    @IBOutlet var coinButtonView3: NSButton!


    @IBAction func toggleFiatCurrency(_ sender: Any) {
        self.toggleFiatView()
    }
    
    @objc dynamic var currencies: [Currency] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataFetchScheduler()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func getCurrencyData(){
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/all/coinlist") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let JSONData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let currencyData = JSONData as? NSDictionary {
                        let currenciesTemp = currencyData["Data"] as! NSDictionary
                        self.getCurrencyList(data: currenciesTemp)
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
        
    }
    
    func getCurrencyList(data: NSDictionary) {
        
        for (key, value) in data {
            var iconPath: String = ""
            let coinCode: String = key as! String
            var coinName: String = ""
            for (k, v) in value as! NSDictionary {
                if(k as! String == "CoinName") {
                    coinName = v as! String
                }
                if(k as! String == "ImageUrl") {
                    iconPath = v as! String
                }
            }
            let newCurrency = Currency()
                newCurrency.iconPath = iconPath
                newCurrency.coinCode = coinCode
                newCurrency.coinName = coinName
            
            currencies.append(newCurrency)
        }
        print(currencies)
        for currency in currencies {
            print(currency.iconPath) 
            print(currency.coinName)
            print(currency.coinCode)
        }
        print("Finished Currecny List")
    }
    
    
    
    func dataFetchScheduler() {
        
        
        
        fromArray.append("BTC")
        fromArray.append("LTC")
        fromArray.append("ETH")
        
        toArray.append("GBP")
        toArray.append("AUD")
        toArray.append("USD")
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.getCoinData), userInfo: nil, repeats: true)
    }
    
    @objc func getCoinData() {
        
        let toCurrencies :String = toArray.joined(separator:",")
        
        for coin in fromArray {
            
            guard let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=" + coin + "&tsyms=" + toCurrencies) else { return }
            
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let JSONData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        if let cnData = JSONData as? NSDictionary {
                            coinData[coin] = cnData
                            self.fiatButtonView.title = toArray[self.counter]
                            self.updateCoinView()
                        }
                    } catch {
                        print(error)
                    }
        
                }
            }.resume()
        
        }
        
    }
    
    func formatNumber(number: NSNumber) -> String {
        let num = number as! NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: (num))
        return formattedNumber!
    }
    
    func updateCoinView() {
        for (key, value) in coinData {
          
            if(key == "BTC") {
                if(self.coinButtonView1 != nil) {
                    self.coinButtonView1.title = "\(key) \(self.formatNumber(number: value[toArray[counter]]! as! NSNumber))"
                }
            }
            if(key == "LTC") {
                if(self.coinButtonView2 != nil) {
                    self.coinButtonView2.title = "\(key) \(self.formatNumber(number: value[toArray[counter]]! as! NSNumber))"
                }
            }
            if(key == "ETH") {
                if(self.coinButtonView3 != nil) {
                   self.coinButtonView3.title = "\(key) \(self.formatNumber(number: value[toArray[counter]]! as! NSNumber))"
                }
                
            }
        }
    }
    
    func toggleFiatView(){
        if counter < (toArray.count - 1) {
            counter += 1
        } else {
            counter = 0
        }
        self.fiatButtonView.title = toArray[counter] // this is gbp
        for (key, value) in coinData {
            print("\(key) \(String(describing: value[toArray[counter]]))")
            if(key == "BTC") {
                
                self.coinButtonView1.title = "\(key) \(self.formatNumber(number: value[toArray[counter]]! as! NSNumber))"

            }
            if(key == "LTC") {
                self.coinButtonView2.title = "\(key) \(self.formatNumber(number: value[toArray[counter]]! as! NSNumber))"
            }
            if(key == "ETH") {
                self.coinButtonView3.title = "\(key) \(self.formatNumber(number: value[toArray[counter]]! as! NSNumber))"
            }
        }
    }

    
//    func getWalletData() {
//
//        let ltc = Wallet()
//        ltc.network = "ltc"
//        ltc.address = ""
//
//        let btc = Wallet()
//        btc.network = "btc"
//        btc.address = ""
//
//        let eth = Wallet()
//        eth.network = "eth"
//        eth.address = ""
//
//        let ltc2 = Wallet()
//        ltc2.network = "ltc"
//        ltc2.address = ""
//
//        wallets.append(ltc)
//        wallets.append(btc)
//        wallets.append(eth)
//        wallets.append(ltc2)
//
//
//        for wallet in wallets {
//            print("geting")
//            guard let url = URL(string: "https://api.blockcypher.com/v1/btc/17SVs85gMnbBi41rCMfYgm4gmyuxoz6jAH") else { return }
//
//            let session = URLSession.shared
//            session.dataTask(with: url) { (data, response, error) in
//                if let data = data {
//                    do {
//                        let JSONData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                        if let dataTemp = JSONData as? NSDictionary {
//                            print(dataTemp)
//                            //                        let data = dataTemp as! NSDictionary
//                            //                        self.getCurrencyList(data: currenciesTemp)
//                        }
//                    } catch {
//                        print(error)
//                    }
//                }
//                }.resume()
//        }
//    }
    
}

