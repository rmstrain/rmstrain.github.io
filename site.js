/* site.js -- small helpers for strain.math.upenn.edu */

/* Write the e-mail address into links marked class="js-email"
   (keeps the address out of the page source, as before). */
document.querySelectorAll(".js-email").forEach(function (a) {
  var addr = a.getAttribute("data-u") + "@" + a.getAttribute("data-d");
  a.href = "mailto:" + addr;
  a.appendChild(document.createTextNode(addr));
});

/* Publication list: "Group by year / keyword" (pubs.html only). */
(function () {
  var select = document.getElementById("pub-group");
  var list = document.getElementById("pub-list");
  if (!select || !list) return;
  var byYear = null;

  select.addEventListener("change", function () {
    if (!byYear) byYear = list.cloneNode(true);
    if (select.value === "year") {
      list.replaceChildren.apply(list, Array.from(byYear.cloneNode(true).childNodes));
      return;
    }
    // Group by keyword: a paper appears under each of its keywords.
    var groups = {};
    byYear.querySelectorAll(".pub").forEach(function (li) {
      (li.getAttribute("data-keywords") || "Other").split("|").forEach(function (k) {
        (groups[k] = groups[k] || []).push(li);
      });
    });
    var keys = Object.keys(groups).sort(function (a, b) {
      return groups[b].length - groups[a].length || a.localeCompare(b);
    });
    list.replaceChildren();
    keys.forEach(function (k) {
      var d = document.createElement("details");
      d.className = "pub-group";
      d.open = true;
      var s = document.createElement("summary");
      s.textContent = k + " (" + groups[k].length + ")";
      var ul = document.createElement("ul");
      ul.className = "pub-items";
      groups[k].forEach(function (li) {
        var c = li.cloneNode(true);
        c.removeAttribute("id");
        ul.appendChild(c);
      });
      d.appendChild(s);
      d.appendChild(ul);
      list.appendChild(d);
    });
  });
})();
