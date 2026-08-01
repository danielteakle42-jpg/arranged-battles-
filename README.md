# Platinum Pulse x Void — Arranged Battle Booking

Everything in this folder is the whole app. No build step, no npm install —
it's one HTML file that talks to a Supabase database.

## What's in here
- `index.html` — the whole app (open this in a browser to run it)
- `schema.sql` — the database setup, run once in Supabase
- `config.example.js` — template for your settings (safe to commit to git)
- `config.js` — your real settings go here (git-ignored, never committed)
- `.gitignore` — makes sure `config.js` stays off GitHub
- `build-config.js`, `package.json`, `vercel.json` — only used if you
  deploy via GitHub + Vercel (see below); ignore these for local use
- `README.md` — this file

## Setup (10 minutes)

### 1. Create a Supabase project
Go to [supabase.com](https://supabase.com), sign up/log in, and click
**New project**. Pick any name and password (you won't need the password
for this). Wait ~2 minutes for it to spin up.

### 2. Run the database setup
In your new project, go to **SQL Editor** (left sidebar) → **New query**.
Open `schema.sql` from this folder, copy all of it, paste it in, and click
**Run**. That creates the table and permissions the app needs.

### 3. Get your API keys
Go to **Project Settings** (gear icon) → **API**. You need two things:
- **Project URL** (looks like `https://xxxxx.supabase.co`)
- **anon public** key (a long string under "Project API keys")

### 4. Set up your config file
This app uses a `config.js` file to hold your Supabase keys and admin
username, kept separate from the app code and listed in `.gitignore` so
it never gets pushed to GitHub by accident.

1. Copy `config.example.js` and rename the copy to `config.js`
   (it's already there for you in this download — just edit it)
2. Open `config.js` in VS Code and fill in your real values:

```javascript
window.APP_CONFIG = {
  SUPABASE_URL: "https://xxxxx.supabase.co",
  SUPABASE_ANON_KEY: "your-real-anon-key-here",
  ADMIN_USERNAME: "ppn777"
};
```

Save it. `index.html` itself never needs editing.

### 5. Test it locally
In VS Code, install the **Live Server** extension (Extensions icon →
search "Live Server" → Install). Right-click `index.html` → **Open with
Live Server**. It'll open in your browser — log in as a creator or as
admin (`ppn777`) and try booking something. If it saves and shows up
after a refresh, Supabase is wired up correctly.

## Making it global (one link, works for everyone) — GitHub + Vercel

### 1. Push to GitHub
```
cd this-folder
git init
git add .
git commit -m "initial commit"
```
Create a new repo on GitHub, then follow its "push an existing repo"
instructions. Check `git status` before your first commit —
`config.js` should **not** be in the list of files being added. If it
is, double check `.gitignore` is in the same folder.

### 2. Import into Vercel
- Go to [vercel.com](https://vercel.com), sign up/log in with GitHub
- **Add New** → **Project** → pick your repo → **Import**
- Don't click Deploy yet — first add your environment variables (next step)

### 3. Add your Supabase settings as environment variables
Still on that import screen (or afterwards in **Project Settings** →
**Environment Variables**), add these three:

| Name | Value |
|---|---|
| `SUPABASE_URL` | your Project URL from Supabase |
| `SUPABASE_ANON_KEY` | your anon public key from Supabase |
| `ADMIN_USERNAME` | `ppn777` (or whatever you want it to be) |

### 4. Deploy
Click **Deploy**. Vercel runs `build-config.js` automatically (that's
what `package.json` and `vercel.json` in this folder are for) — it
writes those environment variables into a `config.js` at deploy time,
so the live site is fully wired to Supabase without your real keys ever
sitting in the GitHub repo.

You'll get a link like `battle-booker.vercel.app` — that's the one to
share with your creators and admin.

**If you ever change your Supabase keys or admin username**, update
them in Vercel's Environment Variables and hit **Redeploy** — no code
changes needed.

### Simpler alternative: Netlify drag-and-drop
If you'd rather skip GitHub entirely, Netlify lets you drag the whole
folder (including your local `config.js`) straight onto their dashboard
at [netlify.com](https://netlify.com) and it just works immediately —
no environment variables needed, since it uploads your files as-is
rather than pulling from git.

## Notes
- The admin login is the username `ppn777` by default — anyone else
  logs in with their exact TikTok username.
- **Being honest about "protected":** this is a static site with no
  server, so `config.js` keeps your keys out of your public GitHub repo
  — but it does *not* make them secret from someone using the live site.
  Anyone can open dev tools on the deployed app and read `config.js` and
  the admin username straight out of it, same as before. That's normal
  for a small internal tool, but if you want the admin login to be a
  real password check that can't be bypassed by reading the page source,
  that needs Supabase Auth (real login + database rules that check who's
  logged in) rather than a username match in JavaScript — happy to build
  that out with you if you want it later.
- The **anon key** itself is meant to be public-ish by design — it's the
  Row Level Security rules in `schema.sql` that actually control access,
  not the key.
