//= require backbone-0.5.3
//= require_self

(function(app, $, window, document, undefined) {
  app.School = Backbone.Model.extend({
    url : function() {
      return '/schools' + (this.id ? '/' + this.id : '');
    }    
  });
}(namespace('Scidea'), jQuery, window, document));
