define([
  'backbone',
],
function(Backbone){

  return Backbone.Model.extend({
    url : function() {
      return '/schools' + (this.id ? '/' + this.id : '');
    }
  });

});

