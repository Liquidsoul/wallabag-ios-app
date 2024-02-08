import SwiftUI

struct TagRow: View {
    @ObservedObject var tag: Tag
    @ObservedObject var tagsForEntry: TagsForEntryPublisher

    var body: some View {
        HStack {
            Text(tag.label)
            if tag.isChecked {
                Spacer()
                Image(systemName: "checkmark")
            }
        }.onTapGesture {
            Task {
                if tag.isChecked {
                    await tagsForEntry.delete(tag: tag)
                } else {
                    await tagsForEntry.add(tag: tag)
                }
            }
        }
    }
}

/*
 struct TagRow_Previews: PreviewProvider {
 static var previews: some View {
     TagRow(tag: Tag(), entry: Entry())
 }
 }
 */
