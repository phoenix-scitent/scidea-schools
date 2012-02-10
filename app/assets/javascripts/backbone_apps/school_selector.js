define([
  'jquery',
  'underscore',
  'backbone',
  'backbone_apps/models/school',
  'jquery_plugins/jquery.formparams',
  'jquery_plugins/jquery.blockUI-2.3.7'
],
function($, _, Backbone, School){

  $.blockUI.defaults.css = {};

  var SchoolSelectorView = Backbone.View.extend({
    newSchoolForm : $($('#new-school-form-tpl').html()).html(),

    stateDefs : {
      'schools-found' : function() {
        $(this.el).addClass('schools-found').removeClass('schools-not-found');
      },
      'schools-not-found' : function() {
        $(this.el).addClass('schools-not-found').removeClass('schools-found');
      },
      'adding-school' : function() {
        $(this.el).addClass('adding-school').removeClass('cancelled-school-edit');
      },
      'editing-school' : function() {
        $(this.el).addClass('editing-school').removeClass('cancelled-school-edit');
      },
      'cancelled-school-edit' : function() {
        $(this.el).addClass('cancelled-school-edit').removeClass('adding-school editing-school');
      },
      'new-school-exists' : function() {
        $(this.el).addClass('new-school-exists').removeClass('adding-school editing-school');
      },
      'new-school-updated' : function() {
        $(this.el).addClass('new-school-updated').removeClass('adding-school editing-school');
      }
    },

    events : {
      'click a[href="#add-new-school"]' : 'addNewSchool',
      'click a[href="#edit-new-school"]' : 'editNewSchool',
      'click a[href*="cancel-edit-school"]' : 'cancelEditSchool', // the *= attribute portion of the selector is necessary for IE7
      'click a[href="#select-new-school"]' : 'selectNewSchool',
      'click #school_submit' : 'submitSchool'
    },

    initialize : function(opts) {
      var self = this;

      _.bindAll(this,
                'validateZipcode',
                'handleSchoolsFound',
                'handleSchoolsNotFound',
                'handleNewSchoolSaved',
                'handleAudienceChange',
                'addSchoolFields',
                'setState',
                'detach',
                'reattach',
                'populateSchoolsSelect');

      // used later when we detach and reattach this view element to the DOM
      this.$prevEl = $(this.el).prev();

      // handle changes in the audience field. show the school selector if audience is educator
      this.$audienceField = opts.audienceField;
      if( opts.audienceField.length ) {
        this.$audienceField.live('change', this.handleAudienceChange);
        this.handleAudienceChange();
      }

      // intialize zipcode validation and Ajax posting
      this.validateZipcode = _.debounce(this.validateZipcode, 500);
      this.$('#school-select-zipcode').bind('keydown', function(e) {
        self.supressFormSubmission(e);
        self.validateZipcode();
      });

      // search for a zipcode if one is pre-populated in the form; run this once per page load
      var $zipcodeField = this.$('#school-select-zipcode');
      var zipcode = $zipcodeField.val();
      if(zipcode && zipcode.search(/\d{5}/) >= 0) {
        $zipcodeField.trigger('keydown');
      }

      this.school = new School();
    },

    addNewSchool : function(e) {

      var $newSchoolForm;

      e.preventDefault();

      this.disableSelection();
      this.disableZipcodeInput();

      // $('#new-school-form').show();

      this.showNewSchoolForm() // a jQuery ref to the form is returned
          .find('#school_zipcode')
          .val( $('#school-select-zipcode').val() );

      this.setState('adding-school');
    },

    editNewSchool : function(e) {
      e.preventDefault();

      this.disableSelection();
      this.disableZipcodeInput();

      this.showEditSchoolForm();

      this.setState('editing-school');
    },

    selectNewSchool : function(e) {
      e.preventDefault();

      var zipcode = this.school.get('zipcode');

      this.$('#school-select-zipcode').val(zipcode);
      this.getSchoolsForZipcode(zipcode, this.school.id);
    },

    cancelEditSchool : function(e) {
      e.preventDefault();
      this.hideNewSchoolForm();
      if(this.schoolsFound) { this.enableSelection(); }
      this.enableZipcodeInput();
      this.setState('cancelled-school-edit');
    },

    showSchoolForm : function(action) {
      return $('#new-school-form').empty()
                                  .append(this[action + 'SchoolForm'])
                                  .show()
                                  .find('#school_name')
                                  .focus()
                                  .end();
    },

    showNewSchoolForm : function() {
      return this.showSchoolForm('new');
    },

    showEditSchoolForm : function() {
      return this.showSchoolForm('edit');
    },

    hideNewSchoolForm : function() {
      $('#new-school-form').fadeOut('slow',function(){
        $(this).empty();
      });
    },

    selectedSchoolIdFromServer : function() {
      return $('#school-id').data('selected-id');
    },

    populateSchoolsSelect : function(optionsHTML) {

      var $schoolSelect = $('#school-id'),
          selectedId = this.selectedSchoolIdFromServer();

      $schoolSelect.html(optionsHTML);

      if( !(_.isUndefined(selectedId) || selectedId === '') ) {
        $schoolSelect.val(selectedId);
      }

      this.populateSchoolsSelect = function(optionsHTML) {
        $schoolSelect.html(optionsHTML);
      };
    },

    enableSelection : function() {
      $('#school-id').removeAttr('disabled');
    },

    enableZipcodeInput : function() {
      $('#school-select-zipcode').removeAttr('disabled');
    },

    disableZipcodeInput : function() {
      $('#school-select-zipcode').attr('disabled', 'disabled');
    },

    disableSelection : function() {
      $('#school-id').attr('disabled', 'disabled');
    },

    supressFormSubmission : function(e) {
      if(e.which == 13) {
        e.stopPropagation();
        e.preventDefault();
      }
    },

    validateZipcode : function(e) {
      var $zipcode = $("#school-select-zipcode");
      var isValid = $zipcode.prop('validity').valid;

      if(isValid) {
        this.getSchoolsForZipcode($('#school-select-zipcode').val(), this.school.id || this.selectedSchoolIdFromServer());
      } else {
        this.disableSelection();
      }
    },

    handleSchoolsFound : function(schoolsOptionsHTML) {
      this.schoolsFound = true;
      this.enableSelection();
      this.enableZipcodeInput();
      this.populateSchoolsSelect(schoolsOptionsHTML);
      this.setState('schools-found');
    },

    handleSchoolsNotFound : function() {
      this.schoolsFound = false;
      this.enableZipcodeInput();
      this.populateSchoolsSelect('<option>No educational institutions found</option>');
      this.setState('schools-not-found');
    },

    handleNewSchoolSaved : function(saveOp) {

      var context = this,
          schoolsOptionsCache = this.getSchoolsForZipcode,
          zipcode = this.school.get('zipcode'),
          id = this.school.id;

      /* update the DOM after we've fetched the new edit form so the old edit
         form isn't accidentally used if the user *quickly* clicks the edit link
      */
      this.fetchEditSchoolForm( function() {
        if(saveOp == 'update') {
          delete schoolsOptionsCache[zipcode + id];
          context.setState('new-school-updated');
        } else {
          context.setState('new-school-exists');
        }

        $('#school-id-input .inline-errors').remove();

        context.$('#school-select-zipcode').val(zipcode).trigger('refreshCustomValidityRules');
        context.getSchoolsForZipcode(zipcode, id);

        $('#new-school-form').unblock({fadeOut: 0});
        context.hideNewSchoolForm();
      } );
    },

    handleNewSchoolSavedError : function(model, response) {
      var errors = $.parseJSON(response.responseText);
      this.editSchoolForm = errors.html;
      this.showEditSchoolForm();
    },

    handleAudienceChange : function() {
      var selectedText = this.$audienceField.find(':selected').text();
      if( selectedText.toLowerCase() != 'educator' ) {
        this.detach();
      } else {
        this.addSchoolFields();
      }
    },

    addSchoolFields : function() {
      // if not already in DOM, add it
      if(!$($(this.el).selector).length) {
        this.reattach();
      }
    },

    fetchEditSchoolForm : function(success_callback) {
      $.ajax({
        url : '/schools/' + this.school.id + '/edit',
        context: this,
        success : function(response, textStatus, jqXHR) {
          if(success_callback) { success_callback(); }

          this.editSchoolForm = response;
        }
      });
    },

    setState : function(state) {
     this.stateDefs[state].call(this);
    },

    getSchoolsForZipCodeXhr : function(zipcode, selectedId) {

      this.enableSelection();
      $('#school-id option').first().text('Searching...');

      $.ajax('/schools', {
        context : this,
        data : {
          zipcode : zipcode,
          new_school_id : selectedId
        },
        success : function(response, textStatus, jqXHR) {

          if(response.html) {
            this.handleSchoolsFound(response.html);
          } else {
            this.handleSchoolsNotFound();
          }

          // memoize the response html on the getSchoolsForZipCode function
          this.getSchoolsForZipcode[zipcode + (this.school.id || '')] = response.html;
        }
      });

    },

    getSchoolsForZipcode : function(zipcode, selectedId) {

      this.disableZipcodeInput();

      var schoolOptionsHTML = arguments.callee[zipcode + ( selectedId || '' )];

      if(_.isUndefined(schoolOptionsHTML)) {

        this.getSchoolsForZipCodeXhr(zipcode, selectedId);

      } else {

        if(schoolOptionsHTML === '') {
          this.handleSchoolsNotFound();
        } else {
          this.handleSchoolsFound(schoolOptionsHTML);
        }

      }
      return schoolOptionsHTML;
    },

    clearSchoolQueryCacheFor : function(zipcode, id) {
      var schoolsQueryCache = this.getSchoolsForZipcode;
      delete schoolsQueryCache[zipcode + id];
    },

    submitSchool : function(e) {
      e.preventDefault();
      var formParamsConvertTypes = false,
          formParams = this.$('#new-school-form').formParams(formParamsConvertTypes),
          saveOp = this.school.id ? 'update' : 'create';

      $('#new-school-form').block({
        message: '<span class="text">Saving educational institution</span> <span class="icon-loading"></span>',
        overlayCSS: {
          backgroundColor: null,
          opacity: null
        }
      });

      // Clear the cached search result related to the new school, as the user is now changing the zipcode
      if(saveOp == 'update' && formParams.school.zipcode != this.school.get('zipcode')) {
        this.clearSchoolQueryCacheFor(this.school.get('zipcode'), this.school.id);
      }

      this.school.save(formParams, {
        success : _.bind(this.handleNewSchoolSaved, this, saveOp),
        error   : _.bind(this.handleNewSchoolSavedError, this)
      });
    },

    detach : function() {
      $(this.el).detach();
    },

    reattach : function() {
      $(this.el).insertAfter(this.$prevEl);
    }

    });

  // called when plugin is loaded and document is ready
  return function($) {
    var $schoolSelectorEl = $('#profile-school'); 

    if($schoolSelectorEl.length) {
      new SchoolSelectorView({
        el : $schoolSelectorEl.get(),
        audienceField : $('#user_profile_attributes_audience_id')
      });
    }

    return SchoolSelectorView;
  }; // anonymous define return function

}); // define
