from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector

app = Flask(__name__)
app.secret_key = "your_secret_key"  # ใช้สำหรับข้อความแจ้งเตือนและ session

# การเชื่อมต่อฐานข้อมูล MySQL
db_config = {
    'user': 'root',
    'password': 'dino1234',
    'host': 'localhost',
    'database': 'Joyliday'
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

# หน้าแรก
@app.route('/')
def index():
    return render_template('index.html')  # หน้าแรก

@app.route('/employees')
def employees():
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    # ดึงข้อมูลพนักงานพร้อมกับ Department_name
    cursor.execute('''
        SELECT e.Employee_id, e.Employee_name, e.Department_id, d.Department_name, e.Username
        FROM Employee e
        JOIN Department d ON e.Department_id = d.Department_id
    ''')  # แก้ไขคำสั่ง SQL เพื่อรวมข้อมูลจาก Department
    employees = cursor.fetchall()

    cursor.close()
    connection.close()

    return render_template('employees.html', employees=employees)  # แสดงข้อมูลพนักงาน

# หน้า register
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        customer_name = request.form['customer_name']
        customer_phone = request.form['customer_phone']
        email = request.form['email']
        
        # เพิ่มข้อมูลลงในฐานข้อมูล
        connection = get_db_connection()
        cursor = connection.cursor()
        
        add_customer_query = '''
            INSERT INTO Customer (Customer_name, Customer_phone, Email)
            VALUES (%s, %s, %s)
        '''
        cursor.execute(add_customer_query, (customer_name, customer_phone, email))
        connection.commit()
        
        cursor.close()
        connection.close()
        
        flash("Customer registered successfully!")
        return redirect(url_for('register'))
    
    return render_template('register.html')

# หน้า login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        phone = request.form['phone']
        
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True, buffered=True)
        
        # ตรวจสอบข้อมูลสมาชิก
        query = '''
            SELECT * FROM Customer WHERE Email = %s AND Customer_phone = %s
        '''
        cursor.execute(query, (email, phone))
        customer = cursor.fetchone()
        
        cursor.close()
        connection.close()
        
        if customer:
            session['customer_id'] = customer['Customer_id']  # เก็บ ID ใน session
            flash("Login successful!")
            return redirect(url_for('profile'))
        else:
            flash("Invalid email or phone number. Please try again.")
    
    return render_template('login.html')

# หน้า profile แสดงข้อมูลสมาชิก
@app.route('/profile')
def profile():
    if 'customer_id' not in session:
        flash("Please log in to view your profile.")
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    # ดึงข้อมูลสมาชิกตาม customer_id
    query = "SELECT * FROM Customer WHERE Customer_id = %s"
    cursor.execute(query, (session['customer_id'],))
    customer = cursor.fetchone()
    
    cursor.close()
    connection.close()
    
    return render_template('profile.html', customer=customer)

# หน้า rewards แสดงข้อมูลของรางวัล
@app.route('/rewards')
def rewards():
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    # ดึงข้อมูลของรางวัลรวมถึง Image_URL จากตาราง Reward
    cursor.execute("SELECT * FROM Reward")  # คำสั่ง SQL ดึงข้อมูลทั้งหมดจาก Reward
    rewards = cursor.fetchall()

    cursor.close()
    connection.close()

    return render_template('rewards.html', rewards=rewards)  # แสดงข้อมูลของรางวัล

# หน้า logout
@app.route('/logout')
def logout():
    session.pop('customer_id', None)  # ลบข้อมูลผู้ใช้ใน session
    flash("Logged out successfully!")
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True)
