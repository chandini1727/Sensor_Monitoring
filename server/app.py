from flask import Flask, jsonify
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)  # This will enable CORS for all routes

# MySQL Database connection setup
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",  
        user="root",  
        password="Harshith1234#",  
        database="sensor_monitoring", 
        port="3304"  
    )

@app.route('/get_sensor_status/<officer_id>', methods=['GET'])
def get_sensor_status(officer_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    query = """
    SELECT s.sensor_id, s.location, s.battery_level, s.water_level, s.last_update,
           CASE
             WHEN s.battery_level < 20 THEN 'Low Battery'
             WHEN TIMESTAMPDIFF(HOUR, s.last_update, NOW()) > 4 THEN 'No Data in last 4 hours'
             WHEN s.water_level < 0 THEN 'Abnormal Water Level'
             ELSE 'All Good'
           END as alert
    FROM sensors s
    WHERE s.officer_id = %s;
    """
    
    cursor.execute(query, (officer_id,))
    result = cursor.fetchall()
    
    conn.close()
    
    if result:
        return jsonify(result)
    else:
        return jsonify({"error": "No sensors found for the officer"}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
