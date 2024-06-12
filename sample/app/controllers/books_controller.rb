class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def create
    param = book_params
    pp param
    Book.create!(param)
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :image)
  end
end
