import {Controller} from "@hotwired/stimulus"

import { Chart, registerables } from "chart.js";

Chart.register(...registerables);

export default class extends Controller {
  static targets = ['myChart'];

  canvasContext() {
      return this.myChartTarget.getContext('2d');
  }

  connect() {
    console.log('connected c')
    fetch('/chart_data').then(response =>  response.json()).then(data => {
      this.renderChart(data);
    }
    );
  }

  renderChart(data) {
    new Chart(this.canvasContext(), {
      type: 'doughnut',
      data: {
          labels: data.labels,
          datasets: data.datasets
      },
      options: {
          scales: {
              y: {
                  beginAtZero: false
              }
          }
      }
  });
  }
}
