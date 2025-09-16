import Foundation
import SwiftUI

class LanguageSettings: ObservableObject {
    @AppStorage("language") var language: String = "en" {
        willSet { objectWillChange.send() }
    }
}