# Build prompt — inpani.pk marketing site

Paste everything below the line into whichever tool builds the site (Claude, v0, Lovable, or a
developer). It is written to be self-contained: it carries the real product facts, so nothing has
to be invented or guessed.

---

Build a marketing and download website for **Inpani**, a water-tanker delivery service in
Pakistan. The site lives at **inpani.pk**. Its single job is to explain the service and get people
to download the right Android app.

## Reference

Model the structure and tone on **indrive.com/en-pk** — a bold headline over a short promise, a
row of plain-language steps, separate paths for riders and drivers, and a download call to action
that follows you down the page. Do not copy their copy, colours, or layout verbatim; take the
shape, not the skin.

## Brand

- Name: **Inpani**. Two apps: **Inpani** (for customers) and **Inpani Driver** (for drivers).
- The site is **sky blue / aqua**, drawn from the logo. Palette:
  - `#00B4D8` primary aqua — buttons, links, active states
  - `#48CAE4` light aqua — hovers, highlights, illustration fills
  - `#CAF0F8` pale sky — section backgrounds, cards
  - `#0F4A57` deep teal — the dark sections, footer, and the logo tile ground
  - `#3E8E9C` mid teal — secondary illustration tone, taken straight from the mark
  - `#F1EFE8` cream — the droplet colour, good for text and shapes on deep teal
  - Ink `#0B2B33`, muted text `#5B7C85`, page white `#FFFFFF`
  Keep it airy: white and pale sky dominate, deep teal anchors the header/footer and the driver
  section, aqua is reserved for things you can click.
- Logo: **`logo.svg`, sitting next to this file — use it as-is, do not redesign it.** A deep-teal
  rounded-square tile holding a cream water droplet cradled by an open ring: a cream arc across
  the top and two mid-teal arcs sweeping down the sides, left open at the bottom. The droplet has
  a wave across its belly. Use the full tile as the favicon and app-store-style icon; on light
  backgrounds the mark may also be used without its tile.
- Tone: plain, direct, confident. Short sentences. No corporate filler, no exclamation marks.

## Hard constraint — no photography

**Do not use any photographs, stock images, or image placeholders.** Nothing sourced from an image
CDN, no `<img>` pointing at a photo, no grey "image goes here" boxes. Everything visual must be
drawn in CSS or inline SVG: the logo, the tanker illustration, step icons, phone frames, the map
motif. The site must look finished and deliberate with zero photos — not like a template waiting
for pictures. Real photography will be added later, so keep the layout able to accept it, but ship
without it.

## What Inpani actually is

Get this right; it is the whole differentiator.

Inpani is a **reverse-auction marketplace for water tankers**, not a fixed-price shop. The
customer names the price they want to pay, nearby drivers compete for the job, and the customer
picks the offer they like. There is no set tariff.

The flow, in the order it happens:

1. **Set your delivery point** — drop a pin on the map, exactly where the tanker should come.
2. **Choose a tanker size** — Small, Half or Full tanker. Tankers are ordered the way they are
   actually delivered, by size, not by a litre figure nobody quotes.
3. **Name your price** — the app suggests a fair rate; the customer can offer more or less.
4. **Drivers bid** — nearby drivers send competing offers, each showing their price, star rating,
   completed trips, and live distance from you. Offers arrive within minutes and expire after
   three minutes, so nothing on screen is stale.
5. **Pick a driver** — accept the offer you want. The price is locked at that moment.
6. **Watch it come** — live map tracking with a moving ETA, in-app chat and voice notes to the
   driver, and a notification when they arrive.
7. **Rate the driver** — ratings follow drivers and feed into future bids.

Coverage today: **Rawalpindi and Islamabad**.

## Driver side

A separate page or clearly separated section, on the deep teal `#0F4A57`, addressed to drivers:

- Go online when you want to work; orders near you appear automatically.
- You see the customer's asking price and the distance before you bid — you decide what the job
  is worth. Bid, or ignore it.
- One live bid at a time, so you are never double-booked.
- Earnings tracked per delivery, with daily and lifetime totals in the app.
- Requirements to sign up: a tanker, a phone number, and a completed driver profile.

Register and Earn is the driver call to action.

## Sections, in order

1. **Header** — logo, links (How it works, For drivers, Download, Contact), and a Download button.
2. **Hero** — headline on the "you set the price" idea, one supporting line, two buttons:
   Download the app / I'm a driver. A drawn tanker or map motif beside it, in SVG.
3. **How it works** — the six steps above as a numbered row or stepped layout, each with a drawn
   icon and one sentence. Keep the copy under twelve words per step.
4. **Tanker sizes** — three cards: Small, Half, Full. Name large, approximate volume small and
   muted underneath. State plainly that you order by size, not by litres.
5. **Why Inpani** — four short points: you name your price, drivers compete, live tracking with
   real ETA, rated drivers.
6. **For drivers** — the deep-teal section described above.
7. **Download** — two cards side by side, Inpani and Inpani Driver, each with a direct APK
   download button and the file size. Note that these are direct downloads, not Play Store links
   yet, and add one short line telling Android users they may need to allow installs from unknown
   sources. Do not fabricate Play Store or App Store badges.
8. **FAQ** — six questions, accordion: How do I pay? What areas do you cover? How long does
   delivery take? How is the price decided? Is the water safe to drink? How do I become a driver?
   Write honest, short answers from the facts on this page; if an answer is not knowable from
   here (like payment method), phrase the question so it can be answered later, or leave a clearly
   marked TODO rather than inventing a policy.
9. **Footer** — logo, contact email, city coverage, copyright, and links.

## Technical

- Single static `index.html` with inline CSS and minimal vanilla JS. No build step, no framework,
  no external dependencies except a Google Font if wanted. It has to drop onto any host.
- Fully responsive; mobile is the primary case, since most visitors will arrive on a phone and
  tap the APK link directly.
- Semantic HTML, real heading order, `alt` text on every SVG, keyboard-usable accordion, visible
  focus states, colour contrast at AA.
- Set the page title, meta description, Open Graph and Twitter tags, favicon, and `lang="en"`.
- Fast: no blocking resources, system font stack fallback, under 100 KB excluding the APKs.
- APK links should point at `/downloads/Inpani-Customer.apk` and `/downloads/Inpani-Driver.apk`
  as relative paths, so the files can be dropped in beside the page.

## Do not invent

Leave a clearly marked placeholder rather than making these up: payment methods, prices or
tariffs, delivery time guarantees, water quality certifications, company registration details,
customer numbers, testimonials, or team names.

---

## Notes for Bilal (not part of the prompt)

- **Domain**: inpani.pk, registered via PKNIC on 1 Sep 2026, expires 1 Sep 2028. Registrant is
  NUTECH University, technical contact AB Ventures (PVT) Limited. You will need DNS pointed at
  whatever host you choose — PKNIC manages the nameservers from the domain page you were on.
- **Support email**: both apps currently open mail to `support@aquadrop.pk` and
  `drivers@aquadrop.pk`, left over from an earlier brand. Once inpani.pk mail exists these should
  become `support@inpani.pk` and `drivers@inpani.pk`, in the apps and on the site. Say the word
  and I will change them in the apps.
- **APKs to publish**: the current release build lives in `Desktop\Inpani`. Copy those two files
  into the site's `downloads/` folder at deploy time, and re-copy on every new build.
- **Hosting**: the site is static, so GitHub Pages, Cloudflare Pages or Netlify will all serve it
  free — but check whether serving a ~50 MB APK is within the host's terms before relying on it.
