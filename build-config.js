// build-config.js
// Runs during deploy (Vercel calls this via package.json's "build" script).
// Reads your Supabase settings from environment variables and writes them
// into config.js — the file the app actually loads in the browser.
//
// This only matters for GitHub + Vercel deploys. If you're just running
// the app locally or drag-and-dropping the folder into Netlify, you don't
// need this at all — your local config.js is used as-is.

const fs = require("fs");

const config = `window.APP_CONFIG = {
  SUPABASE_URL: "${process.env.SUPABASE_URL || ""}",
  SUPABASE_ANON_KEY: "${process.env.SUPABASE_ANON_KEY || ""}",
  ADMIN_USERNAME: "${process.env.ADMIN_USERNAME || "ppn777"}"
};
`;

fs.writeFileSync("config.js", config);
console.log("config.js generated from environment variables.");
