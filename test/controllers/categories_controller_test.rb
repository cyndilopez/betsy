require "test_helper"

describe CategoriesController do
  before do
    merchant = merchants(:jenkins)
    perform_login(merchant)
  end
  describe "new" do
    it "can get to the new form page" do
      get new_category_path
      must_respond_with :ok
    end
  end

  describe "create" do
    it "creates a new category" do
      category_data = {
        category: {
          name: "new category",
        },
      }

      expect {
        post categories_path, params: category_data
      }.must_change "Category.count", +1

      must_redirect_to root_path
      expect(flash[:status]).must_equal :success
      expect(flash[:message]).wont_be_nil

      new_category = Category.last
      expect(new_category.name).must_equal category_data[:category][:name]
      expect(new_category.id).wont_be_nil
    end

    it "sends back a bad request if category couldn't be created" do
      category_data = {
        category: {
          name: "",
        },
      }

      expect {
        post categories_path, params: category_data
      }.wont_change "Category.count"

      must_redirect_to root_path
      expect(flash[:status]).must_equal :error
      expect(flash[:message]).wont_be_nil

    end
  end
end
