import Foundation

public extension String {
    
    var localized: String {
        let userDefault = UserDefaults.standard
        let language = userDefault.string(forKey: "language")
        return NSLocalizedString(self, tableName: language, comment: self)
    }
    
    func localized(withTableName tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: self)
    }
}
