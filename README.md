# Business Bees 🐝

A beautiful, responsive subscription landing page to collect email addresses for your Business Bees mailing list.

![Business Bees](assets/bee-logo.svg)

## Features

- ✨ Beautiful, responsive design with bee-themed animations
- 🎨 Custom color scheme matching your brand
- 📧 Email collection using Google Sheets (free!)
- 🚀 Easy deployment to free hosting (Netlify, Vercel, or GitHub Pages)
- 📱 Mobile-friendly and accessible
- 🔒 Duplicate email prevention
- ⚡ Fast and lightweight (no heavy frameworks)

## Quick Start

1. **Set up Google Sheets for email collection** (15 minutes)
2. **Update the script.js with your Google Apps Script URL** (5 minutes)
3. **Deploy to free hosting** (10 minutes)

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed step-by-step instructions.

## Color Scheme

- **Background Tan**: `#fefad3`
- **Black**: `#231f20`
- **Yellow**: `#fdc821`
- **Orange**: `#f89421`
- **Blue**: `#265283`
- **Silver**: `#939598`
- **Red**: `#ee2e2d`
- **Brown**: `#442e2a`

## Tech Stack

- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Backend**: Google Apps Script (serverless)
- **Database**: Google Sheets (free tier)
- **Hosting**: Netlify / Vercel / GitHub Pages (free)

## File Structure

```
business-bees/
├── index.html          # Main landing page
├── style.css           # Styling and animations
├── script.js           # Form handling and API integration
├── assets/
│   ├── bee.svg         # Bee decoration
│   └── bee-logo.svg    # Main logo
├── DEPLOYMENT.md       # Detailed deployment guide
└── README.md          # This file
```

## Deployment Options

### Option 1: Netlify (Recommended)
- Drag and drop deployment
- Automatic HTTPS
- Free custom domain support
- [Deploy Now](https://www.netlify.com)

### Option 2: Vercel
- Git integration
- Automatic deployments
- Edge network
- [Deploy Now](https://vercel.com)

### Option 3: GitHub Pages
- Free hosting from GitHub
- Custom domain support
- Integrated with Git workflow
- [Learn More](https://pages.github.com)

## Local Development

1. Clone this repository
2. Open `index.html` in your browser
3. For the form to work, you'll need to set up Google Sheets first (see DEPLOYMENT.md)

## Customization

### Change Text Content
Edit `index.html` to update:
- Title
- Description
- Button text

### Modify Colors
Edit `style.css` CSS variables:
```css
:root {
    --bg-tan: #fefad3;
    --yellow: #fdc821;
    /* ... */
}
```

### Add Your Own Bee Images
Replace files in the `assets/` folder with your own SVG files from `/assets/BEE SVGs/`

## License

This project is open source and available for personal and commercial use.

## Support

For questions or issues, please refer to the [DEPLOYMENT.md](DEPLOYMENT.md) troubleshooting section.

---

**Built with 💛 for Business Bees**
