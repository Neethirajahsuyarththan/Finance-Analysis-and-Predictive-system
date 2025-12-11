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

// Handle payment submission
$success_message = '';
$error_message = '';
$customer_details = null;
$payment_history = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_payment'])) {
    $customer_id = $_POST['customer_id'];
    $amount = $_POST['amount'];
    $payment_method = $_POST['payment_method'];
    $notes = $_POST['notes'];
    
    try {
        $stmt = $pdo->prepare("INSERT INTO payments (customer_id, amount, payment_method, notes) VALUES (?, ?, ?, ?)");
        $stmt->execute([$customer_id, $amount, $payment_method, $notes]);
        
        $success_message = 'Payment recorded successfully!';
    } catch (PDOException $e) {
        $error_message = 'Error recording payment: ' . $e->getMessage();
    }
}

// Search for customers
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['search_customer'])) {
    $search_term = '%' . $_POST['search_term'] . '%';
    
    try {
        $stmt = $pdo->prepare("SELECT * FROM customers WHERE unique_id LIKE ? OR first_name LIKE ? OR last_name LIKE ?");
        $stmt->execute([$search_term, $search_term, $search_term]);
        $search_results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        if (count($search_results) > 0) {
            $customer_details = $search_results[0];
            
            // Get payment history
            $stmt = $pdo->prepare("SELECT * FROM payments WHERE customer_id = ? ORDER BY payment_date DESC");
            $stmt->execute([$customer_details['id']]);
            $payment_history = $stmt->fetchAll(PDO::FETCH_ASSOC);
        } else {
            $error_message = 'No customer found with that ID or name';
        }
    } catch (PDOException $e) {
        $error_message = 'Search error: ' . $e->getMessage();
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Therapy Center - Payment System</title>
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
            max-width: 1000px;
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
        .customer-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .payment-history {
            max-height: 300px;
            overflow-y: auto;
        }
        .table thead th {
            position: sticky;
            top: 0;
            background-color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>Therapy Center</h1>
            <p>Customer Payment System</p>
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
            <h2 class="text-center mb-4">Record Payment</h2>
            
            <!-- Search Form -->
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Search Customer</h5>
                </div>
                <div class="card-body">
                    <form method="POST">
                        <div class="input-group mb-3">
                            <input type="text" class="form-control" id="search_term" name="search_term" 
                                   placeholder="Search by Customer ID or Name" required>
                            <button class="btn btn-primary" type="submit" name="search_customer">Search</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Customer Details -->
            <?php if ($customer_details): ?>
                <div class="customer-card mb-4">
                    <div class="row">
                        <div class="col-md-6">
                            <h4>Customer Information</h4>
                            <p><strong>ID:</strong> <?php echo htmlspecialchars($customer_details['unique_id']); ?></p>
                            <p><strong>Name:</strong> <?php echo htmlspecialchars($customer_details['first_name'] . ' ' . $customer_details['last_name']); ?></p>
                            <p><strong>Phone:</strong> <?php echo htmlspecialchars($customer_details['phone']); ?></p>
                        </div>
                        <div class="col-md-6">
                            <h4>Payment Form</h4>
                            <form method="POST">
                                <input type="hidden" name="customer_id" value="<?php echo $customer_details['id']; ?>">
                                
                                <div class="mb-3">
                                    <label for="amount" class="form-label">Amount</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" step="0.01" class="form-control" id="amount" name="amount" required>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="payment_method" class="form-label">Payment Method</label>
                                    <select class="form-select" id="payment_method" name="payment_method" required>
                                        <option value="cash">Cash</option>
                                        <option value="card">Credit/Debit Card</option>
                                        <option value="bank_transfer">Bank Transfer</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="notes" class="form-label">Notes</label>
                                    <textarea class="form-control" id="notes" name="notes" rows="2"></textarea>
                                </div>
                                
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary" name="submit_payment">Record Payment</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Payment History -->
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Payment History</h5>
                    </div>
                    <div class="card-body payment-history">
                        <?php if (count($payment_history) > 0): ?>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Amount</th>
                                            <th>Method</th>
                                            <th>Notes</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($payment_history as $payment): ?>
                                            <tr>
                                                <td><?php echo date('M j, Y h:i A', strtotime($payment['payment_date'])); ?></td>
                                                <td>$<?php echo number_format($payment['amount'], 2); ?></td>
                                                <td><?php echo ucfirst(str_replace('_', ' ', $payment['payment_method'])); ?></td>
                                                <td><?php echo htmlspecialchars($payment['notes']); ?></td>
                                            </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                        <?php else: ?>
                            <p class="text-muted">No payment history found for this customer.</p>
                        <?php endif; ?>
                    </div>
                </div>
            <?php endif; ?>
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
            // Form validation
            const paymentForm = document.querySelector('form[name="submit_payment"]');
            if (paymentForm) {
                paymentForm.addEventListener('submit', function(e) {
                    const amount = parseFloat(document.getElementById('amount').value);
                    if (isNaN(amount)) {
                        e.preventDefault();
                        alert('Please enter a valid amount');
                        return false;
                    }
                    
                    if (amount <= 0) {
                        e.preventDefault();
                        alert('Amount must be greater than 0');
                        return false;
                    }
                });
            }

            // Focus on search field when page loads
            const searchField = document.getElementById('search_term');
            if (searchField) {
                searchField.focus();
            }
        });
    </script>
</body>
</html>