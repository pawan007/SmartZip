/*
* Copyright (c) 2016 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation

public struct RageProducts {
  
  // TODO:  Change this to the BundleID chosen when registering this app's App ID in the Apple Member Center.
  private static let Prefix = "com.SmartZip.app."
  
  public static let Threemonthsdeal             = Prefix + "threemonthsdeal"
  public static let Twelvemonthsdeal             = Prefix + "twelvemonthsdeal"
 
  
  private static let productIdentifiers: Set<ProductIdentifier> = [
                                                                   RageProducts.Threemonthsdeal,
                                                                   RageProducts.Twelvemonthsdeal,
                                                                   ]

  public static let store = IAPHelper(productIds: RageProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
   return productIdentifier.componentsSeparatedByString(".").last
    //return ""
}
