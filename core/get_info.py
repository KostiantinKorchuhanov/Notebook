from PyQt5.QtCore import QAbstractListModel, Qt
import sqlite3

class notesInfo(QAbstractListModel):
    def __init__(self, db):
        super().__init__()
        self.db = db
        self.notes = []
        self.reload()

    def reload(self):
        self.beginResetModel()
        self.db.cursor.execute(
            '''
                SELECT id, note FROM notestable ORDER BY date DESC
            '''
        )
        self.notes = self.db.cursor.fetchall()
        self.endResetModel()

    def rowCount(self, parent=None):
        return len(self.notes)

    def data(self, index, role):
        note_id, text = self.notes[index.row()]
        if role == Qt.UserRole:
            return note_id
        if role == Qt.UserRole + 1:
            return text[:20]
        if role == Qt.UserRole + 2:
            return text

    def roleNames(self):
        return{
            Qt.UserRole: b"id",
            Qt.UserRole + 1: b"title",
            Qt.UserRole + 2: b"note"
        }

    