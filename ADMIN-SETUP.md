# Inpani Admin — setup

The dashboard is `website/admin.html`. It deploys with the rest of the site, so once the site is
published it lives at **https://inpani.pk/admin.html**.

## Who can get in

Exactly two accounts:

- **bilalaarian000@gmail.com**
- **manich.ch@gmail.com**

Any other Google account is refused — it sees "This account cannot open Inpani Admin" and nothing
else. There is no sign-up, no request access, no admin list to maintain.

This is enforced **in the database rules**, not just on the page. Even if someone downloaded
`admin.html`, changed the two addresses and ran it themselves, Firebase would still refuse every
read. The page check only exists so a wrong account gets a clear message instead of a blank screen
full of permission errors.

To change who is an admin, edit the addresses in **both** `database.rules.json` (4 places) and
`website/admin.html` (`ADMIN_EMAILS`), then redeploy the rules.

---

## Two setup steps

### 1. Deploy the database rules

```bash
firebase deploy --only database
```

Adds: the two-email admin check, admin read on support tickets, admin read on the `roles`
registry, and admin write on `blocked`. Nothing existing was loosened.

### 2. Allow the website to sign people in

Firebase console → **Authentication → Settings → Authorized domains → Add domain** → `inpani.pk`

Without this the sign-in button reports "This website address is not yet allowed in Firebase".

That is all. Then open https://inpani.pk/admin.html and sign in.

---

## What it shows

- **Overview** — customers, drivers, drivers online, orders, delivered, completion rate,
  total value delivered, average order value; orders per day for 30 days; status breakdown.
- **Orders** — every order, searchable, filterable, with both phone numbers.
- **Customers / Drivers** — name, phone, **email**, address, order counts, join date,
  and a **Block / Unblock** button.
- **Support** — tickets from the customer app.
- **CSV downloads** on every tab, plus a Summary export for investors.

## Previous users are included

The tables read every record in `customerProfiles` and `driverProfiles`, so everyone who ever
registered is already listed — nothing is limited to new sign-ups.

People who signed in but never finished a profile used to be invisible. The dashboard now also
reads the `roles` registry, which both apps write the first time a user opens them, and shows
those users as **"(signed in, no profile yet)"** with the date they first appeared. They can be
blocked like anyone else. The count line says how many there are.

## Email addresses — read this

Email is **not** stored historically. Firebase Authentication holds it, and no client may read
another user's Auth record, so each app now writes its own email onto its profile at startup
(`recordSignInEmail()` in both MainActivity files, shipped in **v1.7**).

What that means in practice:

- An existing user's email appears **the first time they open v1.7 or later**. It backfills by
  itself as people update — you do not have to do anything.
- Users who signed in with a **phone number** have no email at all. Firebase never had one for
  them, so the column stays blank. That is not a bug.
- `authProvider` is stored alongside it (`google` or `phone`) so you can tell the two apart.

The only way to get every email immediately, including phone-only users who never return, would be
a Cloud Function using the Admin SDK — and Cloud Functions need the paid Blaze plan.

## What blocking does

Writes `blocked/{uid}`. Both apps already check this: a blocked user stays signed in but cannot
place orders, bid, or send chat messages. Unblock removes the entry.

## Not shown on purpose

CNIC numbers. They were deliberately moved out of world-readable storage into owner-only nodes.
The admin rules do not grant access. That can be changed if you need it for driver verification,
but it should be a deliberate decision.
