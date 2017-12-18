window.initializeCodeFolding = function(show) {
  
  // index for unique code element ids
  var currentIndex = 1;
  
  // select all R code blocks
  var rCodeBlocks = $('pre.r, pre.python, pre.bash, pre.sql, pre.cpp, pre.stan');
  rCodeBlocks.each(function() {
    // Select div with code, and wrap it to our code
    var id = 'rcode-643E0F36' + currentIndex++;
    var curr = $(this);
 
    if (curr.text().indexOf("Hidden") !== -1) {
      var panl = $('<div class="panel panel-default"></div>');
      var ttl = $('<div class="panel-heading panel-title"></div>');
      var trig = $('<a data-toggle="collapse">Show / hide code</a>');
      var div = $('<div class="collapse in"></div>');
      div.attr("class", "collapse");
      div.attr('id', id);
      trig.attr('href', '#' + id);
    
      $(this).wrap(panl);
      $(this).before(ttl);
      ttl.append(trig);
      $(this).wrap(div);
    }
  });
  
}

$(document).ready(function () {
  window.initializeCodeFolding("show" === "show");
});