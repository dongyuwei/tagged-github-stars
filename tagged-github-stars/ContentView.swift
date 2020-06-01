import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Loading stars...")
            ForEach(store.stars, id: \.self) {
                Text("Project name: \($0.name), url: \($0.url)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
