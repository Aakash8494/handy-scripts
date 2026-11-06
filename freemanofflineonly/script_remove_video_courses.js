(() => {
  const cardSelector = '.tutor-course-card, .tutor-course-list-item';

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

  function hideFilteredCourses() {
    document.querySelectorAll(cardSelector).forEach(card => {
      const title = card.querySelector(
        '.tutor-course-name, .tutor-course-title, h2, h3, h4'
      );

      if (!title) return;

      const titleText = title.textContent.trim();
      const isVideoCourse = /\s[-–—]\s*Video\s*$/i.test(titleText);
      const isOwnedCourse = ownedCourseTitles.has(normalizeTitle(titleText));

      if (isVideoCourse || isOwnedCourse) {
        card.style.display = 'none';
      }
    });
  }

  hideFilteredCourses();

  // Reapply if the page replaces or adds course cards.
  new MutationObserver(hideFilteredCourses).observe(document.body, {
    childList: true,
    subtree: true,
  });
})();