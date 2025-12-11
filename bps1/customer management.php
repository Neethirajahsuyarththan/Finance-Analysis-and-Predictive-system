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

// Handle form submissions
$success_message = '';
$error_message = '';
$edit_mode = false;
$current_customer = null;

// Add/Edit Customer
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['save_customer'])) {
    $id = $_POST['id'] ?? null;
    $unique_id = $_POST['unique_id'];
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $address = $_POST['address'];
    $status = $_POST['status'];

    try {
        if ($id) {
            // Update existing customer
            $stmt = $pdo->prepare("UPDATE customers SET unique_id=?, first_name=?, last_name=?, email=?, phone=?, address=?, status=? WHERE id=?");
            $stmt->execute([$unique_id, $first_name, $last_name, $email, $phone, $address, $status, $id]);
            $success_message = 'Customer updated successfully!';
        } else {
            // Add new customer
            $stmt = $pdo->prepare("INSERT INTO customers (unique_id, first_name, last_name, email, phone, address, status) VALUES (?, ?, ?, ?, ?, ?, ?)");
            $stmt->execute([$unique_id, $first_name, $last_name, $email, $phone, $address, $status]);
            $success_message = 'Customer added successfully!';
        }
    } catch (PDOException $e) {
        $error_message = 'Error: ' . $e->getMessage();
    }
}

// Delete Customer
if (isset($_GET['delete'])) {
    $id = $_GET['delete'];
    try {
        $stmt = $pdo->prepare("DELETE FROM customers WHERE id=?");
        $stmt->execute([$id]);
        $success_message = 'Customer deleted successfully!';
    } catch (PDOException $e) {
        $error_message = 'Error deleting customer: ' . $e->getMessage();
    }
}

// Edit Customer (load data)
if (isset($_GET['edit'])) {
    $id = $_GET['edit'];
    try {
        $stmt = $pdo->prepare("SELECT * FROM customers WHERE id=?");
        $stmt->execute([$id]);
        $current_customer = $stmt->fetch(PDO::FETCH_ASSOC);
        $edit_mode = true;
    } catch (PDOException $e) {
        $error_message = 'Error loading customer: ' . $e->getMessage();
    }
}

// Search Customers
$search_term = $_GET['search'] ?? '';
$customers = [];
try {
    $sql = "SELECT * FROM customers";
    if ($search_term) {
        $sql .= " WHERE unique_id LIKE ? OR first_name LIKE ? OR last_name LIKE ? OR phone LIKE ?";
        $stmt = $pdo->prepare($sql);
        $search_param = "%$search_term%";
        $stmt->execute([$search_param, $search_param, $search_param, $search_param]);
    } else {
        $stmt = $pdo->query($sql);
    }
    $customers = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    $error_message = 'Error loading customers: ' . $e->getMessage();
}

// Generate unique ID
function generateUniqueId() {
    $prefix = 'TC';
    $randomNum = mt_rand(10000, 99999);
    return $prefix . $randomNum;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Therapy Center - Customer Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        .header {
            background-color: #4e73df;
            color: white;
            padding: 20px 0;
            margin-bottom: 30px;
        }
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
        }
        .btn-primary:hover {
            background-color: #2e59d9;
            border-color: #2e59d9;
        }
        .table-responsive {
            margin-top: 20px;
        }
        .status-active {
            color: #28a745;
        }
        .status-inactive {
            color: #dc3545;
        }
        .action-btns .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        .search-box {
            max-width: 400px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1><i class="bi bi-people-fill"></i> Therapy Center</h1>
            <p>Customer Management System</p>
        </div>
    </div>

    <div class="container">
        <?php if ($success_message): ?>
            <div class="alert alert-success"><?php echo $success_message; ?></div>
        <?php endif; ?>
        <?php if ($error_message): ?>
            <div class="alert alert-danger"><?php echo $error_message; ?></div>
        <?php endif; ?>

        <div class="row mb-4">
            <div class="col-md-6">
                <h2><?php echo $edit_mode ? 'Edit Customer' : 'Add New Customer'; ?></h2>
            </div>
            <div class="col-md-6 text-end">
                <form class="search-box ms-auto" method="GET" action="">
                    <div class="input-group">
                        <input type="text" class="form-control" name="search" placeholder="Search customers..." value="<?php echo htmlspecialchars($search_term); ?>">
                        <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i></button>
                        <?php if ($search_term): ?>
                            <a href="?" class="btn btn-outline-secondary"><i class="bi bi-x"></i></a>
                        <?php endif; ?>
                    </div>
                </form>
            </div>
        </div>

        <!-- Customer Form -->
        <div class="form-container">
            <form method="POST">
                <input type="hidden" name="id" value="<?php echo $current_customer['id'] ?? ''; ?>">
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="unique_id" class="form-label">Unique ID</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="unique_id" name="unique_id" 
                                   value="<?php echo $current_customer['unique_id'] ?? generateUniqueId(); ?>" required>
                            <button type="button" class="btn btn-outline-secondary" id="generateIdBtn">
                                <i class="bi bi-arrow-repeat"></i> Generate
                            </button>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label for="status" class="form-label">Status</label>
                        <select class="form-select" id="status" name="status" required>
                            <option value="active" <?php echo ($current_customer['status'] ?? 'active') === 'active' ? 'selected' : ''; ?>>Active</option>
                            <option value="inactive" <?php echo ($current_customer['status'] ?? '') === 'inactive' ? 'selected' : ''; ?>>Inactive</option>
                        </select>
                    </div>
                </div>
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="first_name" class="form-label">First Name</label>
                        <input type="text" class="form-control" id="first_name" name="first_name" 
                               value="<?php echo htmlspecialchars($current_customer['first_name'] ?? ''); ?>" required>
                    </div>
                    <div class="col-md-6">
                        <label for="last_name" class="form-label">Last Name</label>
                        <input type="text" class="form-control" id="last_name" name="last_name" 
                               value="<?php echo htmlspecialchars($current_customer['last_name'] ?? ''); ?>" required>
                    </div>
                </div>
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" 
                               value="<?php echo htmlspecialchars($current_customer['email'] ?? ''); ?>">
                    </div>
                    <div class="col-md-6">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="tel" class="form-control" id="phone" name="phone" 
                               value="<?php echo htmlspecialchars($current_customer['phone'] ?? ''); ?>" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="address" class="form-label">Address</label>
                    <textarea class="form-control" id="address" name="address" rows="3"><?php 
                        echo htmlspecialchars($current_customer['address'] ?? ''); 
                    ?></textarea>
                </div>
                
                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <?php if ($edit_mode): ?>
                        <a href="?" class="btn btn-secondary me-md-2">Cancel</a>
                    <?php endif; ?>
                    <button type="submit" class="btn btn-primary" name="save_customer">
                        <i class="bi bi-save"></i> <?php echo $edit_mode ? 'Update' : 'Save'; ?> Customer
                    </button>
                </div>
            </form>
        </div>

        <!-- Customers List -->
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-list-ul"></i> Customer List</h5>
            </div>
            <div class="card-body">
                <?php if (count($customers) > 0): ?>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Contact</th>
                                    <th>Status</th>
                                    <th>Registered</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($customers as $customer): ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($customer['unique_id']); ?></td>
                                        <td>
                                          <?php echo htmlspecialchars($customer['first_name']) . ' ' . htmlspecialchars($customer['last_name']); ?>
                                        </td>
                                        <td>
                                            <?php if ($customer['email']): ?>
                                                <a href="mailto:<?php echo htmlspecialchars($customer['email']); ?>"><?php echo htmlspecialchars($customer['email']); ?></a><br>
                                            <?php endif; ?>
                                            <?php echo htmlspecialchars($customer['phone']); ?>
                                        </td>
                                        <td>
                                            <span class="status-<?php echo $customer['status']; ?>">
                                                <i class="bi bi-circle-fill"></i> <?php echo ucfirst($customer['status']); ?>
                                            </span>
                                        </td>
                                        <td><?php echo date('M j, Y', strtotime($customer['registration_date'])); ?></td>
                                        <td class="action-btns">
                                            <a href="?edit=<?php echo $customer['id']; ?>" class="btn btn-sm btn-outline-primary" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="?delete=<?php echo $customer['id']; ?>" class="btn btn-sm btn-outline-danger" title="Delete" onclick="return confirm('Are you sure you want to delete this customer?')">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php else: ?>
                    <div class="alert alert-info">
                        <?php echo $search_term ? 'No customers found matching your search.' : 'No customers found. Add your first customer above.'; ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <footer class="footer mt-5">
        <div class="container text-center">
            <p class="text-muted">Therapy Center Management System &copy; <?php echo date('Y'); ?></p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Generate unique ID
            document.getElementById('generateIdBtn').addEventListener('click', function() {
                const prefix = 'TC';
                const randomNum = Math.floor(10000 + Math.random() * 90000);
                document.getElementById('unique_id').value = prefix + randomNum;
            });

            // Focus on first field when in edit mode
            <?php if ($edit_mode): ?>
                document.getElementById('first_name').focus();
            <?php endif; ?>

            // Form validation
            const form = document.querySelector('form');
            form.addEventListener('submit', function(e) {
                const phone = document.getElementById('phone').value.trim();
                if (!/^[\d\s\-+]+$/.test(phone)) {
                    alert('Please enter a valid phone number');
                    e.preventDefault();
                    return false;
                }
            });
        });
    </script>
</body>
</html>