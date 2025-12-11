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

// Fetch statistics
$stats = [];
try {
    // Customer stats
    $stmt = $pdo->query("SELECT COUNT(*) as total_customers, 
                         SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active_customers 
                         FROM customers");
    $stats['customers'] = $stmt->fetch(PDO::FETCH_ASSOC);

    // Employee stats
    $stmt = $pdo->query("SELECT COUNT(*) as total_employees, 
                         SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active_employees 
                         FROM employees");
    $stats['employees'] = $stmt->fetch(PDO::FETCH_ASSOC);

    // Payment stats
    $stmt = $pdo->query("SELECT COUNT(*) as total_payments, 
                         SUM(amount) as total_revenue 
                         FROM payments");
    $stats['payments'] = $stmt->fetch(PDO::FETCH_ASSOC);

    // Salary stats
    $stmt = $pdo->query("SELECT COUNT(*) as total_salaries, 
                         SUM(basic_salary + allowances - deductions) as total_payout 
                         FROM employee_salaries");
    $stats['salaries'] = $stmt->fetch(PDO::FETCH_ASSOC);

    // Recent customers
    $stmt = $pdo->query("SELECT first_name, last_name, unique_id, registration_date 
                         FROM customers 
                         ORDER BY registration_date DESC 
                         LIMIT 5");
    $stats['recent_customers'] = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Recent payments
    $stmt = $pdo->query("SELECT p.amount, p.payment_date, 
                         c.first_name, c.last_name, c.unique_id 
                         FROM payments p 
                         JOIN customers c ON p.customer_id = c.id 
                         ORDER BY p.payment_date DESC 
                         LIMIT 5");
    $stats['recent_payments'] = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Recent salaries
    $stmt = $pdo->query("SELECT s.basic_salary, s.allowances, s.deductions, s.payment_date, 
                         e.first_name, e.last_name 
                         FROM employee_salaries s 
                         JOIN employees e ON s.employee_id = e.id 
                         ORDER BY s.payment_date DESC 
                         LIMIT 5");
    $stats['recent_salaries'] = $stmt->fetchAll(PDO::FETCH_ASSOC);

} catch (PDOException $e) {
    die("Error fetching statistics: " . $e->getMessage());
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Therapy Center - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        .dashboard-header {
            background-color: #4e73df;
            color: white;
            padding: 20px 0;
            margin-bottom: 30px;
        }
        .stat-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            margin-bottom: 20px;
            border: none;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card .card-body {
            padding: 1.5rem;
        }
        .stat-card .stat-value {
            font-size: 2rem;
            font-weight: bold;
        }
        .stat-card .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .stat-card .stat-icon {
            font-size: 2.5rem;
            opacity: 0.3;
            position: absolute;
            right: 20px;
            top: 20px;
        }
        .recent-activity {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .activity-item {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .activity-item:last-child {
            border-bottom: none;
        }
        .activity-date {
            font-size: 0.8rem;
            color: #6c757d;
        }
        .profit-card {
            background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
            color: white;
            border-radius: 10px;
        }
        .profit-value {
            font-size: 2.5rem;
            font-weight: bold;
        }
        .nav-card {
            cursor: pointer;
            transition: all 0.3s;
        }
        .nav-card:hover {
            background-color: #f8f9fa;
            transform: scale(1.02);
        }
        .nav-card .card-body {
            text-align: center;
        }
        .nav-card i {
            font-size: 2rem;
            margin-bottom: 10px;
            color: #4e73df;
        }
    </style>
</head>
<body>
    <div class="dashboard-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="bi bi-speedometer2"></i> Therapy Center Dashboard</h1>
                    <p class="mb-0">Overview of your center's performance</p>
                </div>
                <div class="col-md-4 text-end">
                    <span class="badge bg-light text-dark">
                        <?php echo date('l, F j, Y'); ?>
                    </span>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Quick Stats Row -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stat-card border-left-primary">
                    <div class="card-body">
                        <div class="stat-label">Total Customers</div>
                        <div class="stat-value"><?php echo $stats['customers']['total_customers']; ?></div>
                        <div class="text-success small">
                            <?php echo $stats['customers']['active_customers']; ?> active
                        </div>
                        <i class="bi bi-people-fill stat-icon text-primary"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card border-left-success">
                    <div class="card-body">
                        <div class="stat-label">Total Employees</div>
                        <div class="stat-value"><?php echo $stats['employees']['total_employees']; ?></div>
                        <div class="text-success small">
                            <?php echo $stats['employees']['active_employees']; ?> active
                        </div>
                        <i class="bi bi-person-badge stat-icon text-success"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card border-left-info">
                    <div class="card-body">
                        <div class="stat-label">Total Revenue</div>
                        <div class="stat-value">$<?php echo number_format($stats['payments']['total_revenue'] ?? 0, 2); ?></div>
                        <div class="text-muted small">
                            <?php echo $stats['payments']['total_payments']; ?> payments
                        </div>
                        <i class="bi bi-cash-coin stat-icon text-info"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card border-left-warning">
                    <div class="card-body">
                        <div class="stat-label">Total Salaries</div>
                        <div class="stat-value">$<?php echo number_format($stats['salaries']['total_payout'] ?? 0, 2); ?></div>
                        <div class="text-muted small">
                            <?php echo $stats['salaries']['total_salaries']; ?> payments
                        </div>
                        <i class="bi bi-wallet2 stat-icon text-warning"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Profit Summary -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="profit-card p-4">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h3><i class="bi bi-graph-up"></i> Net Profit</h3>
                            <p class="mb-0">Total revenue minus total salaries paid</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="profit-value">
                                $<?php 
                                    $revenue = $stats['payments']['total_revenue'] ?? 0;
                                    $salaries = $stats['salaries']['total_payout'] ?? 0;
                                    echo number_format($revenue - $salaries, 2); 
                                ?>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Navigation -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card nav-card h-100" onclick="window.location.href='customer management.php'">
                    <div class="card-body">
                        <i class="bi bi-person-plus"></i>
                        <h5>Register Customer</h5>
                        <p class="text-muted">Add new customers to the system</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card nav-card h-100" onclick="window.location.href='payment.php'">
                    <div class="card-body">
                        <i class="bi bi-credit-card"></i>
                        <h5>Record Payment</h5>
                        <p class="text-muted">Process customer payments</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card nav-card h-100" onclick="window.location.href='employee.php'">
                    <div class="card-body">
                        <i class="bi bi-person-lines-fill"></i>
                        <h5>Manage Employees</h5>
                        <p class="text-muted">View and edit employee records</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card nav-card h-100" onclick="window.location.href='employee salary.php'">
                    <div class="card-body">
                        <i class="bi bi-cash-stack"></i>
                        <h5>Process Salaries</h5>
                        <p class="text-muted">Record employee salary payments</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card nav-card h-100" onclick="window.location.href='enhanced_visualizations/financial_report.html'">
                    <div class="card-body">
                        <i class="bi bi-cash-stack"></i>
                        <h5>income Analysis</h5>
                        <p class="text-muted">View income Analysis and Graphs</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="row">
            <div class="col-md-4">
                <div class="recent-activity">
                    <h5><i class="bi bi-people"></i> Recent Customers</h5>
                    <?php foreach ($stats['recent_customers'] as $customer): ?>
                        <div class="activity-item">
                            <div class="d-flex justify-content-between">
                                <strong><?php echo htmlspecialchars($customer['first_name']) . ' ' . htmlspecialchars($customer['last_name']); ?></strong>
                                <span class="badge bg-light text-dark"><?php echo htmlspecialchars($customer['unique_id']); ?></span>
                            </div>
                            <div class="activity-date">
                                Registered on <?php echo date('M j, Y', strtotime($customer['registration_date'])); ?>
                            </div>
                        </div>
                    <?php endforeach; ?>
                    <?php if (count($stats['recent_customers']) === 0): ?>
                        <div class="text-muted">No recent customers found</div>
                    <?php endif; ?>
                    <div class="text-end mt-2">
                        <a href="customers.php" class="btn btn-sm btn-outline-primary">View All</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="recent-activity">
                    <h5><i class="bi bi-cash"></i> Recent Payments</h5>
                    <?php foreach ($stats['recent_payments'] as $payment): ?>
                        <div class="activity-item">
                            <div class="d-flex justify-content-between">
                                <strong>$<?php echo number_format($payment['amount'], 2); ?></strong>
                                <span><?php echo htmlspecialchars($payment['first_name'] . ' ' . substr($payment['last_name'], 0, 1) . '.'); ?></span>
                            </div>
                            <div class="activity-date">
                                Paid on <?php echo date('M j, Y', strtotime($payment['payment_date'])); ?>
                            </div>
                        </div>
                    <?php endforeach; ?>
                    <?php if (count($stats['recent_payments']) === 0): ?>
                        <div class="text-muted">No recent payments found</div>
                    <?php endif; ?>
                    <div class="text-end mt-2">
                        <a href="payments.php" class="btn btn-sm btn-outline-primary">View All</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="recent-activity">
                    <h5><i class="bi bi-wallet2"></i> Recent Salaries</h5>
                    <?php foreach ($stats['recent_salaries'] as $salary): ?>
                        <div class="activity-item">
                            <div class="d-flex justify-content-between">
                                <strong>$<?php echo number_format($salary['basic_salary'] + $salary['allowances'] - $salary['deductions'], 2); ?></strong>
                                <span><?php echo htmlspecialchars($salary['first_name'] . ' ' . substr($salary['last_name'], 0, 1) . '.'); ?></span>
                            </div>
                            <div class="activity-date">
                                Paid on <?php echo date('M j, Y', strtotime($salary['payment_date'])); ?>
                            </div>
                        </div>
                    <?php endforeach; ?>
                    <?php if (count($stats['recent_salaries']) === 0): ?>
                        <div class="text-muted">No recent salaries found</div>
                    <?php endif; ?>
                    <div class="text-end mt-2">
                        <a href="salary.php" class="btn btn-sm btn-outline-primary">View All</a>
                    </div>
                </div>
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
        // Simple animation for stat cards on page load
        document.addEventListener('DOMContentLoaded', function() {
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '1';
                }, index * 100);
            });
        });
    </script>
</body>
</html>