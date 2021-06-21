import Foundation
import Capacitor


/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ZebraLibPlugin)
public class ZebraLibPlugin: CAPPlugin {
    //private let zebra = ZebraLib()
    private var zebra = ZebraLib.sharedInstance

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": zebra.echo(value)
        ])
    }


    @objc func connectPrinter(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
          call.resolve([
            "result":  zebra.connectPrinter(value)
        ])
       
    }


    @objc func printText(_ call: CAPPluginCall) {
        let text = call.getString("text") ?? ""
        call.resolve([
            "result": zebra.printText(text)
        ])
    }


    @objc func printPDF(_ call: CAPPluginCall) {
        let base64 = call.getString("base64") ?? ""
        call.resolve([
            "result": zebra.printPDF(base64)
        ])
    }


}
