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

// Handle form submission
$success_message = '';
$error_message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['add_expense'])) {
    $expense_date = $_POST['expense_date'];
    $category = $_POST['category'];
    $description = $_POST['description'];
    $amount = $_POST['amount'];
    $payment_method = $_POST['payment_method'];
    $receipt_number = $_POST['receipt_number'];
    $recorded_by = $_POST['recorded_by'];

    try {
        $stmt = $pdo->prepare("INSERT INTO expenses (expense_date, category, description, amount, payment_method, receipt_number, recorded_by) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([$expense_date, $category, $description, $amount, $payment_method, $receipt_number, $recorded_by]);
        
        $success_message = 'Expense recorded successfully!';
        // Clear form
        $_POST = array();
    } catch (PDOException $e) {
        $error_message = 'Error recording expense: ' . $e->getMessage();
    }
}

// Handle expense deletion
if (isset($_GET['delete'])) {
    $id = $_GET['delete'];
    try {
        $stmt = $pdo->prepare("DELETE FROM expenses WHERE id = ?");
        $stmt->execute([$id]);
        $success_message = 'Expense deleted successfully!';
    } catch (PDOException $e) {
        $error_message = 'Error deleting expense: ' . $e->getMessage();
    }
}

// Get expense categories
$categories = [
    'Rent', 'Utilities', 'Office Supplies', 'Equipment', 
    'Maintenance', 'Marketing', 'Insurance', 'Taxes', 
    'Professional Fees', 'Travel', 'Training', 'Other'
];

// Get all expenses for listing
$expenses = [];
$search_term = '';
$category_filter = '';
$date_from = '';
$date_to = '';

try {
    $sql = "SELECT * FROM expenses";
    $params = [];
    
    // Apply filters if set
    $filters = [];
    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search_term = $_GET['search'];
        $filters[] = "(description LIKE ? OR receipt_number LIKE ?)";
        $params[] = "%$search_term%";
        $params[] = "%$search_term%";
    }
    
    if (isset($_GET['category']) && !empty($_GET['category'])) {
        $category_filter = $_GET['category'];
        $filters[] = "category = ?";
        $params[] = $category_filter;
    }
    
    if (isset($_GET['date_from']) && !empty($_GET['date_from'])) {
        $date_from = $_GET['date_from'];
        $filters[] = "expense_date >= ?";
        $params[] = $date_from;
    }
    
    if (isset($_GET['date_to']) && !empty($_GET['date_to'])) {
        $date_to = $_GET['date_to'];
        $filters[] = "expense_date <= ?";
        $params[] = $date_to;
    }
    
    if (count($filters) > 0) {
        $sql .= " WHERE " . implode(" AND ", $filters);
    }
    
    $sql .= " ORDER BY expense_date DESC";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $expenses = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Get total expenses for the filtered results
    $stmt = $pdo->prepare(str_replace('*', 'SUM(amount) as total', $sql));
    $stmt->execute($params);
    $total_expenses = $stmt->fetch(PDO::FETCH_ASSOC)['total'] ?? 0;
    
} catch (PDOException $e) {
    $error_message = 'Error loading expenses: ' . $e->getMessage();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Therapy Center - Expense Management</title>
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
        .total-expenses {
            background-color: #e9f7ef;
            border-left: 4px solid #28a745;
            padding: 15px;
            margin-bottom: 20px;
            font-size: 1.2rem;
        }
        .badge-category {
            font-size: 0.8rem;
            font-weight: normal;
            background-color: #e9ecef;
            color: #495057;
        }
        .filter-section {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .payment-method-badge {
            font-size: 0.8rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1><i class="bi bi-cash-stack"></i> Therapy Center</h1>
            <p>Expense Management System</p>
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
                <h2>Record New Expense</h2>
            </div>
        </div>

        <!-- Expense Form -->
        <div class="form-container">
            <form method="POST">
                <div class="row mb-3">
                    <div class="col-md-3">
                        <label for="expense_date" class="form-label">Date</label>
                        <input type="date" class="form-control" id="expense_date" name="expense_date" 
                               value="<?php echo $_POST['expense_date'] ?? date('Y-m-d'); ?>" required>
                    </div>
                    <div class="col-md-3">
                        <label for="category" class="form-label">Category</label>
                        <select class="form-select" id="category" name="category" required>
                            <option value="">-- Select Category --</option>
                            <?php foreach ($categories as $category): ?>
                                <option value="<?php echo $category; ?>" 
                                    <?php echo ($_POST['category'] ?? '') === $category ? 'selected' : ''; ?>>
                                    <?php echo $category; ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="amount" class="form-label">Amount ($)</label>
                        <input type="number" step="0.01" class="form-control" id="amount" name="amount" 
                               value="<?php echo $_POST['amount'] ?? ''; ?>" required>
                    </div>
                    <div class="col-md-3">
                        <label for="payment_method" class="form-label">Payment Method</label>
                        <select class="form-select" id="payment_method" name="payment_method" required>
                            <option value="cash" <?php echo ($_POST['payment_method'] ?? '') === 'cash' ? 'selected' : ''; ?>>Cash</option>
                            <option value="bank_transfer" <?php echo ($_POST['payment_method'] ?? '') === 'bank_transfer' ? 'selected' : ''; ?>>Bank Transfer</option>
                            <option value="check" <?php echo ($_POST['payment_method'] ?? '') === 'check' ? 'selected' : ''; ?>>Check</option>
                            <option value="credit_card" <?php echo ($_POST['payment_method'] ?? '') === 'credit_card' ? 'selected' : ''; ?>>Credit Card</option>
                        </select>
                    </div>
                </div>
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="2"><?php echo $_POST['description'] ?? ''; ?></textarea>
                    </div>
                    <div class="col-md-3">
                        <label for="receipt_number" class="form-label">Receipt Number</label>
                        <input type="text" class="form-control" id="receipt_number" name="receipt_number" 
                               value="<?php echo $_POST['receipt_number'] ?? ''; ?>">
                    </div>
                    <div class="col-md-3">
                        <label for="recorded_by" class="form-label">Recorded By</label>
                        <input type="text" class="form-control" id="recorded_by" name="recorded_by" 
                               value="<?php echo $_POST['recorded_by'] ?? 'Admin'; ?>" required>
                    </div>
                </div>
                
                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <button type="submit" class="btn btn-primary" name="add_expense">
                        <i class="bi bi-save"></i> Record Expense
                    </button>
                </div>
            </form>
        </div>

        <!-- Expense Filters -->
        <div class="filter-section">
            <h4>Filter Expenses</h4>
            <form method="GET" action="">
                <div class="row g-3">
                    <div class="col-md-3">
                        <input type="text" class="form-control" name="search" placeholder="Search description or receipt..." 
                               value="<?php echo htmlspecialchars($search_term); ?>">
                    </div>
                    <div class="col-md-2">
                        <select class="form-select" name="category">
                            <option value="">All Categories</option>
                            <?php foreach ($categories as $category): ?>
                                <option value="<?php echo $category; ?>" 
                                    <?php echo $category_filter === $category ? 'selected' : ''; ?>>
                                    <?php echo $category; ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <input type="date" class="form-control" name="date_from" 
                               value="<?php echo htmlspecialchars($date_from); ?>" placeholder="From date">
                    </div>
                    <div class="col-md-2">
                        <input type="date" class="form-control" name="date_to" 
                               value="<?php echo htmlspecialchars($date_to); ?>" placeholder="To date">
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary me-2">
                            <i class="bi bi-funnel"></i> Apply Filters
                        </button>
                        <a href="?" class="btn btn-outline-secondary">
                            <i class="bi bi-x"></i> Clear
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <!-- Total Expenses -->
        <div class="total-expenses">
            <div class="row">
                <div class="col-md-12">
                    <strong>Total Expenses:</strong> $<?php echo number_format($total_expenses, 2); ?>
                    <?php if ($category_filter || $date_from || $date_to): ?>
                        <span class="text-muted">(filtered results)</span>
                    <?php endif; ?>
                </div>
            </div>
        </div>

        <!-- Expenses List -->
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-list-ul"></i> Expense Records</h5>
            </div>
            <div class="card-body">
                <?php if (count($expenses) > 0): ?>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Category</th>
                                    <th>Description</th>
                                    <th>Amount</th>
                                    <th>Payment Method</th>
                                    <th>Receipt #</th>
                                    <th>Recorded By</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($expenses as $expense): ?>
                                    <tr>
                                        <td><?php echo date('M j, Y', strtotime($expense['expense_date'])); ?></td>
                                        <td><span class="badge badge-category"><?php echo htmlspecialchars($expense['category']); ?></span></td>
                                        <td><?php echo htmlspecialchars($expense['description']); ?></td>
                                        <td>$<?php echo number_format($expense['amount'], 2); ?></td>
                                        <td>
                                            <span class="badge payment-method-badge bg-info">
                                                <?php echo ucfirst(str_replace('_', ' ', $expense['payment_method'])); ?>
                                            </span>
                                        </td>
                                        <td><?php echo htmlspecialchars($expense['receipt_number']); ?></td>
                                        <td><?php echo htmlspecialchars($expense['recorded_by']); ?></td>
                                        <td>
                                            <a href="?delete=<?php echo $expense['id']; ?>" class="btn btn-sm btn-outline-danger" 
                                               onclick="return confirm('Are you sure you want to delete this expense?')">
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
                        <?php echo ($search_term || $category_filter || $date_from || $date_to) ? 
                            'No expenses found matching your filters.' : 
                            'No expenses recorded yet. Add your first expense above.'; ?>
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
            // Form validation
            const form = document.querySelector('form[method="POST"]');
            if (form) {
                form.addEventListener('submit', function(e) {
                    const amount = parseFloat(document.getElementById('amount').value);
                    const expenseDate = new Date(document.getElementById('expense_date').value);
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    
                    if (isNaN(amount) || amount <= 0) {
                        alert('Please enter a valid amount greater than 0');
                        e.preventDefault();
                        return false;
                    }
                    
                    if (expenseDate > today) {
                        alert('Expense date cannot be in the future');
                        e.preventDefault();
                        return false;
                    }
                });
            }
            
            // Focus on amount field when page loads
            document.getElementById('amount').focus();
        });
    </script>
</body>
</html>