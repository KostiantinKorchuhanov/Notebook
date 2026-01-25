import sqlite3
import time
from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal

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

    @pyqtSlot()
    def get_last_note(self):
        self.cursor.execute(
            'SELECT id, note FROM notestable ORDER BY date DESC LIMIT 1'
        )
        row = self.cursor.fetchone()
        if row:
            self.current_id = row[0]
            self.last_changed.emit(row[1])

