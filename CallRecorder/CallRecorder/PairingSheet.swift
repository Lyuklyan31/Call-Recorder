import SwiftUI

struct PairingSheet<SheetContent: View>: ViewModifier {
    @Binding var isShowing: Bool
    var isExpandedByDefault: Bool
    let title: String
    var description: String?
    var closeAction: (() -> Void)?
    let sheetContent: SheetContent
    
    private var defaultDetent: PresentationDetent
    
    @State private var detent: PresentationDetent
    
    private var detents: Set<PresentationDetent> {
        [defaultDetent] 
    }
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isShowing ? 3.0 : 0)
            .sheet(isPresented: $isShowing) {
                VStack {
                    sheetContent
                }
                .background {
                    GeometryReader { _ in
                        Rectangle()
                            .fill(Color.white)
                    }
                }
                .presentationDetents(detents, selection: $detent)
                .presentationDragIndicator(.hidden) 
                .presentationBackground(Color.white)
                .presentationBackgroundInteraction(.enabled)
            }
            .animation(.easeInOut, value: isShowing)
    }
    
    init(isShowing: Binding<Bool>,
         isExpandedByDefault: Bool,
         defaultDetent: PresentationDetent,
         title: String,
         description: String? = nil,
         closeAction: (() -> Void)?,
         @ViewBuilder sheetContent: () -> SheetContent) {
        _isShowing = isShowing
        self.isExpandedByDefault = isExpandedByDefault
        self._detent = .init(initialValue: defaultDetent)
        self.defaultDetent = defaultDetent
        self.title = title
        self.description = description
        self.closeAction = closeAction
        self.sheetContent = sheetContent()
    }
}
