// const data = [
//   { year: '2015', nests: 13 },
//   { year: '2016', nests: 39 },
//   { year: '2017', nests: 53 },
//   { year: '2018', nests: 436 },
//   { year: '2019', nests: 1119 },
//   { year: '2020', nests: 519 },
//   { year: '2021', nests: 2196 },
//   { year: '2022', nests: 900 },
//   { year: '2023', nests: 1477 },
//   { year: '2024', nests: 2561 }
// ];

// const svg = d3.select("#chart");
// const width = +svg.attr("width");
// const height = +svg.attr("height");
// const margin = { top: 20, right: 20, bottom: 30, left: 40 };
// const innerWidth = width - margin.left - margin.right;
// const innerHeight = height - margin.top - margin.bottom;

// const x = d3.scaleBand()
//   .domain(data.map(d => d.year))
//   .range([0, innerWidth])
//   .padding(0.1);

// const y = d3.scaleLinear()
//   .domain([0, d3.max(data, d => d.nests)])
//   .nice()
//   .range([innerHeight, 0]);

// const g = svg.append("g")
//   .attr("transform", `translate(${margin.left},${margin.top})`);

// g.append("g")
//   .call(d3.axisLeft(y));

// g.append("g")
//   .attr("transform", `translate(0,${innerHeight})`)
//   .call(d3.axisBottom(x));

// g.selectAll("rect")
//   .data(data)
//   .enter().append("rect")
//     .attr("x", d => x(d.year))
//     .attr("y", d => y(d.nests))
//     .attr("width", x.bandwidth())
//     .attr("height", d => innerHeight - y(d.nests))
//     .attr("fill", (d, i) => i === data.length - 6 ? "#F54E8B" : "#B5B5B5");

document.addEventListener("DOMContentLoaded", () => {
  fetch(`media/checklists.json?cb=${new Date().getTime()}`)
  .then(response => response.json())
  .then(data => {
    const container = document.getElementById("checklists-container");
    data.forEach(entry => {
      const div = document.createElement("div");
      div.className = "checklist-entry";

      const link = document.createElement("a");
      link.href = "https://" + entry.checklist;
      link.target = "_blank";
      link.rel = "noopener noreferrer";

      link.innerHTML = `
        <h2>${entry.locName}</h2>
        <div class="details">
          <span><strong>Plovers Seen:</strong> ${entry.howMany}</span>
          <span><strong>Date:</strong> ${entry.nice_date}</span>
          <span><strong>Time:</strong> ${entry.nice_time}</span>
        </div>
      `;

      div.appendChild(link);
      container.appendChild(div);
    });
  });
    // Following code is from snipzy.dev, really helpful resource
    // Add this JavaScript to make the accordion functional
    const accordionHeaders = document.querySelectorAll('.accordion-header');
    
    accordionHeaders.forEach(header => {
      header.addEventListener('click', function() {
        const item = this.parentElement;
        const isActive = item.classList.contains('active');
        
        // Close all items
        document.querySelectorAll('.accordion-item').forEach(accItem => {
          accItem.classList.remove('active');
        });
        
        // If the clicked item wasn't active, open it
        if (!isActive) {
          item.classList.add('active');
        }
      });
    });
});

const audio = document.getElementById('audio-player');
const button = document.getElementById('audio-toggle');
const icon = button.querySelector('i');

button.addEventListener('click', () => {
  if (audio.paused) {
    audio.play();
    icon.classList.remove('fa-play');
    icon.classList.add('fa-pause');
  } else {
    audio.pause();
    icon.classList.remove('fa-pause');
    icon.classList.add('fa-play');
  }
});

audio.addEventListener('ended', () => {
  icon.classList.remove('fa-pause');
  icon.classList.add('fa-play');
});