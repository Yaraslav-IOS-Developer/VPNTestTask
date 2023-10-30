
import Foundation

struct MenuItem {
  let imageName: String
  let title: String
}

extension MenuItem {
  static func getMenuItem() -> [MenuItem] {
    return [
      MenuItem(imageName: "Menu_Restore_Purchase", title: "Restore Purchase"),
      MenuItem(imageName: "Menu_Share_app", title: "Share App"),
      MenuItem(imageName: "Menu_Contact_Us", title: "Contact Us"),
      MenuItem(imageName: "Menu_Privacy_Policy", title: "Privacy Policy"),
      MenuItem(imageName: "Menu_Term_Of_Use", title: "Terms Of Use"),
      MenuItem(imageName: "Menu_About_Subscription", title: "About Subsription")
    ]
  }
}
