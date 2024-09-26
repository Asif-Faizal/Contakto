import Flutter
import UIKit
import Contacts

public class SwiftContactorPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "contact_fetcher", binaryMessenger: registrar.messenger())
        let instance = SwiftContactorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getContacts" {
            fetchContacts(result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func fetchContacts(result: @escaping FlutterResult) {
        let store = CNContactStore()
        
        // Request access to contacts
        store.requestAccess(for: .contacts) { (granted, error) in
            DispatchQueue.main.async {
                if granted {
                    var contacts = [[String: String]]()
                    let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
                    let request = CNContactFetchRequest(keysToFetch: keys)
                    
                    do {
                        try store.enumerateContacts(with: request) { (contact, stop) in
                            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                                let contactDict: [String: String] = [
                                    "name": contact.givenName,
                                    "number": phoneNumber
                                ]
                                contacts.append(contactDict)
                            }
                        }
                        result(contacts) // Return the contacts
                    } catch {
                        result(FlutterError(code: "FETCH_ERROR", message: "Failed to fetch contacts", details: nil))
                    }
                } else {
                    // Permission denied
                    print("Permission denied: \(String(describing: error))")
                    result(FlutterError(code: "PERMISSION_DENIED", message: "Permission denied", details: nil))
                }
            }
        }
    }
}
