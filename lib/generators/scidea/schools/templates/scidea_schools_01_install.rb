class ScideaSchools01Install < ActiveRecord::Migration
  def up
    create_table "schools" do |t|
      t.string   "name"
      t.string   "address_1"
      t.string   "address_2"
      t.string   "city"
      t.string   "state"
      t.string   "zipcode"
      t.boolean  "approved"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "phone"
    end

    add_column :profiles, :school_id, :integer

    sql = <<-SQL
      set @course_and_scitent_admins = (select group_concat(id) from roles where symbol in ('course_admin', 'scitent_admin'));
      set @product_and_scitent_admins = (select group_concat(id) from roles where symbol in ('product_admin', 'scitent_admin'));
      
      SELECT @admin_nav_secondary_id:=id FROM menus WHERE name = 'Admin Navigation: Secondary' LIMIT 1;

      INSERT INTO menu_elements (display_name, menu_id, url, view_role_list, edit_role_list, order_sequence) VALUES ('Educational Institutions', @admin_nav_secondary_id, '/admin/schools', @course_and_scitent_admins, @product_and_scitent_admins, 102);
    SQL

    sql.split("\n").reject{|s| s.strip.start_with?('#') || s.strip.empty? }.each{ |s| execute s.strip }
  end

  def down
    drop_table :schools
    remove_column :profiles, :school_id
    execute "delete from menu_elements where display_name = 'Educational Institutions';"
  end
end
