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
$selected_employee = null;
$salary_history = [];

// Process salary payment
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_salary'])) {
    $employee_id = $_POST['employee_id'];
    $basic_salary = $_POST['basic_salary'];
    $allowances = $_POST['allowances'] ?? 0;
    $deductions = $_POST['deductions'] ?? 0;
    $payment_date = $_POST['payment_date'];
    $payment_method = $_POST['payment_method'];
    $notes = $_POST['notes'];

    try {
        $stmt = $pdo->prepare("INSERT INTO employee_salaries (employee_id, basic_salary, allowances, deductions, payment_date, payment_method, notes) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([$employee_id, $basic_salary, $allowances, $deductions, $payment_date, $payment_method, $notes]);
        
        $success_message = 'Salary payment recorded successfully!';
    } catch (PDOException $e) {
        $error_message = 'Error recording salary: ' . $e->getMessage();
    }
}

// Get employee details when selected
if (isset($_GET['employee_id'])) {
    $employee_id = $_GET['employee_id'];
    
    try {
        // Get employee details
        $stmt = $pdo->prepare("SELECT * FROM employees WHERE id = ?");
        $stmt->execute([$employee_id]);
        $selected_employee = $stmt->fetch(PDO::FETCH_ASSOC);
        
        // Get salary history
        $stmt = $pdo->prepare("SELECT * FROM employee_salaries WHERE employee_id = ? ORDER BY payment_date DESC");
        $stmt->execute([$employee_id]);
        $salary_history = $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        $error_message = 'Error loading employee data: ' . $e->getMessage();
    }
}

// Get all active employees for dropdown
$employees = [];
try {
    $stmt = $pdo->query("SELECT id, first_name, last_name, position FROM employees WHERE status = 'active' ORDER BY last_name");
    $employees = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    $error_message = 'Error loading employees: ' . $e->getMessage();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Therapy Center - Salary Management</title>
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
        .employee-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .salary-summary {
            background-color: #e9f7ef;
            border-left: 4px solid #28a745;
            padding: 15px;
            margin-bottom: 20px;
        }
        .history-table {
            max-height: 400px;
            overflow-y: auto;
        }
        .payment-method {
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1><i class="bi bi-cash-stack"></i> Therapy Center</h1>
            <p>Employee Salary Management System</p>
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
            <div class="col-md-12">
                <h2>Salary Assignment</h2>
            </div>
        </div>

        <!-- Employee Selection -->
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Select Employee</h5>
            </div>
            <div class="card-body">
                <form method="GET" action="">
                    <div class="row">
                        <div class="col-md-8">
                            <select class="form-select" name="employee_id" required>
                                <option value="">-- Select Employee --</option>
                                <?php foreach ($employees as $employee): ?>
                                    <option value="<?php echo $employee['id']; ?>" <?php echo isset($selected_employee) && $selected_employee['id'] == $employee['id'] ? 'selected' : ''; ?>>
                                        <?php echo htmlspecialchars($employee['last_name'] . ', ' . $employee['first_name'] . ' (' . $employee['position'] . ')'); ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <button type="submit" class="btn btn-primary w-100">Load Employee</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <?php if ($selected_employee): ?>
            <!-- Employee Details -->
            <div class="employee-card">
                <div class="row">
                    <div class="col-md-6">
                        <h4><?php echo htmlspecialchars($selected_employee['first_name'] . ' ' . $selected_employee['last_name']); ?></h4>
                        <p><strong>Position:</strong> <?php echo htmlspecialchars($selected_employee['position']); ?></p>
                        <p><strong>Hire Date:</strong> <?php echo date('M j, Y', strtotime($selected_employee['hire_date'])); ?></p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Email:</strong> <?php echo htmlspecialchars($selected_employee['email']); ?></p>
                        <p><strong>Phone:</strong> <?php echo htmlspecialchars($selected_employee['phone']); ?></p>
                        <p><strong>Status:</strong> <span class="badge bg-success">Active</span></p>
                    </div>
                </div>
            </div>

            <!-- Salary Payment Form -->
            <div class="form-container">
                <h4 class="mb-4">Record Salary Payment</h4>
                <form method="POST">
                    <input type="hidden" name="employee_id" value="<?php echo $selected_employee['id']; ?>">
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label for="basic_salary" class="form-label">Basic Salary ($)</label>
                            <input type="number" step="0.01" class="form-control" id="basic_salary" name="basic_salary" required>
                        </div>
                        <div class="col-md-4">
                            <label for="allowances" class="form-label">Allowances ($)</label>
                            <input type="number" step="0.01" class="form-control" id="allowances" name="allowances" value="0">
                        </div>
                        <div class="col-md-4">
                            <label for="deductions" class="form-label">Deductions ($)</label>
                            <input type="number" step="0.01" class="form-control" id="deductions" name="deductions" value="0">
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="payment_date" class="form-label">Payment Date</label>
                            <input type="date" class="form-control" id="payment_date" name="payment_date" value="<?php echo date('Y-m-d'); ?>" required>
                        </div>
                        <div class="col-md-6">
                            <label for="payment_method" class="form-label">Payment Method</label>
                            <select class="form-select" id="payment_method" name="payment_method" required>
                                <option value="bank_transfer">Bank Transfer</option>
                                <option value="cash">Cash</option>
                                <option value="check">Check</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="notes" class="form-label">Notes</label>
                        <textarea class="form-control" id="notes" name="notes" rows="2"></textarea>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary" name="submit_salary">
                            <i class="bi bi-save"></i> Record Salary Payment
                        </button>
                    </div>
                </form>
            </div>

            <!-- Salary Calculation Preview -->
            <div class="salary-summary">
                <h5>Salary Calculation Preview</h5>
                <div class="row">
                    <div class="col-md-4">
                        <p><strong>Basic Salary:</strong> $<span id="preview_basic">0.00</span></p>
                    </div>
                    <div class="col-md-4">
                        <p><strong>Allowances:</strong> $<span id="preview_allowances">0.00</span></p>
                    </div>
                    <div class="col-md-4">
                        <p><strong>Deductions:</strong> $<span id="preview_deductions">0.00</span></p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <p class="h5"><strong>Net Salary:</strong> $<span id="preview_net">0.00</span></p>
                    </div>
                </div>
            </div>

            <!-- Salary History -->
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Salary Payment History</h5>
                </div>
                <div class="card-body history-table">
                    <?php if (count($salary_history) > 0): ?>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Basic Salary</th>
                                        <th>Allowances</th>
                                        <th>Deductions</th>
                                        <th>Net Salary</th>
                                        <th>Method</th>
                                        <th>Notes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($salary_history as $payment): ?>
                                        <tr>
                                            <td><?php echo date('M j, Y', strtotime($payment['payment_date'])); ?></td>
                                            <td>$<?php echo number_format($payment['basic_salary'], 2); ?></td>
                                            <td>$<?php echo number_format($payment['allowances'], 2); ?></td>
                                            <td>$<?php echo number_format($payment['deductions'], 2); ?></td>
                                            <td><strong>$<?php echo number_format($payment['basic_salary'] + $payment['allowances'] - $payment['deductions'], 2); ?></strong></td>
                                            <td><span class="badge payment-method bg-info"><?php echo ucfirst(str_replace('_', ' ', $payment['payment_method'])); ?></span></td>
                                            <td><?php echo htmlspecialchars($payment['notes']); ?></td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    <?php else: ?>
                        <div class="alert alert-info">No salary payments recorded for this employee.</div>
                    <?php endif; ?>
                </div>
            </div>
        <?php endif; ?>
    </div>

    <footer class="footer mt-5">
        <div class="container text-center">
            <p class="text-muted">Therapy Center Management System &copy; <?php echo date('Y'); ?></p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Calculate and preview salary
            function calculateSalary() {
                const basic = parseFloat(document.getElementById('basic_salary').value) || 0;
                const allowances = parseFloat(document.getElementById('allowances').value) || 0;
                const deductions = parseFloat(document.getElementById('deductions').value) || 0;
                const net = basic + allowances - deductions;
                
                document.getElementById('preview_basic').textContent = basic.toFixed(2);
                document.getElementById('preview_allowances').textContent = allowances.toFixed(2);
                document.getElementById('preview_deductions').textContent = deductions.toFixed(2);
                document.getElementById('preview_net').textContent = net.toFixed(2);
            }
            
            // Add event listeners to salary inputs
            ['basic_salary', 'allowances', 'deductions'].forEach(id => {
                document.getElementById(id).addEventListener('input', calculateSalary);
            });
            
            // Initial calculation
            calculateSalary();
            
            // Form validation
            const form = document.querySelector('form[method="POST"]');
            if (form) {
                form.addEventListener('submit', function(e) {
                    const basicSalary = parseFloat(document.getElementById('basic_salary').value);
                    const paymentDate = new Date(document.getElementById('payment_date').value);
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    
                    if (isNaN(basicSalary) || basicSalary <= 0) {
                        alert('Please enter a valid basic salary amount');
                        e.preventDefault();
                        return false;
                    }
                    
                    if (paymentDate > today) {
                        alert('Payment date cannot be in the future');
                        e.preventDefault();
                        return false;
                    }
                });
            }
            
            // Focus on basic salary field when employee is selected
            <?php if ($selected_employee): ?>
                document.getElementById('basic_salary').focus();
            <?php endif; ?>
        });
    </script>
</body>
</html>