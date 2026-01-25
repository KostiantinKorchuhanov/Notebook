import sys
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from core.db import noteDatabase



app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()

backend_instance = noteDatabase()
engine.rootContext().setContextProperty("interact_database", backend_instance)

engine.quit.connect(app.quit)
engine.load('ui/main.qml')
if not engine.rootObjects():
    sys.exit(-1)

sys.exit(app.exec())
