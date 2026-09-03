# Putting inpani.pk live

Everything is ready. What follows is the whole job, in order. Steps 1 and 3 need you to be signed
in to accounts, so they are yours to do — I cannot create accounts or enter credentials.

Current state, checked 2 Sep 2026: **inpani.pk does not resolve at all.** No nameservers are
published for it yet, which is normal for a fresh PKNIC registration. Nothing is broken.

---

## 1. Put the files on a host

Drag **`Desktop\inpani-website-deploy.zip`** (40.8 MB) onto <https://app.netlify.com/drop>.

You get a live URL like `random-name-123.netlify.app` within a minute. **Open it and test the two
APK downloads before going further** — if they work there, they will work on your domain.

Then create a free Netlify account so the site is kept rather than expiring.

> **Why not Cloudflare Pages:** it rejects any file over 25 MB, and each APK is ~49 MB. GitHub
> Pages does allow them (100 MB per file), but every build would add ~98 MB to that repo forever.
> Netlify keeps the APKs out of git entirely.

## 2. Claim the domain in Netlify

**Site configuration → Domain management → Add a domain** → `inpani.pk`.

Netlify will say the domain does not point at it yet and show you **four nameservers**, like:

```
dns1.p03.nsone.net
dns2.p03.nsone.net
dns3.p03.nsone.net
dns4.p03.nsone.net
```

Copy those exact values — yours will differ.

## 3. Point PKNIC at those nameservers

Sign in at <https://pk6.pknic.net.pk> and open the `inpani.pk` domain record — the page you were
already on. Under the DNS information, click **Edit**, replace the nameservers with Netlify's four,
and save.

PKNIC publishes changes to the `.pk` zone on its own schedule: usually a few hours, occasionally up
to 48. There is nothing to do but wait.

## 4. Check it

```bash
nslookup -type=NS inpani.pk 8.8.8.8
```

Once that returns the Netlify nameservers, the site is reachable at `https://inpani.pk`. Netlify
issues the HTTPS certificate automatically — no action needed, but it can take a few minutes after
DNS resolves.

---

## Publishing a new build later

The site serves whatever sits in `downloads/`. It does not update itself.

```bash
cp /c/Users/bilal/Desktop/Inpani/Inpani-Customer.apk downloads/Inpani-Customer.apk
cp /c/Users/bilal/Desktop/Inpani/Inpani-Driver.apk   downloads/Inpani-Driver.apk
```

Then drag the folder onto Netlify again (or connect the site to a git repo so it redeploys on
push). If the file sizes change, update the `48.9 MB` / `48.8 MB` figures in `index.html`.

## Still outstanding

- **Email does not exist yet.** The footer links `support@inpani.pk` and `drivers@inpani.pk`, and
  both apps still open mail to the old `@aquadrop.pk` addresses. PKNIC does not provide mailboxes —
  you need Google Workspace, Zoho Mail (has a free tier), or your host's mail service, then MX
  records added wherever your DNS ends up.
- **The registrant is NUTECH University**, with AB Ventures as technical contact. Whoever holds
  that record controls the domain. PKNIC locks registrant changes behind an email to
  `staff@pknic.net.pk` — worth sorting out early if this is your business.
- **`waterType` still defaults to `"Drinking"`** in the customer app, while the website states
  plainly that this is not drinking water.
