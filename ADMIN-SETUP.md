# Inpani Admin — setup

The dashboard is `website/admin.html`. It deploys with the rest of the site, so once the site
is published it lives at **https://inpani.pk/admin.html**.

It shows nothing at all until you sign in *and* your account is on the admin list, so it is safe
to have it sitting on the public site. It is also excluded from Google (`robots.txt` + `noindex`).

There are three one-time steps. All three are in consoles you have to be signed in to, so they
are yours to do.

---

## 1. Deploy the database rules

From the project root:

```bash
firebase deploy --only database
```

This adds an `admins` allowlist, lets admins block/unblock users, and lets admins read support
tickets. Nothing else changes.

**Admin rights cannot be granted from any app or web page** — the `admins` node has no write
rule at all, so it can only be edited in the Firebase console. That is deliberate.

## 2. Allow the website to sign people in

Firebase console → **Authentication → Settings → Authorized domains → Add domain** → `inpani.pk`

Without this you get "This website address is not yet allowed in Firebase" on the sign-in screen.

## 3. Add yourself and your partner

1. Open https://inpani.pk/admin.html and sign in with Google.
2. It will say the account is not on the admin list and show a long ID. Copy it.
3. Firebase console → **Realtime Database → Data**, add:

```
admins
  └── <the ID you copied>: true
```

Set the value to the boolean `true`, not the text "true".

4. Reload the page. Repeat for your partner with their own Google account.

---

## What it shows

- **Overview** — customers, drivers, drivers online, orders, delivered, completion rate,
  total value delivered, average order value; orders per day for the last 30 days; status breakdown.
- **Orders** — every order, searchable, filterable by status, with both phone numbers.
- **Customers / Drivers** — contact details, order counts, join date, and a **Block / Unblock** button.
- **Support** — tickets sent from the customer app.
- **CSV downloads** on every tab, plus a Summary export for investors.

## What blocking does

Writes `blocked/{uid}` in the database. Both apps already check this: a blocked user stays signed
in but cannot place orders, bid, or send chat messages. Unblock removes the entry.

## Known gap — email addresses

The apps never store an email address in the database; they store **name, phone and address**.
Emails live inside Firebase Authentication, which a web page cannot read directly. To show emails
you would need either a Cloud Function using the Admin SDK, or a small change to both apps to save
the email onto the profile at sign-in. Say the word and it can be added.

## Not shown on purpose

CNIC numbers. They were deliberately moved out of the world-readable profile into owner-only
storage. The admin rules do not grant access to them. They can be exposed to admins if you need it
for driver verification, but that is a decision worth making on purpose.
