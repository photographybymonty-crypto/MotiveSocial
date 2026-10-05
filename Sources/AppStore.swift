import Foundation
import SwiftUI

final class AppStore: ObservableObject {
    @Published var selectedItem: SidebarItem = .dashboard
    @Published var postText: String = ""
    @Published var selectedImages: [URL] = []
    @Published var scheduleDate: Date = Date().addingTimeInterval(3600)
    @Published var destinations: [SocialDestination] = [
        .init(name: "Motive Green Lawn", subtitle: "Facebook Page", selected: true),
        .init(name: "Motive Green Homes", subtitle: "Facebook Page"),
        .init(name: "Monty's Sweets", subtitle: "Facebook Page")
    ]
    @Published var scheduledPosts: [ScheduledPost] = []

    func queuePost() {
        let chosen = destinations.filter { $0.selected }.map { $0.name }
        guard !postText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !chosen.isEmpty else { return }
        scheduledPosts.insert(
            ScheduledPost(text: postText, date: scheduleDate, destinations: chosen, status: "Scheduled"),
            at: 0
        )
        postText = ""
        selectedImages = []
    }
}
