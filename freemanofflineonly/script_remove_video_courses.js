(() => {
  const cardSelector = '.tutor-course-card, .tutor-course-list-item';
  const titleSelector =
    '.tutor-course-name, .tutor-course-title, h2, h3, h4';
  const headingSelector = '.codex-course-category-heading';

  const normalizeTitle = title =>
    title
      .normalize('NFKC')
      .toLowerCase()
      .replace(/[‘’]/g, "'")
      .replace(/[–—]/g, '-')
      .replace(/\s*-\s*video\s*$/i, '')
      .replace(/\s+/g, ' ')
      .trim();

  const ownedCourseTitles = new Set([
    "Gurukul Hindi E-Book",
    "Gurukul English E-Book",
    "From Sex to Society: Navigating Your Sacred Self",
    "How to Prepare for LIFE in your 20s",
    "Apni Life Story se Pyaar kaise kare",
    "Sex & Spirituality: How To Be Attractive To God And Women",
    "How to Rise from Pain and Reach towards Love",
    "How to Build Sexual Intimacy",
    "Why She Will Want A Second Date",
    "How to Stand Out From Other Guys Who Talk to Her",
    "Ladies Se Pehli Baar Milne Par Kya Karna Chahiye",
    "Friendzone se Bahar kaise Nikle – Part 2/2",
    "Friendzone se Bahar kaise Nikle – Part 1/2",
    "How To Get Out of Friendzone – Part 2",
    "How to get Girls as a Nice Guy",
    "Multiple Sexual Relationships Kaise Handle Kare",
    "How to Create Sexual Interest while Interacting with a Girl",
    "How to Create Sexual Interest while Interacting with a Girl (Hindi)",
    "Kaisa Mindset Women ko Deeply Attractive lagta hai",
    "Shaadi Ke Pehle Ye Dekh Lena",
    "How To Never Get Friendzoned Again",
    "Long Term Relationship Kaise Banaye",
    "How To Overcome Fear Of Rejection From A Girl",
    "First Date Par Ladki Se Kya Baat Kare",
    "Friend Se Girlfriend Kaise Banaye",
    "Logo Ko Impress Kaise Kare",
    "How to Destroy Approach Anxiety",
    "Emotional Awareness Se Zindagi Kaise Badle",
    "Upper Class na hone ki Insecurity kaise khatam kare",
    "Zinda Feel nahi ho raha?",
    "Log Social Status Games Kyu Khelte Hai",
    "G**nd Fatne Par Kya Kare",
    "Life Me Aage Kaise Badhe Motivation",
    "How To Stay Focused On Your Goals",
    "One Sided Love Ko Kaise Bhulaye",
    "Emotionally Strong Kaise Bane",
    "Jab Aurat Jhooti Nikle",
    "Sex ki Uncontrollable Desire ko kaise Control kare",
    "How Self-Improvement Has F*cked You",
    "Mard Aur Ladke Ki Zindagi Me Farak Kya Hota Hai",
    "While Improving Ourselves What Do We Fail To Realize",
    "How To Not Lose Your Power To A Woman",
    "Apne Aap Se Pyaar Kaise Kare",
    "How To Become A Masculine Man",
    "How to start Manifesting Abundance in Work & Life"
  ].map(normalizeTitle));

  const styleId = 'codex-course-category-heading-style';
  if (!document.getElementById(styleId)) {
    const style = document.createElement('style');
    style.id = styleId;
    style.textContent = `
      .codex-course-category-heading {
        box-sizing: border-box;
        grid-column: 1 / -1;
        flex: 0 0 100%;
        width: 100%;
        margin: 24px 0 12px;
        padding: 10px 12px;
        border-left: 4px solid #c44f16;
        background: #f5f5f5;
        color: #222;
        font-size: 1.1rem;
        font-weight: 700;
      }
    `;
    (document.head || document.documentElement).appendChild(style);
  }

  function getCourseItems() {
    const items = [];
    const seen = new Set();

    document.querySelectorAll(cardSelector).forEach(candidate => {
      const item = candidate.closest('.tutor-course-list-item') || candidate;
      if (seen.has(item)) return;
      seen.add(item);

      const card = item.matches('.tutor-course-card')
        ? item
        : item.querySelector('.tutor-course-card') || item;

      const titleElement =
        (card.matches(titleSelector) && card) ||
        card.querySelector(titleSelector) ||
        item.querySelector(titleSelector);

      if (!titleElement) return;

      items.push({ item, card, title: titleElement.textContent.trim() });
    });

    return items;
  }

  function getCategory(card) {
    const bylines = [...card.querySelectorAll('p, span, div, a')]
      .map(element => element.textContent.replace(/\s+/g, ' ').trim())
      .filter(text => /^by\s+.+?\s+in\s+.+$/i.test(text))
      .sort((a, b) => a.length - b.length);

    const bylineMatch = bylines[0]?.match(/\bin\s+(.+)$/i);
    if (bylineMatch) return bylineMatch[1].trim();

    const categoryElement = card.querySelector(
      '.tutor-course-category, [class*="course-category"]'
    );
    return categoryElement?.textContent.replace(/\s+/g, ' ').trim() || '';
  }

  function updateCourses() {
    const items = getCourseItems();

    items.forEach(({ item, title }) => {
      const isVideoCourse = /[-–—]\s*Video\s*$/i.test(title);
      const isOwnedCourse = ownedCourseTitles.has(normalizeTitle(title));

      if (isVideoCourse || isOwnedCourse) {
        item.style.display = 'none';
      }
    });

    const visibleItems = items.filter(
      ({ item }) => item.style.display !== 'none'
    );
    const visibleNodes = new Set(visibleItems.map(({ item }) => item));

    // Remove headings left behind if the site refreshes or replaces cards.
    document.querySelectorAll(headingSelector).forEach(heading => {
      const next = heading.nextElementSibling;
      if (!next || !visibleNodes.has(next)) heading.remove();
    });

    let previousCategory = '';
    let previousParent = null;

    visibleItems.forEach(({ item, card }) => {
      const category = getCategory(card);
      if (!category) {
        previousCategory = '';
        previousParent = item.parentElement;
        return;
      }

      const parent = item.parentElement;
      const startsNewRun =
        category !== previousCategory || parent !== previousParent;

      if (startsNewRun) {
        const existingHeading = item.previousElementSibling;
        const headingAlreadyCorrect =
          existingHeading?.matches(headingSelector) &&
          existingHeading.textContent.trim() === category;

        if (!headingAlreadyCorrect) {
          const heading = document.createElement('div');
          heading.className = 'codex-course-category-heading';
          heading.textContent = category;
          heading.setAttribute('role', 'heading');
          heading.setAttribute('aria-level', '2');
          parent.insertBefore(heading, item);
        }
      }

      previousCategory = category;
      previousParent = parent;
    });
  }

  let updateQueued = false;
  function scheduleUpdate() {
    if (updateQueued) return;
    updateQueued = true;

    requestAnimationFrame(() => {
      updateQueued = false;
      updateCourses();
    });
  }

  updateCourses();

  new MutationObserver(scheduleUpdate).observe(document.body, {
    childList: true,
    subtree: true
  });
})();