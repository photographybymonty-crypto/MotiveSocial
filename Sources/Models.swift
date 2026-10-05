import Foundation

enum SidebarItem: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case create = "Create Post"
    case calendar = "Calendar"
    case scheduled = "Scheduled"
    case media = "Media"
    case campaigns = "Campaigns"
    case connectFacebook = "Connect Facebook"\n    case pages = "Facebook Pages"
    case groups = "Groups"
    case history = "History"
    case settings = "Settings"

    var id: String { rawValue }
}

struct SocialDestination: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var subtitle: String
    var selected: Bool = false
}

struct ScheduledPost: Identifiable {
    let id = UUID()
    var text: String
    var date: Date
    var destinations: [String]
    var status: String
}
