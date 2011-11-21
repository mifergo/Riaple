// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
/* Activating Best In Place */
jQuery(".best_in_place").best_in_place()
});

$(function() {
  $("#task_start").datepicker({
      firstDay: 1,
      dateFormat: "yy/mm/dd"
  });
  $("#feature_start").datepicker({
      firstDay: 1,
      dateFormat: "yy/mm/dd"
  });
  $("#sprint_start").datepicker({
      firstDay: 1,
      dateFormat: "yy/mm/dd"
  });
  $("#sprint_finish").datepicker({
      firstDay: 1,
      dateFormat: "yy/mm/dd"
  });
    $("#datepicker").datepicker( {
        firstDay: 1,
        dateFormat: "yy/mm/dd"
    })
});
