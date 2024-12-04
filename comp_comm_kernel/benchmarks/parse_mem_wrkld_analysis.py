import re
import argparse
from collections import defaultdict

def calculate_and_print_averages(file_path):
    """Extract tables and print averaged metrics in the specified format."""
    in_target_section = False
    in_table = False
    metrics = defaultdict(list)

    with open(file_path, "r") as file:
        lines = file.readlines()

    for line in lines:
        # Check for the specific section header
        if line.strip() == "Section: Memory Workload Analysis":
            in_target_section = True
            continue

        if in_target_section:
            if "Metric Name" in line:  # Start of the table
                in_table = True
                continue

        if in_table:
            # Extract metric data
            match = re.match(r"([\w/\s]+)\s+[%A-Za-z/]+\s+([\d.]+)", line.strip())
            if match:
                metric_name = match.group(1).strip()
                metric_value = float(match.group(2).strip())
                metrics[metric_name].append(metric_value)
            
            if "Mem Pipes Busy" in line:  # End of the table
                in_target_section = False
                in_table = False

    # Calculate averages for each metric
    averaged_metrics = {metric: sum(values) / len(values) for metric, values in metrics.items()}

    # Print the averaged table
    print("Averaged Results\n")
    print("Section: Memory Workload Analysis")
    print("--------------------------- ----------- ------------")
    print("Metric Name                 Metric Unit Metric Value")
    print("--------------------------- ----------- ------------")
    for metric, avg_value in averaged_metrics.items():
        # Determine unit based on metric name for consistency
        unit = "%" if "Rate" in metric or "Busy" in metric else "Gbyte/s" if "Throughput" in metric else ""
        print(f"{metric:<27} {unit:>11} {avg_value:>12.2f}")
    print("--------------------------- ----------- ------------")

def main():
    # Specify the input file path (adjust as needed)
    parser = argparse.ArgumentParser(description="Extract and copy specific tables to a new file.")
    parser.add_argument("input_file", type=str, help="Path to the input file")
    args = parser.parse_args()
    calculate_and_print_averages(args.input_file)

if __name__ == "__main__":
    main()
