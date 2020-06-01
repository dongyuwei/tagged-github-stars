import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if store.stars.count == 0 {
                    Text("Loading stars...")
                } else {
                    List {
                        ForEach(store.stars) { starItem in
                            NavigationLink(destination: WebView(url: NSURL(string: starItem.url) as! URL)) {
                                RepositoryView(repository: starItem)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                    }.frame(minWidth: 300, maxWidth: 300)
                }
            }.padding(10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
