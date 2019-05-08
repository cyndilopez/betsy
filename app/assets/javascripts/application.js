// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.  
//= require jquery3
//= require popper
//= require bootstrap-sprockets

//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .


function increaseValue(id) {
  console.log(id)
  var value = parseInt(document.getElementById('order-item' + id).value, 10);
  value = isNaN(value) ? 0 : value;
  value++;
  document.getElementById('order-item' + id).value = value;
}

function decreaseValue(id) {
  var value = parseInt(document.getElementById('order-item' + id).value, 10);
  value = isNaN(value) ? 0 : value;
  value < 1 ? value = 1 : '';
  value--;
  document.getElementById('order-item' + id).value = value;
}