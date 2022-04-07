import Contacts
import PhoneNumberKit

struct Contact {
    let name: String
    let phone: String
    let image: Data?
}

class ContactsService {
    
    static var authorizationStatus: CNAuthorizationStatus = {
        return CNContactStore.authorizationStatus(for: .contacts)
    }()
    
    static func getContactsNumber() -> [String] {
        let contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]

            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                log.error("Error fetching containers")
            }

            var results: [CNContact] = []

            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    log.error("Error fetching results for container")
                }
            }

            return results
        }()

        var phones = [String]()
        for contact in contacts {
            for phone in contact.phoneNumbers {
                phones.append(phone.value.stringValue)
            }
        }

        return phones
    }
    
    static func getContacts(completion: @escaping([Contact]) -> Void) {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactImageDataKey,
            CNContactThumbnailImageDataKey] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            log.error("Error fetching containers")
        }

        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                log.error("Error fetching results for container")
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            var contacts: [Contact] = []
            results.forEach { contact in
                contact.phoneNumbers.forEach { phone in
                    guard let phoneNumber = try? PhoneNumberKit().parse(phone.value.stringValue) else {
                        return
                    }
                    
                    let numberString = "+\(phoneNumber.countryCode)\(phoneNumber.nationalNumber)"
                    let fullName = CNContactFormatter.string(from: contact, style: .fullName)
                    let imageData = contact.imageDataAvailable ? contact.thumbnailImageData : nil
                    contacts.append(Contact(name: fullName ?? "", phone: numberString, image: imageData))
                }
            }
            
            DispatchQueue.main.async {
                completion(contacts.sorted(by: { $0.name < $1.name }))
            }
        }
    }
}
