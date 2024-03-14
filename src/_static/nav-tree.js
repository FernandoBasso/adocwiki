//
// This is just a bare bones implementation of expanding and collapsing
// the nav-tree items. No error handling or fancy things are implemented
// as of now.
//

(function () {
  var log = console.log.bind(console);
  var qs = document.querySelector.bind(document);
  var qsa = document.querySelectorAll.bind(document);

  var categoryElements = document.querySelectorAll('.category');

  /**
   * Activates the current element and any parent category, if any, so
   * that the whole subtree is open when a subcategory is active.
   */
  function activate(elemToActivate) {
    if (!elemToActivate) return;

    elemToActivate.classList.add('active');

    activate(elemToActivate.parentElement.closest('.category'));
  }

  /**
   * When the page loads, find the element whose href has the same
   * pathname as the one in the browser URL and apply activate() to it.
   */
  window.addEventListener('load', function handleWindowLoad() {
    var currentPage = window.location.pathname;

    const activeHref = document.querySelectorAll(`.nav-tree li a[href="${currentPage}"]`)[0];

    activeHref.classList.add('current');

    var activeCategory = activeHref.closest('.category');

    activate(activeCategory);
  }, false);

  /**
   * Remove the class ‘active’ and adds the class ‘active’ to the
   * elements whose class name is ‘category’.
   */
  function deactivate(elems) {
    elems.forEach(function removeActiveClass(elem) {
      elem.classList.remove('active');
      elem.classList.add('inactive');
    });
  }

  /**
   * Adds a click handler to all ‘.category’ elements so that when
   * a click happens, the subtree is displayed.
   */
  categoryElements.forEach(function addListener(elem) {
    elem.addEventListener('click', function handleClick(evt) {
      var category = evt.target.closest('.category');

      // First, deactivate everything.
      deactivate(categoryElements);

      // Then, activate the one in question.
      category.classList.add('active');
    }, false);
  });

  qs('.nav-tree-toggle').addEventListener('click', function handleClick(evt) {
    var btn = evt.currentTarget;
    btn.classList.toggle('is-active');
    qs('.nav-tree').classList.toggle('is-active');
  }, false);

  qs('.nav-outline-toggle').addEventListener('click', function handleClick(evt) {
    var btn = evt.currentTarget;
    btn.classList.toggle('is-active');
    qs('.nav-outline').classList.toggle('is-active');
  }, false);
}());
