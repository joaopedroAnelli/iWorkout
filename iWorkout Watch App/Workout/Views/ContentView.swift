import SwiftUI

/// Root view hosting the navigation stack on watchOS
struct ContentView: View {
    var body: some View {
        NavigationStack {
            StyleListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
