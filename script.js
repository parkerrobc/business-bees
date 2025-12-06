// Configuration - You'll need to replace this with your Google Apps Script Web App URL
const SCRIPT_URL = 'https://script.google.com/macros/s/AKfycbzfOKIH0nJrpCm5yM23QiKA9rTWJS9vvbe3Edy5237V2MhBlUvET2nT1_3otnq2fsCw/exec';

document.getElementById('subscribeForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const emailInput = document.getElementById('email');
    const messageDiv = document.getElementById('message');
    const submitButton = this.querySelector('button[type="submit"]');
    
    const email = emailInput.value.trim();
    
    // Basic email validation
    if (!email || !validateEmail(email)) {
        showMessage('Please enter a valid email address.', 'error');
        return;
    }
    
    // Disable button and show loading state
    submitButton.disabled = true;
    submitButton.textContent = 'Subscribing...';
    messageDiv.textContent = '';
    messageDiv.className = 'message';
    
    try {
        // Send to Google Sheets
        const response = await fetch(SCRIPT_URL, {
            method: 'POST',
            mode: 'no-cors', // Required for Google Apps Script
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                email: email,
                timestamp: new Date().toISOString()
            })
        });
        
        // With no-cors, we can't read the response, so we assume success
        showMessage('🎉 Successfully subscribed! Welcome to Business Bees!', 'success');
        emailInput.value = '';
        
    } catch (error) {
        console.error('Error:', error);
        showMessage('Oops! Something went wrong. Please try again.', 'error');
    } finally {
        // Re-enable button
        submitButton.disabled = false;
        submitButton.innerHTML = 'Subscribe <img src="assets/bee-icon.svg" alt="" class="button-icon">';
    }
});

function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

function showMessage(text, type) {
    const messageDiv = document.getElementById('message');
    messageDiv.textContent = text;
    messageDiv.className = `message ${type}`;
    
    // Auto-hide success messages after 5 seconds
    if (type === 'success') {
        setTimeout(() => {
            messageDiv.textContent = '';
            messageDiv.className = 'message';
        }, 5000);
    }
}

// Add Enter key support
document.getElementById('email').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        document.getElementById('subscribeForm').dispatchEvent(new Event('submit'));
    }
});
