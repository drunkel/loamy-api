document.addEventListener('DOMContentLoaded', function() {
  const form = document.getElementById('waitlistForm');
  const flashContainer = document.getElementById('flash-container');

  form.addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(form);
    
    fetch(form.action, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('input[name="authenticity_token"]').value,
        'Accept': 'application/json',
      },
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      // Display the flash message
      flashContainer.innerHTML = `
        <div class="${data.status === 'success' ? 'bg-green-500' : 'bg-red-500'} text-white px-4 py-2 rounded">
          ${data.message}
        </div>
      `;
      flashContainer.classList.remove('hidden');

      // Hide the flash message after 5 seconds
      setTimeout(() => {
        flashContainer.classList.add('hidden');
      }, 5000);

      if (data.status === 'success') {
        form.reset();
      }
    })
    .catch(error => {
      console.error('Error:', error);
      flashContainer.innerHTML = `
        <div class="bg-red-500 text-white px-4 py-2 rounded">
          An error occurred. Please try again.
        </div>
      `;
      flashContainer.classList.remove('hidden');
    });
  });
});