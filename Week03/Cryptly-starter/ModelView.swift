/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

/*

This is ModelView.swift

I tried to branch out the functions not immediately connected to the View, in the
name of the MVVM design pattern :]

*/

func cutTheComma(_ input: String) -> String {
  if input.hasPrefix(", ") {
    return String(input.suffix(input.count - 2))
  } else {
    return input
  }
}

func getTheListOfCurrencies(filterLogic: FilterLogic, outOfTheseCurrencies cryptodata: [CryptoCurrency]?) -> String {
  var labelToSet: String = ""
  if let unwrappedCryptoData = cryptodata {
    // We use a filter closure to get a new array of assets based on the filter logic
    // We return:
    // - The name of assets which have increased in price OR
    // - The name of assets which have decreased in price OR
    // - All asset names
    // It is built with a switch statement and an enum to make the code more readable
    let conformingAssets = unwrappedCryptoData.filter { asset in
      switch filterLogic {
      case FilterLogic.increased:
        return asset.currentValue > asset.previousValue
      case FilterLogic.decreased:
        return asset.currentValue < asset.previousValue
      case FilterLogic.allAssets:
        return true
      }
    }
    // We prepare the return string (a comma separated list of all assets conforming
    // to the filter logic
    conformingAssets.forEach {
      labelToSet = labelToSet + ", " + $0.name
    }
    return cutTheComma(labelToSet)
  } else {
    // Oops, couldn't unwrap cryptodata!
    return Errors.cantUnwrapCryptodata.rawValue
  }
}
