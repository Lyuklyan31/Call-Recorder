import SwiftUI

struct PairingSheet<SheetContent: View>: ViewModifier {
    @Binding var isShowing: Bool
    var isExpandedByDefault: Bool
    let title: String
    var description: String?
    var closeAction: (() -> Void)?
    let sheetContent: SheetContent
    
    private var detents: Set<PresentationDetent> {
            let screenHeight = UIScreen.main.bounds.height
            let detentValue: CGFloat
            
            if screenHeight <= 568 {
                detentValue = 0.9
            } else if screenHeight <= 736 {
                detentValue = 0.8
            } else {
                detentValue = 0.7
            }
            
            return [.fraction(detentValue)]
        }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isShowing, onDismiss: {
                closeAction?()
            }) {
                VStack {
                    sheetContent
                }
                .background {
                    GeometryReader { _ in
                        Rectangle()
                            .fill(Color.white)
                    }
                }
                .presentationDetents(detents)
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
        self.title = title
        self.description = description
        self.closeAction = closeAction
        self.sheetContent = sheetContent()
    }
}
