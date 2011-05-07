// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function removeFields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function addFields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

function Retrier(options){
  this.retried = 0;
  this.options = $.extend({ interval: 500, max: 20 }, options || {});
}

$.extend(Retrier.prototype, {
      retry: function(callback){
        if (this.retried < this.options.max) {
          this.retried++;
          setTimeout(callback, this.options.interval);
        }
      },
      reset: function(){
        this.retried = 0;
      }
    });


function formatString(template, variables){
  var formatted = template;
  for (var key in variables){
    formatted = formatted.replace(new RegExp('{'+key+'}', 'g'), variables[key]);
  }
  return formatted;
}
