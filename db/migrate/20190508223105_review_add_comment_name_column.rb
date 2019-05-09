class ReviewAddCommentNameColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :name, :string
    add_column :reviews, :comment, :review
  end
end
