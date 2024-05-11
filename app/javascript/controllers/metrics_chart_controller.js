import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js"; // Assuming Chart.js usage

import 'chartjs-adapter-moment';

Chart.register(...registerables);

export default class extends Controller {
  static targets = ["chart"]

  connect() {
    this.loadChartData();
  }

  loadChartData() {
    fetch('/pods_data.json')
      .then(response => response.json())
      .then(data => this.renderChart(data))
      .catch(error => console.error("Error loading chart data:", error));
  }

  renderChart(data) {
    const ctx = this.chartTarget.getContext('2d');
    const datasets = data.map(pod => ({
      label: `${pod.name} CPU Usage`,
      data: pod.data.map(d => ({ x: d.time, y: d.cpu })),
      borderColor: this.getRandomColor(),
      fill: false,
    }));

    new Chart(ctx, {
      type: 'line',
      data: { datasets },
      options: {
        scales: {
          x: {
            type: 'time',
            time: {
              unit: 'minute',
            }
          },
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'CPU Usage (%)'
            }
          }
        },
        plugins: {
          tooltip: {
            mode: 'index',
            intersect: false,
          },
          legend: {
            display: true,
            position: 'top',
          }
        }
      }
    });
  }

  getRandomColor() {
    const r = Math.floor(Math.random() * 256);
    const g = Math.floor(Math.random() * 256);
    const b = Math.floor(Math.random() * 256);
    return `rgb(${r},${g},${b})`;
  }
}
