# frozen_string_literal: true

require 'sqlite3'
module Core
  class Database
    def initialize
      @db = SQLite3::Database.new('wishlist.db')
      create_table_gifts
      create_table_lists
      create_table_users
    end

    def create_table_users
      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          chat_id INTEGER NOT NULL,
          state TEXT
        )
      SQL
    end

    def create_table_gifts
      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          gift TEXT NOT NULL,
          link TEXT,
          price INTEGER
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

    # CRUD methods for users
    def create_user(chat_id, state)
      @db.execute("INSERT INTO users (chat_id, state) VALUES (?,?)", [chat_id, state])
    end

    def get_user_by_chat_id(chat_id)
      @db.execute("SELECT * FROM users WHERE chat_id =?", chat_id)
    end

    def update_user(chat_id, state)
      @db.execute("UPDATE users SET state =? WHERE chat_id =?", [state, chat_id])
    end

    def delete_user(chat_id)
      @db.execute("DELETE FROM users WHERE chat_id =?", chat_id)
    end

    # CRUD methods for gifts
    def create_gift(user_id, gift, link, price)
      @db.execute("INSERT INTO items (user_id, gift, link, price) VALUES (?,?,?,?)", [user_id, gift, link, price])
    end

    def get_gifts_by_user_id(user_id)
      @db.execute("SELECT * FROM items WHERE user_id =?", user_id)
    end

    def update_gift(id, gift, link, price)
      @db.execute("UPDATE items SET gift =?, link =?, price =? WHERE id =?", [gift, link, price, id])
    end

    def delete_gift(id)
      @db.execute("DELETE FROM items WHERE id =?", id)
    end

    # CRUD methods for lists
    def create_list(wishlist, gift_id, event_date)
      @db.execute("INSERT INTO lists (wishlist, gift_id, event_date) VALUES (?,?,?)", [wishlist, gift_id, event_date])
    end

    def get_lists
      @db.execute("SELECT * FROM lists")
    end

    def update_list(id, wishlist, gift_id, event_date)
      @db.execute("UPDATE lists SET wishlist =?, gift_id =?, event_date =? WHERE id =?", [wishlist, gift_id, event_date, id])
    end

    def delete_list(id)
      @db.execute("DELETE FROM lists WHERE id =?", id)
    end

    def find_or_create_user_by_chat_id(chat_id, state = 'initial_state')
      user = get_user_by_chat_id(chat_id)
      if user.empty?
        create_user(chat_id, state)
        get_user_by_chat_id(chat_id)
      else
        user
      end
    end
    
    def close
      @db.close
    end
  end
end