require 'sqlite3'

class Database
  def initialize
    @db = SQLite3::Database.new('wishlist.db')
    create_table
  end

  def create_table
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        gift TEXT NOT NULL,
        link TEXT,
        price INTEGER,
        event_date TEXT
      )
    SQL
  end

  def add_gift(user_id, gift, link, price, event_date)
    @db.execute("INSERT INTO items (user_id, gift, link, price, event_date) VALUES (?, ?, ?, ?, ?)", user_id, gift, link, price, event_date)
  end

  def get_user_wishlists(user_id)
    @db.execute("SELECT * FROM items WHERE user_id = ?", user_id)
  end

  def get_friends_wishlist(id)
    @db.execute("SELECT * FROM items WHERE id = ?", id)
  end

  def close
    @db.close
  end
end