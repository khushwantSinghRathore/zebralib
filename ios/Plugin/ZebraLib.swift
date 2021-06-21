import Foundation
import ExternalAccessory
import UIKit

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
    static let sharedInstance = ZebraLib()
    
    public override init() {
        super.init()
        print("::CAPACITOR: ZebraLib.init()")
 
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
    
    deinit {
        if let disconnectNotificationObserver = disconnectNotificationObserver {
            NotificationCenter.default.removeObserver(disconnectNotificationObserver)
        }
        if let connectedNotificationObserver = connectedNotificationObserver {
            NotificationCenter.default.removeObserver(connectedNotificationObserver)
        }
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
    
    func closeConnectionToPrinter() {
        printerConnection?.close()
    }

    
    func printBase64PDFPages(base64: String){

        let pdfDoc:CGPDFDocument = base64TOPDFDoc(base64String: base64)
        if(pdfDoc.numberOfPages>0){
            for n in 1...(pdfDoc.numberOfPages) {
                print("PDF page:\(n)")
                //convert pdf page to an image
                let imagePDF = pdfPageToImage(pdfPage: pdfDoc.page(at: n)!)
                //displayPDFPage(imagePage: imagePDF)
     
                printImage(image: imagePDF)
            }
        }
        
    }
    
    func pdfPageToImage(pdfPage:CGPDFPage) -> UIImage{
        
        let pageRect = pdfPage.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
              UIColor.white.set()
              ctx.fill(pageRect)

              ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
              ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

              ctx.cgContext.drawPDFPage(pdfPage)
          }

        return img;
    }
    
    func base64TOPDFDoc(base64String: String?) -> CGPDFDocument{
        
        let dataDecodedPDF = NSData(base64Encoded: base64String!, options: NSData.Base64DecodingOptions(rawValue: 0))!
        
        let pdfData = dataDecodedPDF as CFData
        let provider:CGDataProvider = CGDataProvider(data: pdfData)!
        let pdfDoc:CGPDFDocument = CGPDFDocument(provider)!
        
        return pdfDoc
     }
    
    func printImage(image: UIImage){
        do {
            weak var graphicsUtil = self.zebraPrinter?.getGraphicsUtil()

            //paper size 384x288 per sq in
            var success = try graphicsUtil?.print(
                image.cgImage,
                atX: 0,
                atY: 0,
                withWidth: 768,
                withHeight: 576,
                andIsInsideFormat: false)
            
            print("print status: \(String(describing: success))")
        } catch {
            print("ERROR:")
        }
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
        print("::CAPACITOR: writeToPrinter()")
        print(String(data: data, encoding: String.Encoding.utf8) as String?)
        connectToPrinter(completion: { _ in
            var error:NSError?
            printerConnection?.write(data, error: &error)
       
            if error != nil {
                print("Error executing data writing \(String(describing: error))")
            }
            print("::CAPACITOR: ================================= done printing ================================================")
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

    @objc public func echo(_ value: String) -> String {
        print("::CAPACITOR: echo() - ")
        initPrinterConnection();
        return value
    }

    @objc public func printPDF(_ base64: String) -> String {
        print("::CAPACITOR: printPDF() - ",base64)
        printBase64PDFPages(base64: base64)
        return "some result"
    }


    @objc public func printText(_ text: String) -> String {
        print("::CAPACITOR: printText() - calling Zebralib in echo Swift",text)
        printTextLabel(label: text)
        print("::CAPACITOR: printText() - Done calling MfiBtPrinterConnection")
        return "some result=" + text;
    }

    @objc public func connectPrinter(_ value: String) -> String {
        print("::CAPACITOR: Done connectPrinter()")
        initPrinterConnection();
         return "some result"
     }

}

protocol EAAccessoryManagerConnectionStatusDelegate {
    func changeLabelStatus() -> Void
}

extension ZebraLib: EAAccessoryManagerConnectionStatusDelegate {
    func changeLabelStatus() {

        print("changeLabelStatus()----> \(String(describing: isConnected))")
    }
}
