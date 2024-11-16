import mysql.connector

from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)

CORS(app)

def get_db_connection():
    conn = mysql.connector.connect(
        host='34.31.64.51',
        user='root',
        password='Jovial2024@',
        database='messages_db'
    )
    return conn

@app.route('/')
def is_alive():
    return jsonify('live')


@app.route('/api/msg/<string:msg>', methods=['POST'])
def msg_post_api(msg):
    print(f"msg_post_api with message: {msg}")
    # TODO: store msg in DB and return identifier
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('INSERT INTO messages (message) VALUES (%s)', (msg,))
    conn.commit()
    msg_id = cursor.lastrowid
    cursor.close()
    conn.close()
    return jsonify({'msg_id': msg_id})


@app.route('/api/msg/<int:msg_id>', methods=['GET'])
def msg_get_api(msg_id):
    print(f"msg_get_api > msg_id = {msg_id}")
    # TODO: get msg from DB and return it
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT message FROM messages WHERE id = %s;", (msg_id,))
    msg = cur.fetchone()[0]
    cur.close()
    conn.close()
    return jsonify({'msg': msg})


if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1")
