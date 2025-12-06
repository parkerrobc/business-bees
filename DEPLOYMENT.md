# Business Bees - Subscription Site Deployment Guide

## 🚀 Quick Deployment (Under 1 Hour)

This guide will help you deploy your Business Bees subscription site for **FREE** using Google Sheets to collect emails and either Netlify, Vercel, or GitHub Pages for hosting.

---

## Part 1: Set Up Google Sheets for Email Collection (15 minutes)

### Step 1: Create a Google Sheet

1. Go to [Google Sheets](https://sheets.google.com)
2. Click **"+ Blank"** to create a new spreadsheet
3. Name it **"Business Bees Subscribers"**
4. In cell **A1**, type: `Email`
5. In cell **B1**, type: `Timestamp`
6. In cell **C1**, type: `Status` (optional - for tracking)

### Step 2: Create Google Apps Script

1. In your Google Sheet, click **Extensions** → **Apps Script**
2. Delete any existing code
3. Copy and paste this code:

```javascript
function doPost(e) {
  try {
    // Get the active spreadsheet
    var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
    
    // Parse the incoming data
    var data = JSON.parse(e.postData.contents);
    
    // Check if email already exists
    var existingData = sheet.getDataRange().getValues();
    for (var i = 1; i < existingData.length; i++) {
      if (existingData[i][0] === data.email) {
        return ContentService.createTextOutput(JSON.stringify({
          'result': 'error',
          'message': 'Email already subscribed'
        })).setMimeType(ContentService.MimeType.JSON);
      }
    }
    
    // Add new subscriber
    sheet.appendRow([
      data.email,
      new Date(),
      'Active'
    ]);
    
    return ContentService.createTextOutput(JSON.stringify({
      'result': 'success',
      'message': 'Successfully subscribed'
    })).setMimeType(ContentService.MimeType.JSON);
    
  } catch (error) {
    return ContentService.createTextOutput(JSON.stringify({
      'result': 'error',
      'message': error.toString()
    })).setMimeType(ContentService.MimeType.JSON);
  }
}

function doGet(e) {
  return ContentService.createTextOutput('Business Bees Subscription API is running!');
}
```

4. Click **"Save project"** (💾 icon) and name it **"Business Bees API"**

### Step 3: Deploy the Apps Script

1. Click **"Deploy"** → **"New deployment"**
2. Click the gear icon ⚙️ next to "Select type"
3. Choose **"Web app"**
4. Fill in the details:
   - **Description**: "Business Bees Subscription API"
   - **Execute as**: "Me"
   - **Who has access**: "Anyone"
5. Click **"Deploy"**
6. Click **"Authorize access"**
7. Choose your Google account
8. Click **"Advanced"** → **"Go to Business Bees API (unsafe)"**
9. Click **"Allow"**
10. **COPY THE WEB APP URL** - it will look like:
    ```
    https://script.google.com/macros/s/XXXXX.../exec
    ```
11. Save this URL - you'll need it in the next step!

---

## Part 2: Update Your Website Code (5 minutes)

1. Open the file `script.js` in your project
2. Find this line near the top:
   ```javascript
   const SCRIPT_URL = 'YOUR_GOOGLE_APPS_SCRIPT_URL_HERE';
   ```
3. Replace `'YOUR_GOOGLE_APPS_SCRIPT_URL_HERE'` with your Web App URL (in quotes)
4. Save the file

---

## Part 3: Deploy to Free Hosting (Choose One Method)

### Option A: Deploy to Netlify (Recommended - Easiest)

#### Step 1: Prepare Your Site
1. Open Terminal/Command Prompt
2. Navigate to your project:
   ```bash
   cd /Users/bahbpawkah/Documents/bpwd/business-bees/git/business-bees
   ```

#### Step 2: Deploy to Netlify
1. Go to [Netlify](https://www.netlify.com)
2. Click **"Sign up"** (or log in)
3. Choose **"Deploy manually"** or drag and drop your folder
4. **OR** use Netlify CLI:
   ```bash
   # Install Netlify CLI (one time only)
   npm install -g netlify-cli
   
   # Login to Netlify
   netlify login
   
   # Deploy your site
   netlify deploy
   
   # Follow the prompts:
   # - Create & configure a new site
   # - Choose your team
   # - Site name: business-bees (or your preferred name)
   # - Deploy path: . (current directory)
   
   # When ready, deploy to production
   netlify deploy --prod
   ```

5. Your site will be live at: `https://business-bees.netlify.app` (or your chosen name)

**Netlify Features:**
- ✅ Free SSL certificate
- ✅ Automatic HTTPS
- ✅ Custom domain support
- ✅ Continuous deployment from Git

---

### Option B: Deploy to Vercel

#### Step 1: Install Vercel CLI
```bash
npm install -g vercel
```

#### Step 2: Deploy
```bash
cd /Users/bahbpawkah/Documents/bpwd/business-bees/git/business-bees
vercel

# Follow the prompts:
# - Login to Vercel
# - Set up project
# - Deploy
```

Your site will be live at: `https://business-bees.vercel.app`

---

### Option C: Deploy to GitHub Pages

#### Step 1: Push to GitHub
```bash
cd /Users/bahbpawkah/Documents/bpwd/business-bees/git/business-bees

# Initialize git (if not already done)
git init
git add .
git commit -m "Initial commit: Business Bees subscription site"

# Create a new repository on GitHub (github.com)
# Then push your code:
git remote add origin https://github.com/YOUR_USERNAME/business-bees.git
git branch -M main
git push -u origin main
```

#### Step 2: Enable GitHub Pages
1. Go to your repository on GitHub
2. Click **Settings** → **Pages**
3. Under "Source", select **"main"** branch
4. Click **Save**
5. Your site will be live at: `https://YOUR_USERNAME.github.io/business-bees/`

---

## Part 4: Test Your Site (5 minutes)

1. Visit your deployed site URL
2. Enter a test email address
3. Click "Subscribe"
4. Check your Google Sheet - you should see the email appear!
5. Try subscribing with the same email again - it should reject duplicates

---

## 🎨 Customization Options

### Add Your Own Bee Images
If you want to use the specific bee SVGs from your assets folder:

1. Copy the desired SVG files from `/Users/bahbpawkah/Documents/bpwd/business-bees/assets/BEE SVGs/` to your project's `assets` folder
2. Update `index.html` to reference the new files:
   ```html
   <img src="assets/BEE 1.svg" alt="Bee">
   ```

### Change Colors
Edit `style.css` and modify the CSS variables:
```css
:root {
    --bg-tan: #fefad3;
    --yellow: #fdc821;
    --orange: #f89421;
    /* etc... */
}
```

---

## 📊 Viewing Your Subscribers

1. Open your Google Sheet
2. All subscribers will appear with:
   - Email address
   - Timestamp
   - Status

### Export Subscribers
1. In Google Sheets, click **File** → **Download** → **CSV**
2. You can now import this into any email marketing service (MailChimp, SendGrid, etc.)

---

## 🔒 Security Best Practices

1. **Google Sheet Permissions**: Only you can see the subscriber data
2. **Apps Script**: The script only accepts POST requests with email data
3. **No API Keys Needed**: Everything is handled through Google's authentication

---

## 🆘 Troubleshooting

### Problem: Form submission doesn't work
- Check that you've replaced `YOUR_GOOGLE_APPS_SCRIPT_URL_HERE` in `script.js`
- Verify the Apps Script is deployed as "Anyone" can access
- Check browser console (F12) for errors

### Problem: Emails aren't appearing in Google Sheets
- Make sure the Apps Script is deployed
- Check that the Web App URL is correct
- Verify the spreadsheet has the correct headers (Email, Timestamp, Status)

### Problem: "Application has not been verified" warning
- This is normal for personal scripts
- Click "Advanced" → "Go to [project name] (unsafe)"
- This only appears during initial setup

---

## 📈 Next Steps

### Connect to Email Marketing Service
1. **MailChimp**: Export CSV and import to MailChimp
2. **SendGrid**: Use SendGrid API to automatically sync
3. **Custom**: Modify the Apps Script to send to your preferred service

### Add More Fields
Want to collect more information? Modify:
1. `index.html` - Add input fields
2. `script.js` - Include new fields in POST data
3. Google Apps Script - Handle new fields
4. Google Sheet - Add new columns

### Analytics
Add Google Analytics to track:
- Page visits
- Subscription rate
- Traffic sources

Add this before `</head>` in `index.html`:
```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=YOUR_GA_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'YOUR_GA_ID');
</script>
```

---

## ⏱️ Total Time Estimate

- ✅ Google Sheets Setup: **15 minutes**
- ✅ Update Code: **5 minutes**
- ✅ Deploy to Hosting: **10 minutes**
- ✅ Testing: **5 minutes**

**Total: ~35 minutes** (well under 1 hour!)

---

## 🎉 Congratulations!

Your Business Bees subscription site is now live! Share your URL and start collecting subscribers for your mailing list.

**Need help?** Check the troubleshooting section above or review the comments in the code files.
