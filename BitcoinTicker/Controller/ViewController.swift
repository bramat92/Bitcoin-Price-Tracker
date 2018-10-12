//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        index = row
        currencyLabel.text = currencyArray[row]
        getBitCoinData(url: finalURL)
    }
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let symbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    let priceDataModel = PriceDataModel()
    
    var index : Int = 0

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var highestPriceLabel: UILabel!
    @IBOutlet weak var lowestPriceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        updateUI()
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    
    

    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitCoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the BitCoin data")
                    let bitJSON : JSON = JSON(response.result.value!)

                    self.updateBitCoinData(json: bitJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }


    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitCoinData(json : JSON) {
        
        if let bitResult = json["ask"].double {
            
            priceDataModel.currentPrice = bitResult
            priceDataModel.lastPrice = json["last"].doubleValue
            priceDataModel.highestPrice = json["high"].doubleValue
            priceDataModel.lowestPrice = json["low"].doubleValue
            
            updateUI()
            
        } else {
            bitcoinPriceLabel.text = "Price Unavailable"
            lastPriceLabel.text = "Price Unavailable"
            highestPriceLabel.text = "Price Unavailable"
            lowestPriceLabel.text = "Price Unavailable"
            currencyLabel.text = "Currency Unavailable"
        }
    }
    
    func updateUI() {
        
        bitcoinPriceLabel.text = symbolArray[index] + "\(priceDataModel.currentPrice)"
        lastPriceLabel.text = symbolArray[index] + "\(priceDataModel.lastPrice)"
        highestPriceLabel.text = symbolArray[index] + "\(priceDataModel.highestPrice)"
        lowestPriceLabel.text = symbolArray[index]  + "\(priceDataModel.lowestPrice)"
    }
    




}

