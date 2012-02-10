module HtmlSelectorsHelpers
  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.rb
  #
  def selector_for(locator)
    case locator

    when /the page/
      "html > body"

    when /manage menu/
      ".manage-menu"

    when /([^"]*) tab content/
      tab_pane_id = locator.match(/([^"]*) tab content/)[1].downcase.gsub(' ','-')
      "##{tab_pane_id}.tab-pane"

    when /expandable row for user "([^"]*)"/
      user = User.find_by_email(locator.match(/expandable row for user "([^"]*)"/)[1])
      "#users-found > .table-blue-zebra > table > tbody > tr + tr.expandable section#user-#{user.id}"

    when /the seminar applications widget/
      "#portlet-seminar-applications"

    when /^the "([^"]*)" table$/
      table_ancestor_id = locator.match(/the "([^"]*)" table/)[1].downcase.gsub(' ','-')
      "##{table_ancestor_id} table"

    when /cell (\d+) of row (\d+) of the "([^"]*)" table/
      cell_index, row_index, table_ancestor_id = locator.match(/cell (\d+) of row (\d+) of the "([^"]*)" table/).to_a.drop(1)
      "##{table_ancestor_id.downcase.gsub(' ','-')} table tbody tr:nth-child(#{row_index}) td:nth-child(#{cell_index})"

    when /cell (\d+) of the header row of the "([^"]*)" table/
      cell_index, table_ancestor_id = locator.match(/cell (\d+) of the header row of the "([^"]*)" table/).to_a.drop(1)
      "##{table_ancestor_id.downcase.gsub(' ','-')} table thead tr:first-child th:nth-child(#{cell_index})"
    

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #  when /the (notice|error|info) flash/
    #    ".flash.#{$1}"
    
    # You can also return an array to use a different selector
    # type, like:
    #
    #  when /the header/
    #    [:xpath, "//header"]

    # This allows you to provide a quoted selector as the scope
    # for "within" steps as was previously the default for the
    # web steps:
    when /"(.+)"/
      $1

    else
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(HtmlSelectorsHelpers)
