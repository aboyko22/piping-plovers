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