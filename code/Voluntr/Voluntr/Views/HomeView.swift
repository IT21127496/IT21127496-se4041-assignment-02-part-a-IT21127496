

import SwiftUI

struct HomeView: View {
    @State private var selection = 1
    
    var body: some View {
            TabView(selection: $selection){
                EventListView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(0)
                DiscoverView()
                    .tabItem {
                        Label("Discover", systemImage: "map.fill")
                    }
                    .tag(1)
                ProfileView()

                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
                    .tag(2)
            } 
    }
}


#Preview {
    HomeView()
}
