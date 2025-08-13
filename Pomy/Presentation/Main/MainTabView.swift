import SwiftUI

struct MainTabView: View {
    // タブの選択を管理。文字列や列挙型で管理できるが、今回はシンプルにIntを使う例
    @State private var selectedTab = 1  // HomeViewを1としてデフォルト選択

    var body: some View {
        TabView(selection: $selectedTab) {
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(0) // Calendarはタグ0

            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(1) // Homeはタグ1（デフォルト）

            SearchDeviceView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Setting")
                }
                .tag(2) // Settingはタグ2
        }
        .tint(.red)
    }
}

#Preview {
    MainTabView()
        .environmentObject(BLEManager())
}
