// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import Chart from 'chart.js/auto'; // import ChartJS library

// Set up ChartJS hook for LiveView
let hooks = {}
hooks.ChartJS = {
  chart: null,

  // Define mounted callback
  mounted() {
    // Define chart type and variables to be sent from LiveView
    const ctx = this.el.getContext('2d');
    const userName = JSON.parse(this.el.getAttribute('data-user-name'))
    const labels = JSON.parse(this.el.getAttribute('data-labels'));
    const dataPoints = JSON.parse(this.el.getAttribute('data-scores'));
    const data = {
      type: 'radar',
      data: {
        labels: labels,
        datasets: [{
          label: userName,
          data: dataPoints
        }]
      },
      // Set options for chart
      options: {
        responsive: false,
        maintainAspectRatio: true,
        pointRadius: 0,
        borderWidth: 0,
        backgroundColor: 'rgba(255, 192, 203, 0.6)',
        scales: {
          r: {
            ticks: {
              display: false,
            },
            // Set skill label size
            pointLabels: {
              font: {
                size: 18
              }
            },
          },
        },
        plugins: {
          // Set employee font size
          legend: {
            labels: {
              font: {
                size: 25
              }
            }
          }
        }
      }
    };
    this.chart = new Chart(ctx, data);
  },

  // Define updated callback
  updated() {
    let canvas = this.el
    let userName = JSON.parse(canvas.getAttribute("data-user-name"))
    let labels = JSON.parse(canvas.getAttribute("data-labels"))
    let dataPoints = JSON.parse(canvas.getAttribute("data-scores"))

    if (this.chart) {
      this.chart.data.datasets[0].label = userName;
      this.chart.data.labels = labels;
      this.chart.data.datasets[0].data = dataPoints;
      this.chart.update();
    }
  }
}
// Define ShowPopup hook for displaying popup upon successful user registration
hooks.ShowPopup = {
  mounted() {
    this.handleEvent("show-popup", () => {
      document.getElementById("success-popup").style.display = "block";
    });
  }
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  hooks: hooks, // Add our ChartJS hook
  params: { _csrf_token: csrfToken }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
