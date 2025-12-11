<?php
// Database configuration
$host = 'localhost';
$dbname = 'therapy_center';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Could not connect to the database: " . $e->getMessage());
}

// Generate a unique ID
function generateUniqueId() {
    $prefix = 'TC';
    $randomNum = mt_rand(10000, 99999);
    return $prefix . $randomNum;
}

// Handle form submission
$success_message = '';
$error_message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $unique_id = $_POST['unique_id'];
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $address = $_POST['address'];
    
    try {
        $stmt = $pdo->prepare("INSERT INTO customers (unique_id, first_name, last_name, email, phone, address) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->execute([$unique_id, $first_name, $last_name, $email, $phone, $address]);
        
        $success_message = 'Customer registered successfully!';
        // Clear form fields
        $_POST = array();
    } catch (PDOException $e) {
        $error_message = 'Error: ' . $e->getMessage();
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Therapy Center - Customer Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 30px auto;
        }
        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
        }
        .btn-primary:hover {
            background-color: #2e59d9;
            border-color: #2e59d9;
        }
        .alert {
            margin-top: 20px;
        }
        .header {
            background-color: #4e73df;
            color: white;
            padding: 20px 0;
            margin-bottom: 30px;
        }
        .footer {
            background-color: #f8f9fa;
            padding: 20px 0;
            margin-top: 30px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>Therapy Center</h1>
            <p>Customer Registration System</p>
        </div>
    </div>

    <div class="container">
        <?php if ($success_message): ?>
            <div class="alert alert-success"><?php echo $success_message; ?></div>
        <?php endif; ?>
        <?php if ($error_message): ?>
            <div class="alert alert-danger"><?php echo $error_message; ?></div>
        <?php endif; ?>

        <div class="form-container">
            <h2 class="text-center mb-4">Register New Customer</h2>
            <form method="POST">
                <div class="row mb-3">
                    <div class="col-md-9">
                        <label for="unique_id" class="form-label">Unique ID</label>
                        <input type="text" class="form-control" id="unique_id" name="unique_id" 
                               value="<?php echo isset($_POST['unique_id']) ? htmlspecialchars($_POST['unique_id']) : ''; ?>" required>
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button type="button" class="btn btn-secondary w-100" id="generateIdBtn">Generate ID</button>
                    </div>
                </div>
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="first_name" class="form-label">First Name</label>
                        <input type="text" class="form-control" id="first_name" name="first_name" 
                               value="<?php echo isset($_POST['first_name']) ? htmlspecialchars($_POST['first_name']) : ''; ?>" required>
                    </div>
                    <div class="col-md-6">
                        <label for="last_name" class="form-label">Last Name</label>
                        <input type="text" class="form-control" id="last_name" name="last_name" 
                               value="<?php echo isset($_POST['last_name']) ? htmlspecialchars($_POST['last_name']) : ''; ?>" required>
                    </div>
                </div>
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" 
                               value="<?php echo isset($_POST['email']) ? htmlspecialchars($_POST['email']) : ''; ?>">
                    </div>
                    <div class="col-md-6">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="tel" class="form-control" id="phone" name="phone" 
                               value="<?php echo isset($_POST['phone']) ? htmlspecialchars($_POST['phone']) : ''; ?>" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="address" class="form-label">Address</label>
                    <textarea class="form-control" id="address" name="address" rows="3"><?php 
                        echo isset($_POST['address']) ? htmlspecialchars($_POST['address']) : ''; 
                    ?></textarea>
                </div>
                
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Register Customer</button>
                </div>
            </form>
        </div>
    </div>

    <div class="footer">
        <div class="container">
            <p>Therapy Center Management System &copy; <?php echo date('Y'); ?></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Generate unique ID when button is clicked
            document.getElementById('generateIdBtn').addEventListener('click', function() {
                const prefix = 'TC';
                const randomNum = Math.floor(10000 + Math.random() * 90000);
                document.getElementById('unique_id').value = prefix + randomNum;
            });

            // Form validation
            const form = document.querySelector('form');
            form.addEventListener('submit', function(e) {
                let valid = true;
                
                // Check required fields
                const requiredFields = ['unique_id', 'first_name', 'last_name', 'phone'];
                requiredFields.forEach(field => {
                    const input = document.getElementById(field);
                    if (!input.value.trim()) {
                        input.classList.add('is-invalid');
                        valid = false;
                    } else {
                        input.classList.remove('is-invalid');
                    }
                });

                // Validate email format if provided
                const email = document.getElementById('email');
                if (email.value.trim() && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) {
                    email.classList.add('is-invalid');
                    valid = false;
                } else {
                    email.classList.remove('is-invalid');
                }

                if (!valid) {
                    e.preventDefault();
                    alert('Please fill in all required fields correctly.');
                }
            });
        });
    </script>
</body>
</html>