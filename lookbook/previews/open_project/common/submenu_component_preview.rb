module OpenProject
  module Common
    # @logical_path OpenProject/Common
    class SubmenuComponentPreview < Lookbook::Preview
      # @label Default
      # @display min_height 450px
      def default
        render_with_template(template: "open_project/common/submenu_preview/playground",
                             locals: { sidebar_menu_items: menu_items, searchable: false, create_btn_options: nil })
      end

      # @label Searchable
      # Searching is currently not working in the lookbook because stimulus controllers are not loaded correctly.
      # It will be fine in production.
      def searchable
        render_with_template(template: "open_project/common/submenu_preview/playground",
                             locals: { sidebar_menu_items: menu_items, searchable: true, create_btn_options: nil })
      end

      # @label With create Button
      # `create_btn_options: { href: "/#", module_key: "user"}`
      def with_create_button
        render_with_template(template: "open_project/common/submenu_preview/playground",
                             locals: { sidebar_menu_items: menu_items,
                                       searchable: true,
                                       create_btn_options: { href: "/#", module_key: "user" } })
      end

      # @label With leading icon
      # `create_btn_options: { href: "/#", module_key: "user"}`
      # TODO: show the items
      def with_leading_icons
        render_with_template(template: "open_project/common/submenu_preview/playground",
                             locals: { sidebar_menu_items: [
                                         OpenProject::Menu::MenuGroup.new(
                                           header: "Favourite",
                                           children: [
                                             OpenProject::Menu::MenuItem.new(title: "Watched", href: "", selected: false,
                                                                             icon: :eye),
                                             OpenProject::Menu::MenuItem.new(title: "Assigned", href: "", selected: true,
                                                                             icon: :"op-person-assigned")
                                           ]
                                         )
                                       ],
                                       searchable: true,
                                       create_btn_options: { href: "/#", module_key: "user" } })
      end

      def with_favourite_query
        # TODO
      end

      def with_enterprise_query
        # TODO
      end

      private

      def menu_items
        [
          OpenProject::Menu::MenuGroup.new(
            header: nil,
            children: [
              OpenProject::Menu::MenuItem.new(title: "Global query", href: "", selected: true),
              OpenProject::Menu::MenuItem.new(title: "A second query", href: "", selected: false)
            ]
          ),
          OpenProject::Menu::MenuGroup.new(
            header: "Favourite",
            children: [
              OpenProject::Menu::MenuItem.new(title: "Very important version", href: "", selected: false),
              OpenProject::Menu::MenuItem.new(title: "A baseline view", href: "", selected: true)
            ]
          ),
          OpenProject::Menu::MenuGroup.new(
            header: "Private",
            children: [
              OpenProject::Menu::MenuItem.new(title: "My query", href: "", selected: false),
              OpenProject::Menu::MenuItem.new(title: "An awesome query", href: "", selected: false),
              OpenProject::Menu::MenuItem.new(title: "A third query", href: "", selected: false)
            ]
          )
        ]
      end
    end
  end
end
