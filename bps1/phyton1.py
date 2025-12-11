import json
import subprocess
import matplotlib.pyplot as plt
import pandas as pd
import os
from datetime import datetime
from matplotlib.ticker import FuncFormatter

# Configuration
OUTPUT_DIR = 'enhanced_visualizations'
PYTHON_SCRIPT = 'phyton.py'

def run_analysis_script():
    """Run the phyton.py script and capture its output"""
    try:
        result = subprocess.run(['python', PYTHON_SCRIPT], capture_output=True, text=True)
        if result.returncode != 0:
            print(f"Error running analysis script: {result.stderr}")
            return None
        return json.loads(result.stdout)
    except Exception as e:
        print(f"Failed to execute analysis script: {e}")
        return None

def create_output_directory():
    """Create output directory if it doesn't exist"""
    os.makedirs(OUTPUT_DIR, exist_ok=True)

def format_currency(x, pos):
    """Currency formatter for matplotlib"""
    return '${:,.0f}'.format(x)

def create_financial_health_chart(data, output_dir):
    """Create a visual representation of financial health metrics"""
    if 'financial_health' not in data:
        return None
    
    health = data['financial_health']
    if 'error' in health:
        return None
    
    metrics = {
        'Profit Margin (%)': health['profit_margin'],
        'Expense Ratio (%)': health['expense_ratio'],
        'Liquidity (Days)': health['liquidity_days']
    }
    
    fig, ax = plt.subplots(figsize=(10, 6))
    
    # Determine colors based on values
    colors = []
    for metric, value in metrics.items():
        if 'Margin' in metric or 'Liquidity' in metric:
            if value > 20: colors.append('green')
            elif value > 10: colors.append('yellowgreen')
            elif value > 0: colors.append('orange')
            else: colors.append('red')
        else:  # Expense ratio (lower is better)
            if value < 70: colors.append('green')
            elif value < 85: colors.append('yellowgreen')
            elif value < 100: colors.append('orange')
            else: colors.append('red')
    
    bars = ax.bar(metrics.keys(), metrics.values(), color=colors)
    
    # Add value labels
    for bar in bars:
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2., height,
                f'{height:.1f}',
                ha='center', va='bottom')
    
    ax.set_title('Financial Health Metrics')
    ax.set_ylabel('Value')
    ax.grid(True, linestyle='--', alpha=0.3)
    plt.xticks(rotation=15)
    plt.tight_layout()
    
    output_path = f'{output_dir}/financial_health.png'
    plt.savefig(output_path)
    plt.close()
    
    return output_path

def create_trend_comparison_chart(data, output_dir):
    """Create a comparison chart of income, expense, and profit trends"""
    if 'trend_analysis' not in data:
        return None
    
    trends = data['trend_analysis']
    metrics = []
    
    for metric in ['income', 'expenses', 'profit']:
        if metric in trends and 'percentage_change' in trends[metric]:
            metrics.append({
                'metric': metric.capitalize(),
                'change': trends[metric]['percentage_change'],
                'description': trends[metric]['description']
            })
    
    if not metrics:
        return None
    
    df = pd.DataFrame(metrics)
    
    fig, ax = plt.subplots(figsize=(10, 6))
    
    # Determine colors based on change direction
    colors = ['green' if x > 0 else 'red' for x in df['change']]
    
    bars = ax.bar(df['metric'], df['change'], color=colors)
    
    # Add value labels and descriptions
    for bar, desc in zip(bars, df['description']):
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2., height/2,
                desc, ha='center', va='center',
                color='white' if abs(height) > 5 else 'black',
                fontweight='bold')
        
        ax.text(bar.get_x() + bar.get_width()/2., height,
                f'{height:.1f}%', ha='center', va='bottom')
    
    ax.axhline(0, color='black', linewidth=0.8)
    ax.set_title('Percentage Change Trends')
    ax.set_ylabel('Percentage Change (%)')
    ax.grid(True, linestyle='--', alpha=0.3)
    plt.tight_layout()
    
    output_path = f'{output_dir}/trend_comparison.png'
    plt.savefig(output_path)
    plt.close()
    
    return output_path

def create_anomaly_chart(data, output_dir):
    """Create a visualization of detected anomalies"""
    if 'anomalies' not in data:
        return None
    
    anomalies = []
    for anomaly_type in ['income', 'expenses']:
        if anomaly_type in data['anomalies']:
            for anomaly in data['anomalies'][anomaly_type]:
                anomalies.append({
                    'type': f"{anomaly_type.capitalize()} ({anomaly['type']})",
                    'date': anomaly['date'],
                    'amount': anomaly['amount'],
                    'deviation': float(anomaly['deviation'].split()[0])
                })
    
    if not anomalies:
        return None
    
    df = pd.DataFrame(anomalies)
    df['date'] = pd.to_datetime(df['date'])
    
    fig, ax = plt.subplots(figsize=(12, 6))
    
    # Create scatter plot with size based on deviation
    scatter = ax.scatter(df['date'], df['amount'], 
                        c=df['deviation'], 
                        s=df['deviation']*50, 
                        cmap='viridis', 
                        alpha=0.6)
    
    # Add colorbar
    cbar = plt.colorbar(scatter)
    cbar.set_label('Standard Deviations')
    
    # Add labels and titles
    ax.set_title('Detected Financial Anomalies')
    ax.set_xlabel('Date')
    ax.set_ylabel('Amount ($)')
    ax.yaxis.set_major_formatter(FuncFormatter(format_currency))
    ax.grid(True, linestyle='--', alpha=0.3)
    
    # Add type labels to some points
    for i, row in df.iterrows():
        if row['deviation'] > 3:  # Only label significant anomalies
            ax.text(row['date'], row['amount'], row['type'],
                    fontsize=8, ha='center', va='bottom')
    
    plt.tight_layout()
    
    output_path = f'{output_dir}/anomalies_detected.png'
    plt.savefig(output_path)
    plt.close()
    
    return output_path

def create_forecast_chart(data, output_dir):
    """Create a visualization of forecast data"""
    if 'forecast' not in data:
        return None
    
    forecasts = {}
    for metric in ['income', 'expenses', 'profit']:
        if metric in data['forecast'] and isinstance(data['forecast'][metric], list):
            forecasts[metric] = data['forecast'][metric]
    
    if not forecasts:
        return None
    
    fig, ax = plt.subplots(figsize=(10, 6))
    
    # Plot each forecast
    for metric, items in forecasts.items():
        periods = [item['period'] for item in items]
        amounts = [item['amount'] for item in items]
        confidences = [item['confidence'] for item in items]
        
        # Use different colors for each metric
        color = {
            'income': 'green',
            'expenses': 'red',
            'profit': 'blue'
        }.get(metric, 'gray')
        
        # Plot with confidence as transparency
        for i, (period, amount, confidence) in enumerate(zip(periods, amounts, confidences)):
            alpha = confidence / 100
            ax.bar(f"{metric.capitalize()}\n{period}", amount, 
                  color=color, alpha=alpha, edgecolor='black')
            
            # Add confidence label
            ax.text(i if len(forecasts) == 1 else list(forecasts.keys()).index(metric) + (i * 0.3), 
                    amount/2, f"{confidence}%",
                    ha='center', va='center', color='white' if alpha > 0.5 else 'black')
    
    ax.set_title('Financial Forecast with Confidence Levels')
    ax.set_ylabel('Amount ($)')
    ax.yaxis.set_major_formatter(FuncFormatter(format_currency))
    plt.xticks(rotation=15)
    plt.grid(True, linestyle='--', alpha=0.3, axis='y')
    plt.tight_layout()
    
    output_path = f'{output_dir}/forecast_visualization.png'
    plt.savefig(output_path)
    plt.close()
    
    return output_path

def create_comprehensive_report(data):
    """Create all enhanced visualizations and return paths"""
    create_output_directory()
    
    report = {
        'financial_health': create_financial_health_chart(data, OUTPUT_DIR),
        'trend_comparison': create_trend_comparison_chart(data, OUTPUT_DIR),
        'anomaly_chart': create_anomaly_chart(data, OUTPUT_DIR),
        'forecast_visualization': create_forecast_chart(data, OUTPUT_DIR),
        'expense_categories': create_financial_health_chart(data, OUTPUT_DIR),
        'monthly_trends': create_trend_comparison_chart(data, OUTPUT_DIR),
        'profit_trend': create_forecast_chart(data, OUTPUT_DIR),
        
    }
    
    # Filter out None values
    return {k: v for k, v in report.items() if v is not None}

def main():
    """Main function to generate enhanced visualizations"""
    print("Running financial analysis...")
    analysis_data = run_analysis_script()
    
    if not analysis_data or 'error' in analysis_data:
        print("Failed to get analysis data")
        return
    
    print("Creating enhanced visualizations...")
    visualizations = create_comprehensive_report(analysis_data)
    
    if not visualizations:
        print("No visualizations were created")
        return
    
    print("\nGenerated the following visualizations:")
    for name, path in visualizations.items():
        print(f"- {name.replace('_', ' ').title()}: {path}")
    
    # Create a simple HTML report
    create_html_report(analysis_data, visualizations)

def create_html_report(data, visualizations):
    """Create a simple HTML report with all visualizations"""
    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Therapy Center Financial Report</title>
        <style>
            body {{ font-family: Arial, sans-serif; margin: 20px; }}
            h1 {{ color: #2c3e50; }}
            h2 {{ color: #3498db; border-bottom: 1px solid #eee; padding-bottom: 5px; }}
            .container {{ max-width: 1200px; margin: 0 auto; }}
            .grid {{ display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; }}
            .card {{ border: 1px solid #ddd; padding: 15px; border-radius: 5px; }}
            .health-status {{ 
                padding: 10px; 
                border-radius: 5px; 
                font-weight: bold; 
                text-align: center;
                margin-bottom: 15px;
            }}
            .good {{ background-color: #d5f5e3; color: #27ae60; }}
            .fair {{ background-color: #fef9e7; color: #f39c12; }}
            .poor {{ background-color: #fadbd8; color: #e74c3c; }}
            img {{ max-width: 100%; height: auto; }}
            .metrics {{ display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }}
            .metric {{ text-align: center; padding: 10px; border-radius: 5px; background-color: #f8f9fa; }}
            .metric-value {{ font-size: 24px; font-weight: bold; }}
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Therapy Center Financial Report</h1>
            <p>Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
            
            <h2>Financial Health Summary</h2>
    """
    
    # Add financial health section
    if 'financial_health' in data:
        health = data['financial_health']
        status_class = 'good' if health.get('status', '').lower() in ('excellent', 'good') else \
                     'fair' if health.get('status', '').lower() == 'fair' else 'poor'
        
        html_content += f"""
            <div class="health-status {status_class}">
                Status: {health.get('status', 'N/A')} - {health.get('status_description', '')}
            </div>
            
            <div class="metrics">
                <div class="metric">
                    <div>Total Income</div>
                    <div class="metric-value">${health.get('total_income', 0):,.2f}</div>
                </div>
                <div class="metric">
                    <div>Total Expenses</div>
                    <div class="metric-value">${health.get('total_operating_expenses', 0):,.2f}</div>
                </div>
                <div class="metric">
                    <div>Net Profit</div>
                    <div class="metric-value" style="color: {'green' if health.get('profit', 0) >= 0 else 'red'}">
                        ${health.get('profit', 0):,.2f}
                    </div>
                </div>
            </div>
        """
    
    # Add visualizations
    html_content += """
            <h2>Financial Visualizations</h2>
            <div class="grid">
    """
    
    for name, path in visualizations.items():
        html_content += f"""
                <div class="card">
                    <h3>{name.replace('_', ' ').title()}</h3>
                    <img src="{name}.png">
                </div>
        """
    
    # Add trend analysis if available
    if 'trend_analysis' in data:
        html_content += """
            </div>
            <h2>Trend Analysis</h2>
            <div class="grid">
        """
        
        for metric, analysis in data['trend_analysis'].items():
            if isinstance(analysis, dict) and 'description' in analysis:
                html_content += f"""
                    <div class="card">
                        <h3>{metric.capitalize()}</h3>
                        <p>{analysis['description']}</p>
                        <p>Change: {analysis.get('percentage_change', 'N/A')}%</p>
                    </div>
                """
    
    html_content += """
            </div>
        </div>
    </body>
    </html>
    """
    
    report_path = f"{OUTPUT_DIR}/financial_report.html"
    with open(report_path, 'w') as f:
        f.write(html_content)
    
    print(f"\nComplete report generated: {report_path}")

if __name__ == "__main__":
    main()