import Foundation
import ExternalAccessory
//import MFiBtPrinterConnection

enum CommonPrintingFormat: String {
    case start = "! 0 200 200 150 1"
    case end = "\nFORM\nPRINT\n"
}

@objc public class ZebraLib: NSObject {
    
    var manager: EAAccessoryManager!
    var isConnected: Bool = false
    var connectionDelegate: EAAccessoryManagerConnectionStatusDelegate?
    private var printerConnection: MfiBtPrinterConnection?
    private var serialNumber: String?
    private var disconnectNotificationObserver: NSObjectProtocol?
    private var connectedNotificationObserver: NSObjectProtocol?
    private var zebraPrinter:ZebraPrinter?
    private var zebraPrinterConnection:ZebraPrinterConnection?
    
    public override init() {
        super.init()
        print("::CAPACITOR: ZebraLib.init()")
        initPrinterConnection()
    }
    
    public func initPrinterConnection(){
        manager = EAAccessoryManager.shared()
        self.findConnectedPrinter { [weak self] bool in
            if let strongSelf = self {
                strongSelf.isConnected = bool
            }
        }
        //setup Observer Notifications
        disconnectNotificationObserver = NotificationCenter.default.addObserver(forName: Notification.Name.EAAccessoryDidDisconnect, object: nil, queue: nil, using: didDisconnect)
        connectedNotificationObserver = NotificationCenter.default.addObserver(forName: Notification.Name.EAAccessoryDidConnect, object: nil, queue: nil, using: didConnect)
        manager.registerForLocalNotifications()
        
        print("::CAPACITOR: ZebraLib.initPrinterConnection()")
    }
    
    
    private func didDisconnect(notification: Notification) {
        isConnected = false
        connectionDelegate?.changeLabelStatus()
        print("::CAPACITOR: ZebraLib.didDisconnect()")
    }

    private func didConnect(notification: Notification) {
        isConnected = true
        connectionDelegate?.changeLabelStatus()
        print("::CAPACITOR: ZebraLib.didConnect()")
    }
    
    private func initZebraPrinter() {
        
        DispatchQueue.global(qos: .userInitiated).async
        {
        
            do{
                print("::CAPACITOR: ZebraLib.initZebraPrinter()")
                self.zebraPrinter   =  try? ZebraPrinterFactory.getInstance(self.printerConnection)
                let lang =  self.zebraPrinter?.getControlLanguage()
                print("::CAPACITOR: Printer Lang: \(String(describing: lang))")
            }catch{
                print("ERROR: connectToPrinter \(error)")
            }
            
            DispatchQueue.main.async(execute: {
               // completion(true)
                print("Done assigning printer")
            })
        }
      
    }
    
    private func connectToPrinter( completion: (Bool) -> Void) {
        
        print("::CAPACITOR: connectToPrinter()",serialNumber)
        
        printerConnection = MfiBtPrinterConnection(serialNumber: serialNumber)
        printerConnection?.open()
        printerConnection?.setTimeToWaitAfterWriteInMilliseconds(60)
        initZebraPrinter()
        print("::CAPACITOR: connectToPrinter() COMPLETE" )
        completion(true)
        
    }

    
    @objc public func echo(_ value: String) -> String {
        print("::CAPACITOR: calling Zebralib in echo Swift",value)
//        manager = EAAccessoryManager.shared()
//        printerConnection = MfiBtPrinterConnection(serialNumber: value)
//        printerConnection?.open()
//        printerConnection?.setTimeToWaitAfterWriteInMilliseconds(60)
        printTextLabel(label: value)
        print("::CAPACITOR: Done calling MfiBtPrinterConnection")
        return value
    }
    
    func printTextLabel(label: String){
        if let data = printOneLineText(textContent: label).data(using: .utf8) {
            writeToPrinter(with: data)
        }
    }
    
    private func printOneLineText(textContent: String)->String{
        let firstText = printerTextField(font: 4, size: 0 , x: 30, y: 0, content: textContent)
        return "\(CommonPrintingFormat.start.rawValue) \n\(firstText)\(CommonPrintingFormat.end.rawValue)"
    }
    
    private func printerTextField(font:Int, size: Int, x:Int, y: Int, content: String) -> String {
        return "TEXT \(font) \(size) \(x) \(y) \(content)"
    }

    
    public func writeToPrinter(with data: Data) {
        print(String(data: data, encoding: String.Encoding.utf8) as String?)
        connectToPrinter(completion: { _ in
            var error:NSError?
            printerConnection?.write(data, error: &error)
       
            if error != nil {
                print("Error executing data writing \(String(describing: error))")
            }

        })
    }

    
    private func findConnectedPrinter(completion: (Bool) -> Void) {
        let connectedDevices = manager.connectedAccessories
        for device in connectedDevices {
            if device.protocolStrings.contains("com.zebra.rawport") {
                serialNumber = device.serialNumber
                connectToPrinter(completion: { completed in
                    completion(completed)
                })
            }
        }
    }
}

protocol EAAccessoryManagerConnectionStatusDelegate {
    func changeLabelStatus() -> Void
}

