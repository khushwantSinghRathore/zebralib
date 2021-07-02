import Foundation
import Capacitor


/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ZebraLibPlugin)
public class ZebraLibPlugin: CAPPlugin {
    
    //private var observers: [NSObjectProtocol] = []
    private var zebra = ZebraLib.sharedInstance

//    @objc func echo(_ call: CAPPluginCall) {
//        let value = call.getString("value") ?? ""
//        call.resolve([
//            "value": zebra.echo(value)
//        ])
//    }

    override public func load() {
        print("Loading Zebra plugin")
        //start extension delegate
        zebra.connectionDelegate = self
    }
    
    deinit {
        print("Deinitialize Zebra plugin")
    }

    @objc func connectPrinter(_ call: CAPPluginCall) {
        let config = call.getString("config") ?? ""
        
        let status = zebra.connectPrinter(config)
        if(status){
            call.resolve(["result": status])
        }else{
            call.reject("Failed to connect to printer")
        }
        
//        guard canConnect
//          call.resolve([
//            "result":  zebra.connectPrinter(value)
//        ])
       
    }


    @objc func printText(_ call: CAPPluginCall) {
        let text = call.getString("text") ?? ""
        call.resolve([
            "result": zebra.printText(text)
        ])
    }


    @objc func printPDF(_ call: CAPPluginCall) {
        let base64 = call.getString("base64") ?? ""
//        call.resolve([
//            "result": zebra.printPDF(base64)
//        ])
        
        let status = zebra.printPDF(base64)
        if(status){
            print("ZebraLibPlugin:printPDF() result",status)
            call.resolve(["result": status])
        }else{
            call.reject("Failed to connect to printer")
        }
        
        
    }


}

extension ZebraLibPlugin: EAAccessoryManagerConnectionStatusDelegate {
    func changePrinterStatus() {
        print("changePrinterStatus()----> \(String(describing: zebra.isConnected))")
        notifyListeners("printerStatusChange", data: ["isActive": zebra.isConnected])
    }
}
