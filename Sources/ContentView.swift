import SwiftUI
import AppKit

struct ContentView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, selection: $store.selectedItem) { item in
                Label(item.rawValue, systemImage: icon(for: item))
                    .tag(item)
                    .padding(.vertical, 4)
            }
            .navigationTitle("Motive Social")
            .frame(minWidth: 220)
        } detail: {
            switch store.selectedItem {
            case .dashboard: DashboardView()
            case .create: CreatePostView()
            case .scheduled: ScheduledView()
            case .pages: FacebookPagesView()
            case .groups: GroupsView()
            default: PlaceholderView(title: store.selectedItem.rawValue)
            }
        }
    }

    private func icon(for item: SidebarItem) -> String {
        switch item {
        case .dashboard: return "square.grid.2x2"
        case .create: return "square.and.pencil"
        case .calendar: return "calendar"
        case .scheduled: return "clock"
        case .media: return "photo.on.rectangle"
        case .campaigns: return "megaphone"
        case .pages: return "f.circle"
        case .groups: return "person.3"
        case .history: return "clock.arrow.circlepath"
        case .settings: return "gearshape"
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject var store: AppStore
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Dashboard").font(.largeTitle.bold())
            HStack(spacing: 18) {
                StatCard(title: "Scheduled", value: "\(store.scheduledPosts.count)", icon: "clock")
                StatCard(title: "Connected Pages", value: "3", icon: "f.circle")
                StatCard(title: "Media", value: "\(store.selectedImages.count)", icon: "photo")
            }
            Spacer()
        }
        .padding(30)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon).font(.title2)
            Text(value).font(.system(size: 34, weight: .bold))
            Text(title).foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(width: 220, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct CreatePostView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 18) {
                Text("Create Post").font(.largeTitle.bold())

                TextEditor(text: $store.postText)
                    .font(.title3)
                    .padding(12)
                    .frame(minHeight: 180)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(.quaternary))

                HStack {
                    Button("Add Images") { chooseImages() }
                    Text("\(store.selectedImages.count) image(s)")
                        .foregroundStyle(.secondary)
                }

                DatePicker("Schedule", selection: $store.scheduleDate)
                    .datePickerStyle(.compact)

                Text("Destinations").font(.headline)
                ForEach($store.destinations) { $destination in
                    Toggle(isOn: $destination.selected) {
                        VStack(alignment: .leading) {
                            Text(destination.name)
                            Text(destination.subtitle).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }

                HStack {
                    Button("Post Now") { store.queuePost() }
                        .buttonStyle(.borderedProminent)
                    Button("Add to Queue") { store.queuePost() }
                }
                Spacer()
            }
            .padding(28)
            .frame(maxWidth: .infinity)

            Divider()

            VStack(alignment: .leading, spacing: 14) {
                Text("Facebook Preview").font(.headline)
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Circle().frame(width: 38, height: 38)
                        VStack(alignment: .leading) {
                            Text("Motive Green Lawn").bold()
                            Text("Sponsored-style preview").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    Text(store.postText.isEmpty ? "Your post preview will appear here." : store.postText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let first = store.selectedImages.first, let image = NSImage(contentsOf: first) {
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 280)
                    }
                }
                .padding()
                .background(.background, in: RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)
                Spacer()
            }
            .padding(28)
            .frame(width: 420)
            .background(Color(nsColor: .windowBackgroundColor))
        }
    }

    private func chooseImages() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.image]
        if panel.runModal() == .OK {
            store.selectedImages = panel.urls
        }
    }
}

struct ScheduledView: View {
    @EnvironmentObject var store: AppStore
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Scheduled Posts").font(.largeTitle.bold())
            if store.scheduledPosts.isEmpty {
                ContentUnavailableView("No scheduled posts", systemImage: "clock", description: Text("Create a post and add it to the queue."))
            } else {
                List(store.scheduledPosts) { post in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(post.text).lineLimit(2)
                        Text(post.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption).foregroundStyle(.secondary)
                        Text(post.destinations.joined(separator: ", "))
                            .font(.caption2).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .padding(28)
    }
}

struct FacebookPagesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Facebook Pages").font(.largeTitle.bold())
            Text("Connect Facebook to discover and publish to Pages you manage.")
            Button("Connect Facebook") {}
                .buttonStyle(.borderedProminent)
            Text("OAuth and Graph API credentials are intentionally not embedded in this build.")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(28)
    }
}

struct GroupsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Groups Posting Assistant").font(.largeTitle.bold())
            Text("Prepare content for multiple Facebook groups from one workspace.")
            Text("Direct automated group publishing is kept separate from the official Facebook Page API workflow.")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(28)
    }
}

struct PlaceholderView: View {
    let title: String
    var body: some View {
        VStack {
            Text(title).font(.largeTitle.bold())
            Text("Module scaffolded for a future build.").foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
