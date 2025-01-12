import cx_Oracle
from db.config import DB_USERNAME, DB_PASSWORD, DB_DSN

def get_connection():
    return cx_Oracle.connect(DB_USERNAME, DB_PASSWORD, DB_DSN)
