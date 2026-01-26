import sqlite3
import time
from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal
from core.get_info import notesInfo

class noteDatabase(QObject):
    last_changed = pyqtSignal(str)

    def __init__(self):
        super().__init__()
        self.current_id = None
        self.connection = sqlite3.connect("database/notes.db")
        self.cursor = self.connection.cursor()
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS notestable(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                note TEXT,
                date REAL
            )
        ''')
        self.connection.commit()
        self.get_last_note()

    @pyqtSlot(str)
    def save_note(self, note_text):
        timestamp = int(time.time())

        if self.current_id is None:
            self.cursor.execute(
                'INSERT INTO notestable (note, date) VALUES (?, ?)',
                (note_text, timestamp)
            )
            self.current_id = self.cursor.lastrowid
        else:
            self.cursor.execute(
                'UPDATE notestable SET note = ?, date = ? WHERE id = ?',
                (note_text, timestamp, self.current_id)
            )

        self.connection.commit()
        self.get_last_note()
        self.notesInfo.reload()

    @pyqtSlot()
    def get_last_note(self):
        self.cursor.execute(
            'SELECT id, note FROM notestable ORDER BY date DESC LIMIT 1'
        )
        row = self.cursor.fetchone()
        if row:
            self.current_id = row[0]
            self.last_changed.emit(row[1])

    @pyqtSlot(int)
    def select_note(self, note_id):
        self.current_id = note_id
        self.cursor.execute(
            '''
                SELECT note FROM notestable WHERE id = ?
            ''',
            (note_id,)
        )
        row = self.cursor.fetchone()
        if row:
            self.last_changed.emit(row[0])



