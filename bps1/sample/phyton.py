import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime, timedelta
import sys
import json
import numpy as np
import os
from matplotlib.ticker import FuncFormatter

# Database connection configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'therapy_center'
}

# Visualization settings
try:
    plt.style.use('seaborn-v0_8')  # Updated style name
except:
    plt.style.use('ggplot')  # Fallback style
COLORS = {
    'income': '#4CAF50',
    'expenses': '#F44336',
    'profit': '#2196F3',
    'salaries': '#FF9800',
    'anomaly': '#9C27B0'
}

def connect_to_database():
    """Establish connection to MySQL database"""
    try:
        conn = mysql.connector.connect(**db_config)
        return conn
    except mysql.connector.Error as err:
        print(f"Error connecting to database: {err}", file=sys.stderr)
        return None

def fetch_data(conn, query):
    """Fetch data from database and return as DataFrame"""
    try:
        df = pd.read_sql(query, conn)
        return df
    except Exception as e:
        print(f"Error fetching data: {e}", file=sys.stderr)
        return None

def calculate_net_salary(salaries_df):
    """Calculate net salary by adding basic salary and allowances, then subtracting deductions"""
    if salaries_df is not None and not salaries_df.empty:
        salaries_df['net_salary'] = salaries_df['basic_salary'] + salaries_df['allowances'] - salaries_df['deductions']
    return salaries_df

def generate_financial_health(payments_df, salaries_df, expenses_df):
    """Generate financial health assessment with robust error handling"""
    try:
        # Handle empty DataFrames
        total_income = payments_df['amount'].sum() if payments_df is not None and not payments_df.empty else 0
        total_salaries = salaries_df['net_salary'].sum() if salaries_df is not None and not salaries_df.empty else 0
        total_expenses = expenses_df['amount'].sum() if expenses_df is not None and not expenses_df.empty else 0
        
        net_profit = total_income - total_salaries - total_expenses
        
        # Calculate financial health metrics with proper error handling
        profit_margin = (net_profit / total_income) * 100 if total_income > 0 else 0
        expense_ratio = ((total_salaries + total_expenses) / total_income) * 100 if total_income > 0 else 0
        
        # Determine liquidity days (more realistic calculation)
        avg_daily_expenses = (total_salaries + total_expenses) / 365  # Using annualized daily average
        liquidity_days = (total_income / avg_daily_expenses) if avg_daily_expenses > 0 else 0
        
        # Enhanced financial health status determination
        if profit_margin > 25:
            status = "EXCELLENT"
            status_description = "Strong profitability with healthy margins"
        elif profit_margin > 15:
            status = "GOOD"
            status_description = "Sustainable profitability"
        elif profit_margin > 5:
            status = "FAIR"
            status_description = "Margins could be improved"
        elif profit_margin > 0:
            status = "MARGINAL"
            status_description = "Barely profitable, needs attention"
        else:
            status = "CONCERNING"
            status_description = "Operating at a loss, immediate action needed"
        
        return {
            "status": status,
            "status_description": status_description,
            "profit_margin": round(profit_margin, 1),
            "expense_ratio": round(expense_ratio, 1),
            "liquidity_days": round(liquidity_days, 1),
            "total_income": round(total_income, 2),
            "total_salaries": round(total_salaries, 2),
            "total_expenses": round(total_expenses, 2),
            "total_operating_expenses": round(total_salaries + total_expenses, 2),
            "profit": round(net_profit, 2)
        }
    except Exception as e:
        print(f"Error in financial health calculation: {e}", file=sys.stderr)
        return {
            "error": "Could not calculate financial health metrics",
            "details": str(e)
        }

def analyze_trends(series, name):
    """Analyze trends in a time series with more sophisticated analysis"""
    if len(series) < 2:
        return {
            "trend": "insufficient_data",
            "strength": 0,
            "description": f"Not enough data to analyze {name} trends"
        }
    
    # Calculate percentage change
    last_value = series.iloc[-1]
    prev_value = series.iloc[-2]
    pct_change = ((last_value - prev_value) / prev_value) * 100 if prev_value != 0 else 0
    
    # Determine trend direction and strength
    if pct_change > 5:
        trend = "strong_up"
        strength = min(90, 50 + abs(pct_change))
    elif pct_change > 0:
        trend = "up"
        strength = min(75, 50 + abs(pct_change))
    elif pct_change < -5:
        trend = "strong_down"
        strength = min(90, 50 + abs(pct_change))
    elif pct_change < 0:
        trend = "down"
        strength = min(75, 50 + abs(pct_change))
    else:
        trend = "stable"
        strength = 50
    
    # Generate description
    descriptions = {
        "strong_up": f"Significant increase in {name} ({pct_change:.1f}%)",
        "up": f"Moderate increase in {name} ({pct_change:.1f}%)",
        "stable": f"{name} remained stable",
        "down": f"Moderate decrease in {name} ({pct_change:.1f}%)",
        "strong_down": f"Significant decrease in {name} ({pct_change:.1f}%)"
    }
    
    return {
        "trend": trend,
        "strength": round(strength),
        "percentage_change": round(pct_change, 1),
        "description": descriptions.get(trend, f"{name} trend changed")
    }

def detect_seasonality(series):
    """Simple seasonality detection"""
    if len(series) < 3:
        return {"detected": False, "message": "Insufficient data for seasonality analysis"}
    
    # Simple check for monthly patterns (would be enhanced with proper time series analysis)
    monthly_avg = series.groupby(series.index.month).mean()
    std_dev = monthly_avg.std()
    
    if std_dev > (monthly_avg.mean() * 0.3):  # Arbitrary threshold
        peak_month = monthly_avg.idxmax()
        return {
            "detected": True,
            "message": f"Possible seasonality detected with peak in month {peak_month}",
            "peak_month": peak_month,
            "seasonality_strength": round((std_dev / monthly_avg.mean()) * 100)
        }
    return {"detected": False, "message": "No strong seasonality detected"}

def generate_forecast(series, periods=3):
    """Generate simple forecasts"""
    if len(series) < 2:
        return None
    
    try:
        # Simple moving average forecast (would be enhanced with proper forecasting models)
        avg = series.mean()
        last_value = series.iloc[-1]
        growth_rate = (last_value - series.iloc[-2]) / series.iloc[-2] if series.iloc[-2] != 0 else 0
        
        forecasts = []
        for i in range(1, periods + 1):
            forecast_value = last_value * (1 + growth_rate) ** i
            # Confidence decreases for longer forecasts
            confidence = max(10, 80 - (i * 15))
            forecasts.append({
                "period": f"{i} month{'s' if i > 1 else ''} ahead",
                "amount": round(forecast_value, 2),
                "confidence": round(confidence)
            })
        
        return forecasts
    except Exception as e:
        print(f"Error in forecasting: {e}", file=sys.stderr)
        return None

def detect_anomalies(df, amount_col, date_col):
    """Detect anomalies in financial data"""
    if df is None or df.empty:
        return []
    
    try:
        anomalies = []
        amounts = df[amount_col]
        
        # Calculate z-scores to find outliers
        mean = amounts.mean()
        std = amounts.std()
        
        if std > 0:  # Only calculate if there's variation
            df['z_score'] = (amounts - mean) / std
            outliers = df[abs(df['z_score']) > 2.5]  # 2.5 standard deviations
            
            for _, row in outliers.iterrows():
                anomalies.append({
                    "date": row[date_col].strftime('%Y-%m-%d') if hasattr(row[date_col], 'strftime') else str(row[date_col]),
                    "type": "high" if row[amount_col] > mean else "low",
                    "amount": round(row[amount_col], 2),
                    "deviation": f"{round(abs(row['z_score']), 1)} standard deviations",
                    "explanation": "Unusually high transaction" if row[amount_col] > mean else "Unusually low transaction"
                })
        
        return anomalies
    except Exception as e:
        print(f"Error detecting anomalies: {e}", file=sys.stderr)
        return []

def create_visualizations(payments_monthly, salaries_monthly, expenses_monthly, expense_category_analysis, output_dir='visualizations'):
    """Generate visualizations for the financial data"""
    try:
        # Create output directory if it doesn't exist
        os.makedirs(output_dir, exist_ok=True)
        
        # Format currency for axis labels
        def currency_formatter(x, pos):
            return '${:,.0f}'.format(x)
        
        formatter = FuncFormatter(currency_formatter)
        
        # 1. Monthly Income vs Expenses Trend
        plt.figure(figsize=(12, 6))
        if not payments_monthly.empty:
            plt.plot(payments_monthly.index, payments_monthly.values, 
                    label='Income', color=COLORS['income'], marker='o')
        if not expenses_monthly.empty:
            plt.plot(expenses_monthly.index, expenses_monthly.values, 
                    label='Expenses', color=COLORS['expenses'], marker='o')
        plt.gca().yaxis.set_major_formatter(formatter)
        plt.title('Monthly Income vs Expenses')
        plt.xlabel('Month')
        plt.ylabel('Amount ($)')
        plt.legend()
        plt.grid(True, linestyle='--', alpha=0.7)
        plt.tight_layout()
        plt.savefig(f'{output_dir}/monthly_trends.png')
        plt.close()
        
        # 2. Profit Trend (if we have both income and expenses)
        if not payments_monthly.empty and not expenses_monthly.empty:
            profit_monthly = payments_monthly - expenses_monthly
            plt.figure(figsize=(12, 6))
            plt.plot(profit_monthly.index, profit_monthly.values, 
                    label='Profit', color=COLORS['profit'], marker='o')
            plt.fill_between(profit_monthly.index, profit_monthly.values, 
                           where=(profit_monthly.values > 0), 
                           color='green', alpha=0.3)
            plt.fill_between(profit_monthly.index, profit_monthly.values, 
                           where=(profit_monthly.values <= 0), 
                           color='red', alpha=0.3)
            plt.gca().yaxis.set_major_formatter(formatter)
            plt.title('Monthly Profit Trend')
            plt.xlabel('Month')
            plt.ylabel('Amount ($)')
            plt.legend()
            plt.grid(True, linestyle='--', alpha=0.7)
            plt.tight_layout()
            plt.savefig(f'{output_dir}/profit_trend.png')
            plt.close()
        
        # 3. Expense Categories Pie Chart
        if expense_category_analysis and 'category_distribution' in expense_category_analysis:
            labels = expense_category_analysis['category_distribution']['labels']
            values = expense_category_analysis['category_distribution']['values']
            
            plt.figure(figsize=(10, 10))
            plt.pie(values, labels=labels, autopct='%1.1f%%',
                   startangle=90, colors=plt.cm.Pastel1.colors)
            plt.title('Expense Categories Distribution')
            plt.tight_layout()
            plt.savefig(f'{output_dir}/expense_categories.png')
            plt.close()
        
        # 4. Salary Distribution (if salary data exists)
        if not salaries_monthly.empty:
            plt.figure(figsize=(12, 6))
            plt.bar(salaries_monthly.index.strftime('%Y-%m'), 
                   salaries_monthly.values, 
                   color=COLORS['salaries'])
            plt.gca().yaxis.set_major_formatter(formatter)
            plt.title('Monthly Salary Payments')
            plt.xlabel('Month')
            plt.ylabel('Amount ($)')
            plt.xticks(rotation=45)
            plt.grid(True, linestyle='--', alpha=0.7)
            plt.tight_layout()
            plt.savefig(f'{output_dir}/salary_distribution.png')
            plt.close()
        
        return {
            "visualizations": [
                "monthly_trends.png",
                "profit_trend.png",
                "expense_categories.png",
                "salary_distribution.png"
            ]
        }
    except Exception as e:
        print(f"Error generating visualizations: {e}", file=sys.stderr)
        return {"error": "Failed to generate visualizations", "details": str(e)}

def generate_analytics(payments_df, salaries_df, expenses_df):
    """Generate comprehensive analytics with better error handling and more robust analysis"""
    try:
        # Convert date columns and handle missing data
        date_columns = {
            'payments': 'payment_date',
            'salaries': 'payment_date',
            'expenses': 'expense_date'
        }
        
        for df, col in [(payments_df, date_columns['payments']), 
                        (salaries_df, date_columns['salaries']), 
                        (expenses_df, date_columns['expenses'])]:
            if df is not None and not df.empty and col in df.columns:
                df['date'] = pd.to_datetime(df[col], errors='coerce')
                df = df.dropna(subset=['date'])
        
        # Calculate net salary if not already present
        salaries_df = calculate_net_salary(salaries_df)
        
        # Monthly trends with error handling
        payments_monthly = payments_df.resample('M', on='date')['amount'].sum() if payments_df is not None and not payments_df.empty else pd.Series()
        salaries_monthly = salaries_df.resample('M', on='date')['net_salary'].sum() if salaries_df is not None and not salaries_df.empty else pd.Series()
        expenses_monthly = expenses_df.resample('M', on='date')['amount'].sum() if expenses_df is not None and not expenses_df.empty else pd.Series()
        
        # Trend analysis
        income_trend = analyze_trends(payments_monthly, "income")
        expenses_trend = analyze_trends(expenses_monthly, "expenses")
        
        # Calculate profit trend if we have both income and expenses
        if not payments_monthly.empty and not expenses_monthly.empty:
            profit_monthly = payments_monthly - expenses_monthly
            profit_trend = analyze_trends(profit_monthly, "profit")
        else:
            profit_trend = {"error": "Insufficient data to calculate profit trend"}
        
        # Generate forecasts
        income_forecast = generate_forecast(payments_monthly) if not payments_monthly.empty else None
        expenses_forecast = generate_forecast(expenses_monthly) if not expenses_monthly.empty else None
        profit_forecast = generate_forecast(profit_monthly) if 'profit_monthly' in locals() and not profit_monthly.empty else None
        
        # Detect anomalies
        payment_anomalies = detect_anomalies(payments_df, 'amount', 'date') if payments_df is not None else []
        expense_anomalies = detect_anomalies(expenses_df, 'amount', 'date') if expenses_df is not None else []
        
        # Expense category analysis
        expense_category_analysis = {}
        if expenses_df is not None and not expenses_df.empty and 'category' in expenses_df.columns:
            category_totals = expenses_df.groupby('category')['amount'].sum().sort_values(ascending=False)
            expense_category_analysis = {
                "top_categories": [
                    {"category": cat, "amount": round(amt, 2), "percentage": round((amt / category_totals.sum()) * 100, 1)}
                    for cat, amt in category_totals.items()
                ],
                "category_distribution": {
                    "labels": category_totals.index.tolist(),
                    "values": category_totals.values.round(2).tolist()
                }
            }
        
        # Generate visualizations
        visualization_results = create_visualizations(
            payments_monthly, 
            salaries_monthly, 
            expenses_monthly, 
            expense_category_analysis
        )
        
        return {
            "financial_health": generate_financial_health(payments_df, salaries_df, expenses_df),
            "trend_analysis": {
                "income": income_trend,
                "expenses": expenses_trend,
                "profit": profit_trend
            },
            "seasonality_analysis": {
                "income": detect_seasonality(payments_monthly) if not payments_monthly.empty else {"error": "No income data"},
                "expenses": detect_seasonality(expenses_monthly) if not expenses_monthly.empty else {"error": "No expense data"}
            },
            "expense_analysis": expense_category_analysis,
            "forecast": {
                "income": income_forecast or {"error": "No forecast available"},
                "expenses": expenses_forecast or {"error": "No forecast available"},
                "profit": profit_forecast or {"error": "No forecast available"}
            },
            "anomalies": {
                "income": payment_anomalies,
                "expenses": expense_anomalies
            },
            "visualizations": visualization_results,
            "data_summary": {
                "income_records": len(payments_df) if payments_df is not None else 0,
                "salary_records": len(salaries_df) if salaries_df is not None else 0,
                "expense_records": len(expenses_df) if expenses_df is not None else 0,
                "analysis_period": {
                    "start_date": min(
                        payments_df['date'].min() if payments_df is not None and not payments_df.empty else pd.Timestamp.max,
                        salaries_df['date'].min() if salaries_df is not None and not salaries_df.empty else pd.Timestamp.max,
                        expenses_df['date'].min() if expenses_df is not None and not expenses_df.empty else pd.Timestamp.max
                    ).strftime('%Y-%m-%d'),
                    "end_date": max(
                        payments_df['date'].max() if payments_df is not None and not payments_df.empty else pd.Timestamp.min,
                        salaries_df['date'].max() if salaries_df is not None and not salaries_df.empty else pd.Timestamp.min,
                        expenses_df['date'].max() if expenses_df is not None and not expenses_df.empty else pd.Timestamp.min
                    ).strftime('%Y-%m-%d')
                }
            }
        }
    except Exception as e:
        print(f"Error in analytics generation: {e}", file=sys.stderr)
        return {
            "error": "Failed to generate analytics",
            "details": str(e)
        }

def main():
    """Main function to run the analysis with proper error handling"""
    try:
        # Connect to database
        conn = connect_to_database()
        if not conn:
            return {"error": "Could not connect to database"}
        
        try:
            # Fetch data from all tables
            payments_query = "SELECT * FROM payments"
            salaries_query = "SELECT * FROM employee_salaries"
            expenses_query = "SELECT * FROM expenses"
            
            payments_df = fetch_data(conn, payments_query)
            salaries_df = fetch_data(conn, salaries_query)
            expenses_df = fetch_data(conn, expenses_query)
            
            if payments_df is None and salaries_df is None and expenses_df is None:
                return {"error": "No data available from any table"}
            
            analytics_results = generate_analytics(payments_df, salaries_df, expenses_df)
            return analytics_results
            
        finally:
            conn.close()
    except Exception as e:
        print(f"Unexpected error in main: {e}", file=sys.stderr)
        return {
            "error": "Unexpected error in analysis",
            "details": str(e)
        }

if __name__ == "__main__":
    try:
        results = main()
        print(json.dumps(results, indent=2))
    except Exception as e:
        print(json.dumps({
            "error": "Failed to execute analysis",
            "details": str(e)
        }))