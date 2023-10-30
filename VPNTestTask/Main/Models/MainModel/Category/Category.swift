import Foundation

struct Category {
  let icon: String
  let title: String
}

extension Category {
  static func getCategory() -> [Category] {
    return [
      Category(icon: "Category_Movie", title: "Movie & TV"),
      Category(icon: "Category_Social", title: "Social"),
      Category(icon: "Category_Browsing", title: "Browsing"),
      Category(icon: "Category_Music", title: "Music"),
      Category(icon: "Category_Sport", title: "Sport"),
      Category(icon: "Category_Gaming", title: "Gaming")
    ]
  }
}
