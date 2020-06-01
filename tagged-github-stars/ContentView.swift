import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack(alignment: .leading) {
            if store.stars.count == 0 {
                Text("Loading stars...")
            }
            
            ForEach(store.stars) {
                Text("Project name: \($0.name), url: \($0.url)")
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
