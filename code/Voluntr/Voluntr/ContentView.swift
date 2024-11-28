

import SwiftUI

struct ContentView: View {
    @State private var showMenu = true
    @EnvironmentObject var authService: AuthService
    var body: some View {
        Group {
            if authService.userSession == nil {
                LoginView()
            } else {
                HomeView()
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AuthService())
}
