# D2C Management Reports

A multi-client Amazon / D2C account management dashboard built with Next.js, React and Supabase, designed for deployment on Vercel.

## Included

- Email/password authentication.
- Separate client workspaces under one login.
- Performance data entry by reporting period.
- Automatic KPI calculations: ACOS, ROAS, TACOS and order/session conversion.
- Sales trend chart and client overview.
- Weekly, monthly, daily and one-time task checklist.
- Due, overdue, weekly and monthly reminder views.
- Standard Amazon account-management checklist template.
- Client report preview, print / Save as PDF and CSV export.
- Supabase Row Level Security so each signed-in user can access only their own clients and data.

## 1. Create Supabase project

1. Go to https://supabase.com/dashboard and create a project.
2. Open **SQL Editor** in the Supabase dashboard.
3. Copy and run all SQL from `supabase/schema.sql`.
4. Open **Project Settings → API** (or API Keys) and copy the Project URL and anon / publishable key.
5. In **Authentication → URL Configuration**, add your local URL `http://localhost:3000` and your eventual Vercel production URL to the allowed redirect URLs / site URL as appropriate.

## 2. Run locally

Requires Node.js 20.9+ (a current LTS release is recommended).

```bash
npm install
cp .env.example .env.local
```

Edit `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY
```

Then:

```bash
npm run dev
```

Open http://localhost:3000, create your account, sign in and create your first client workspace.

## 3. Deploy to Vercel

1. Push this project to a private GitHub repository.
2. In https://vercel.com/new, import that repository.
3. Keep the framework preset as **Next.js**.
4. Add these Environment Variables in Vercel Project Settings → Environment Variables:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
5. Deploy.
6. Add your deployed `https://your-project.vercel.app` URL to Supabase Authentication URL Configuration.
7. Redeploy if you changed environment variables after the first deployment.

## How to use

1. Sign up / sign in.
2. Click the **+** beside Workspaces to create a client. Each client has its own performance entries and checklist.
3. Open a client and choose **Add data** to enter a weekly or monthly Seller Central reporting period.
4. Open **Checklist & reminders** and click **Add standard checklist** to create a starter weekly/monthly task set. Add custom tasks and due dates as needed.
5. Open **Client reports** to review the calculated summary, print / save as PDF, or download CSV data.
6. Switch clients from the left sidebar. Data is scoped to the selected client.

## KPI definitions

- ACOS = advertising spend / advertising-attributed sales × 100.
- ROAS = advertising-attributed sales / advertising spend.
- TACOS = advertising spend / total sales × 100.
- Conversion = orders / sessions × 100 in this app. Amazon Business Reports may expose unit session percentage, which is units / sessions; do not compare these two definitions as if they were identical.

## Important limitations / next improvements

- This is a manual reporting dashboard. It does **not** connect to Amazon Seller Central or sync sales automatically. Enter figures from Seller Central reports.
- Reminder items are in-app due-date views. No email, WhatsApp, browser push or scheduled notification is sent in this version.
- Profitability is not yet calculated because product cost, referral fees, FBA/ship costs, GST treatment, refunds and other costs need a separate product-cost model.
- Each login is a private workspace owner. If you later want your clients or team members to log in, add team membership / role tables and policies before sharing access.
- For client-facing financial reporting, reconcile the numbers with Seller Central settlement and advertising reports before distribution.

## Security notes

- Only use the Supabase anon / publishable key in the browser. Never expose a Supabase service-role key in `NEXT_PUBLIC_*` variables or client code.
- Keep the Supabase project private and enable strong passwords / MFA for the account owner.
- The included RLS policies restrict each user's rows to their own `owner_id`. Do not remove these policies in production.
