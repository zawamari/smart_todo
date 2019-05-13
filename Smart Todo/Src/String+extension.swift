import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "English", comment: self) // Englishは仮置き。UserDefaultsから取得する
    }
    
    func localized(withTableName tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: self)
    }
}
