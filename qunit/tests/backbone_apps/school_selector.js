$(function() {

  var SchoolSelectorView = app.SchoolSelectorView;

  module("School Selector Tests");

  test("SchoolSelectorView loaded", function() {
    ok(SchoolSelectorView, "SchoolSelectorView defined");

    var ssv = new SchoolSelectorView({
      el : $('#profile-school').get(),
      audienceField : $('#profile_audience_id')
    });
    ok(ssv, "SchoolSelectorView instantiable");
    ok(ssv.newSchoolForm, "SchoolSelectorView#newSchoolForm accessible");
    ok(ssv.stateDefs, "SchoolSelectorView#stateDefs accessible");
  });

  test("zipcode validation", function() {
    var audienceField = $('#profile_audience_id');
    var ssv = new SchoolSelectorView({
      el : $('#profile-school').get(),
      audienceField : audienceField
    });

    // School field only shows up when audience is set to Educator
    var educatorOption = $('#profile_audience_id option:contains(Educator)');
    audienceField.val(educatorOption.val()).trigger('refreshCustomValidityRules');
    audienceField.change();

    var zipcode = $("#school-select-zipcode");
    ok(zipcode, "Found zipcode DOM element");
    ok(zipcode.prop("required"), "zipcode should be required");

    zipcode.val("").trigger('refreshCustomValidityRules');
    ok(!zipcode.prop('validity').valid, "empty zipcode should not be valid");

    zipcode.val("123").trigger('refreshCustomValidityRules');
    ok(!zipcode.prop('validity').valid, "too short");

    zipcode.val("12345").trigger('refreshCustomValidityRules');
    ok(zipcode.checkValidity(), "good format, correct length (checkValidity)");
    ok(zipcode.prop('validity').valid, "good format, correct length");

    zipcode.val("abcde").trigger('refreshCustomValidityRules');
    ok(!zipcode.checkValidity(), "bad format (checkValidity)");
    ok(!zipcode.prop('validity').valid, "bad format");
    equals(zipcode.prop('validationMessage'), "Invalid zipcode", "custom error message shows");
  });

});
