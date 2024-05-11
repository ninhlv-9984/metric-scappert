import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js"; // Assuming Chart.js usage

Chart.register(...registerables);

export default class extends Controller {
  static targets = ['myRequest'];

  connect() {
    // Fetch data for the chart
    console.log(this.myRequestTarget);
    fetch('/chart_request_data') // Adjust the URL as needed
      .then(response => response.json())
      .then(data => this.renderChart(data));
  }

  renderChart(data) {
    const ctx = this.myRequestTarget.getContext('2d');
    new Chart(ctx, {
      type: 'bar', // Adjust chart type as needed
      data: {
        labels: data.labels,
        datasets: data.datasets
      },
      options: {
        // Chart options (customize as needed)
      }
    });
  }
}
