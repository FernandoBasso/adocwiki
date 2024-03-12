(function () {
  var log = console.log.bind(console);

  var current;

  var elems = document.querySelectorAll('.category');

  elems.forEach(function addListener(elem) {
    elem.addEventListener('click', function handleClick(evt) {
      log(evt.target);
      var category = evt.target.closest('.category');
      category.classList.add('active');
    });
  });

}());
