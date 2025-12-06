# Business Bees - Quick Start Guide 🚀

## Complete Setup in Under 1 Hour!

Follow these steps in order to get your subscription site live:

---

## ⏱️ Step 1: Google Sheets Setup (15 minutes)

### Create Your Spreadsheet
1. Go to https://sheets.google.com
2. Click **"+ Blank"** spreadsheet
3. Name it: **"Business Bees Subscribers"**
4. Add headers in Row 1:
   - A1: `Email`
   - B1: `Timestamp`
   - C1: `Status`

### Set Up Apps Script
1. In your sheet: **Extensions** → **Apps Script**
2. Delete existing code
3. Copy code from `DEPLOYMENT.md` (Part 1, Step 2)
4. Save as **"Business Bees API"**

### Deploy the Script
1. Click **"Deploy"** → **"New deployment"**
2. Select **"Web app"**
3. Settings:
   - Execute as: **Me**
   - Who has access: **Anyone**
4. **Deploy** → **Authorize** → **Allow**
5. **COPY THE WEB APP URL** (looks like: `https://script.google.com/macros/s/.../exec`)

---

## ⏱️ Step 2: Update Your Code (5 minutes)

1. Open `script.js` in this folder
2. Find line 2: `const SCRIPT_URL = 'YOUR_GOOGLE_APPS_SCRIPT_URL_HERE';`
3. Replace with your URL: `const SCRIPT_URL = 'https://script.google.com/macros/s/.../exec';`
4. Save the file

---

## ⏱️ Step 3: Deploy Your Site (10 minutes)

### Easiest: Netlify Drop

1. Go to https://app.netlify.com/drop
2. Drag this entire folder onto the page
3. Done! Your site is live!

### Alternative: Netlify CLI

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Navigate to this folder
cd /Users/bahbpawkah/Documents/bpwd/business-bees/git/business-bees

# Login and deploy
netlify login
netlify deploy --prod
```

### Alternative: Vercel

```bash
# Install Vercel CLI
npm install -g vercel

# Navigate to this folder
cd /Users/bahbpawkah/Documents/bpwd/business-bees/git/business-bees

# Deploy
vercel
```

### Alternative: GitHub Pages

```bash
# Initialize git (if needed)
git init
git add .
git commit -m "Initial commit"

# Create repo on GitHub, then:
git remote add origin https://github.com/YOUR_USERNAME/business-bees.git
git push -u origin main

# Enable Pages in GitHub Settings → Pages → Source: main branch
```

---

## ⏱️ Step 4: Test Your Site (5 minutes)

1. Visit your deployed URL
2. Enter a test email
3. Click "Subscribe"
4. Check your Google Sheet for the new entry
5. Test duplicate prevention by submitting the same email again

---

## ✅ Checklist

- [ ] Created Google Sheet with correct headers
- [ ] Set up and deployed Apps Script
- [ ] Copied Web App URL
- [ ] Updated `script.js` with the URL
- [ ] Deployed site to hosting platform
- [ ] Tested subscription form
- [ ] Verified email appears in Google Sheet
- [ ] Tested duplicate email prevention

---

## 🎉 You're Done!

**Your site is now live and collecting subscribers!**

### Your Site URL:
- **Netlify**: `https://[your-site-name].netlify.app`
- **Vercel**: `https://[your-site-name].vercel.app`
- **GitHub Pages**: `https://[your-username].github.io/business-bees`

### Next Steps:
1. Share your subscription URL
2. Add a custom domain (optional)
3. Set up email marketing campaigns
4. Export subscribers from Google Sheets to your email service

---

## 🆘 Need Help?

See the full troubleshooting guide in `DEPLOYMENT.md`

Common issues:
- **Form not working**: Check script URL is correct
- **403 Error**: Re-deploy Apps Script with "Anyone" access
- **Duplicate not detected**: Check script code copied correctly

---

## 📊 Accessing Your Subscribers

Your Google Sheet: https://sheets.google.com
- View in real-time
- Export to CSV
- Import to MailChimp, SendGrid, etc.

---

**Questions?** Review the `DEPLOYMENT.md` file for detailed instructions.
