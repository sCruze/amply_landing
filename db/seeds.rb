Page.destroy_all

page_home = Page.create!(
  name: "Home",
  h1:   "Bring order to your day without the noise.",
  slug: "home"
)
page_home.create_meta_tag!(
  title:       "Amply — Bring Order to Your Day Without the Noise",
  description: "Amply helps you organize your thoughts, tasks, and reminders — all in one simple place. A personal task tracker and calendar designed to boost productivity and keep life in order.",
  keywords:    "Amply, task tracker, productivity app, personal calendar, to-do list, task manager, planner app, daily organizer, reminders app, notes app, focus app, time management, productivity tool, work planner, study planner"
)

page_privacy = Page.create!(
  name: "Privacy Policy",
  h1:   "Privacy Policy",
  slug: "privacy",
  description: <<~HTML
    <section class="legal">
      <h1 class="legal__title">Privacy Policy</h1>
      <p class="legal__updated"><strong>Last updated:</strong> October 2025</p>

      <h2 class="legal__h2">1. Introduction</h2>
      <p>
        Welcome to Amply (“we”, “our”, or “us”), operated by Fortis d.o.o., a company registered in Montenegro.
        This Privacy Policy explains how we collect, use, and protect your personal information when you visit our website
        <a href="https://amply-space.com" rel="noopener" target="_blank">amply-space.com</a>.
      </p>
      <p>By using our website, you agree to the terms described in this Privacy Policy.</p>

      <h2 class="legal__h2">2. Information We Collect</h2>
      <p>We collect only the information necessary to operate our services and communicate with you:</p>
      <ul class="legal__list">
        <li>Name – if provided when joining our waitlist or contacting us.</li>
        <li>Email address – to notify you about Amply updates, news, or early access.</li>
        <li>Professional activity or role – if you choose to provide it through our form.</li>
        <li>Cookies – not used.</li>
        <li>
          Analytics data – collected automatically via Google Analytics (e.g., device type, location by country,
          browser version, time spent on pages). This data is aggregated and anonymous.
        </li>
      </ul>

      <h2 class="legal__h2">3. How We Use the Information</h2>
      <p>We use the collected information to:</p>
      <ul class="legal__list">
        <li>Manage the waitlist and contact you with updates about Amply’s launch.</li>
        <li>Improve our website and understand user interest in our product.</li>
        <li>Respond to inquiries and provide support.</li>
      </ul>
      <p>We do not sell, rent, or trade your personal data.</p>

      <h2 class="legal__h2">4. Data Storage and Retention</h2>
      <p>Your data is securely stored and accessible only to authorized personnel of Fortis d.o.o.</p>
      <p>We keep your information for as long as necessary to provide communications and updates. You can request deletion anytime.</p>

      <h2 class="legal__h2">5. Data Sharing</h2>
      <p>We only share data with trusted third parties necessary for operating our website, such as:</p>
      <ul class="legal__list">
        <li>Google Analytics (data aggregated for site performance insights).</li>
        <li>No other data is shared with third parties.</li>
      </ul>

      <h2 class="legal__h2">6. Your Rights</h2>
      <p>You have the right to:</p>
      <ul class="legal__list">
        <li>Access and review your personal data.</li>
        <li>Request correction or deletion.</li>
        <li>Withdraw your consent for future communication.</li>
      </ul>
      <p>To exercise these rights, contact us at <a href="mailto:support@amply-space.com">support@amply-space.com</a>.</p>

      <h2 class="legal__h2">7. International Data Transfer</h2>
      <p>Your information may be stored or processed outside your country. We ensure that such transfers comply with applicable data protection laws (GDPR, CCPA).</p>

      <h2 class="legal__h2">8. Updates to This Policy</h2>
      <p>We may update this Privacy Policy periodically. The latest version will always be available on this page.</p>

      <h2 class="legal__h2">9. Contact</h2>
      <p>If you have any questions or concerns about this Privacy Policy, please contact:</p>
      <p><a href="mailto:support@amply-space.com">support@amply-space.com</a><br>Fortis d.o.o., Podgorica, Montenegro</p>
    </section>
  HTML
)
page_privacy.create_meta_tag!(
  title:       "Privacy Policy — Amply",
  description: "How Amply collects, uses and protects your personal information.",
  keywords:    "Privacy Policy, data protection, GDPR, CCPA, Amply"
)

page_terms = Page.create!(
  name: "Terms of Service",
  h1:   "Terms of Service",
  slug: "terms",
  description: <<~HTML
    <section class="legal">
      <h1 class="legal__title">Terms of Service</h1>
      <p class="legal__updated"><strong>Last updated:</strong> October 2025</p>

      <h2 class="legal__h2">1. Acceptance of Terms</h2>
      <p>
        By accessing or using <strong>amply-space.com</strong> (“Site”), you agree to these Terms of Service (“Terms”).
        If you do not agree, please do not use the Site.
      </p>

      <h2 class="legal__h2">2. About Amply</h2>
      <p>
        Amply is a mobile productivity app under development by Fortis d.o.o., designed to help users organize tasks, events, and reminders.
        The Site serves as an informational and promotional platform for Amply, including an early-access waitlist.
      </p>

      <h2 class="legal__h2">3. Use of the Website</h2>
      <p>
        You agree to use this Site only for lawful purposes and in a way that does not violate the rights of others or restrict their use of the Site.
      </p>
      <p>You may not:</p>
      <ul class="legal__list">
        <li>Attempt to hack, modify, or interfere with the website’s functionality.</li>
        <li>Collect data or emails from the site for unauthorized purposes.</li>
        <li>Impersonate Amply or Fortis d.o.o. staff.</li>
      </ul>

      <h2 class="legal__h2">4. Waitlist and Communication</h2>
      <p>
        By joining the waitlist or submitting your information, you consent to receive updates about Amply’s development,
        product announcements, and early access invitations.
        You can unsubscribe anytime via the link in our emails or by contacting
        <a href="mailto:support@amply-space.com">support@amply-space.com</a>.
      </p>

      <h2 class="legal__h2">5. Intellectual Property</h2>
      <p>
        All content on this Site — including design, text, graphics, logos, and media — is the property of Fortis d.o.o. or its licensors.
        You may not copy, reproduce, or distribute content without written permission.
      </p>

      <h2 class="legal__h2">6. Disclaimers</h2>
      <p>
        The Site and all content are provided “as is”, without warranties of any kind.
        Fortis d.o.o. does not guarantee uninterrupted or error-free operation of the Site or that it will meet your expectations.
      </p>

      <h2 class="legal__h2">7. Limitation of Liability</h2>
      <p>
        Fortis d.o.o. shall not be liable for any damages or data loss resulting from your use of the Site.
        Your use of the Site is at your own risk.
      </p>

      <h2 class="legal__h2">8. Future App Features</h2>
      <p>
        Amply may evolve into a mobile or web application. These Terms will be updated to reflect new functionalities once released.
        Currently, all use is free of charge.
      </p>

      <h2 class="legal__h2">9. Governing Law</h2>
      <p>
        These Terms are governed by the laws of Montenegro. Any disputes will be handled by the competent courts of Podgorica.
      </p>

      <h2 class="legal__h2">10. Contact Information</h2>
      <p>
        If you have any questions about these Terms, contact us at:<br>
        <a href="mailto:support@amply-space.com">support@amply-space.com</a><br>
        Fortis d.o.o., Podgorica, Montenegro
      </p>
    </section>
  HTML
)

page_terms.create_meta_tag!(
  title:       "Terms of Service — Amply",
  description: "Terms governing the use of amply-space.com by Fortis d.o.o.",
  keywords:    "Terms of Service, Terms, Amply, Fortis d.o.o."
)
