# frozen_string_literal: true

require 'sqlite3'
module Core
  class Database
    def initialize
      @db = SQLite3::Database.new('wishlist.db')
      create_table_gifts
      create_table_lists
    end

    def create_table_gifts
      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          gift TEXT NOT NULL,
          link TEXT,
          price INTEGER,
          event_date TEXT,
          state TEXT
        )
      SQL
    end
    def create_table_lists
      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS lists (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          wishlist TEXT NOT NULL,
          gift_id INTEGER,
          event_date TEXT,
          FOREIGN KEY (gift_id) REFERENCES items(id)
        )
      SQL
    end

    def add_gift(user_id, gift, link, price, event_date)
      @db.execute('INSERT INTO items (user_id, gift, link, price, event_date) VALUES (?, ?, ?, ?, ?)', user_id, gift,
                  link, price, event_date)
    end

    def get_user_wishlists(user_id)
      @db.execute('SELECT * FROM items WHERE user_id = ?', user_id)
    end

    def get_friends_wishlist(id)
      @db.execute('SELECT * FROM items WHERE id = ?', id)
    end

    def close
      @db.close
    end
  end
end
