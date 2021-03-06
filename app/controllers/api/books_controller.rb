# 本関連APIコントローラークラス
#
# 返却値がある場合、JSON形式で返す
class Api::BooksController < ApplicationController
  before_action :set_book, only: [:update, :destroy]
  # TODO ENUMにする。用途の範囲が広くなったら外に切り出す。
  LENDING        = 0
  SAFEKEEPING    = 1

  PER_PAGE_LIMIT = 20

  # 返却値をラップするための変数を生成
  def initialize
    @hash = Hash.new { |h, k| h[k] = [] }
  end

  # 本一覧取得API
  # 
  # GET /api/books
  def index
    @books = Book.all
    @hash["books"] = Book.new.get_books
    # TODO カウンターキャッシュにする
    @hash["total_count"] = Book.count
    # @hash["rending_count"] = 
    # @hash["safekeeping_count"] = 
    
    render :json => @hash
  end

  # POST /api/books
  def create
    @book = Book.new(book_params)

    if @book.save
      # historiesにユーザーIDと返却日を登録する
      render :show, status: :created, location: @book 
    else
      render json: @book.errors, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /api/books/:id
  def update
    if @book.update(book_params)
      render :show, status: :ok, location: @book 
    else
      render json: @book.errors, status: :unprocessable_entity 
    end
  end

  # DELETE /api/books/:id
  def destroy
    @book.destroy
      head :no_content 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.fetch(:book, {})
    end
end
