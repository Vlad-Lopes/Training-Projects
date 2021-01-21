import UIKit

class NoteViewController: UIViewController {
    @IBOutlet var contentTextView: UITextView!
    
    var note: Note? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.text = note!.content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        note!.content = contentTextView.text
        NoteManager.shared.saveNote(note: note!)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        NoteManager.shared.deleteNote(note: note!)
        navigationController?.popViewController(animated: true)
    }
}
