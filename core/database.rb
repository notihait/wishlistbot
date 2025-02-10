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
          state TEXT,
          current_wishlist_id INTEGER,
          current_gift_id INTEGER,
          FOREIGN KEY (current_wishlist_id) REFERENCES lists(id),
          FOREIGN KEY (current_gift_id) REFERENCES items(id)
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
          price INTEGER,
          if_chosen BOOLEAN,
          list_id INTEGER,
          FOREIGN KEY (user_id) REFERENCES users(id),
          FOREIGN KEY (list_id) REFERENCES lists(id)
        )
      SQL
    end

    def create_table_lists
      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS lists (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          wishlist_name TEXT NOT NULL,
          user_id INTEGER,
          event_date TEXT,
          FOREIGN KEY (user_id) REFERENCES users(id)
        )
      SQL
    end

    # CRUD methods for users
    def create_user(params)
      @db.execute("INSERT INTO users (chat_id, state) VALUES (?,?)", [params[:chat_id], params[:state]])
    end

    def get_user_by_chat_id(chat_id)
      user = @db.execute("SELECT * FROM users WHERE chat_id =? LIMIT 1", [chat_id]).first
      user_to_hash(user) if user
    end

    def update_user(params)
      @db.execute("UPDATE users SET state =?, current_wishlist_id=? WHERE chat_id =?", [params[:state], params[:current_wishlist_id], params[:chat_id]])
    end

    def delete_user(params)
      @db.execute("DELETE FROM users WHERE chat_id =?", [params[:chat_id]])
    end

    # CRUD methods for gifts
    def create_gift(params)
      @db.execute("INSERT INTO items (user_id, gift, link, price) VALUES (?,?,?,?)", [params[:user_id], params[:gift], params[:link], params[:price]])
    end

    def get_gifts_by_user_id(user_id)
      @db.execute("SELECT * FROM items WHERE user_id =?", [user_id]).map { |gift| gift_to_hash(gift) }
    end

    def update_gift(params)
      @db.execute("UPDATE items SET gift =?, link =?, price =? WHERE id =?", [params[:gift], params[:link], params[:price], params[:id]])
    end

    def update_gift_price(params)
      p "цена #{params[:price]}"
      @db.execute("UPDATE lists SET price=? WHERE id=?", [params[:price], params[:id]])
    end

    def delete_gift(params)
      @db.execute("DELETE FROM items WHERE id =?", [params[:id]])
    end

    # CRUD methods for lists
    def create_list(params)
      @db.execute("INSERT INTO lists (wishlist_name, event_date, user_id) VALUES (?,?,?)", [params[:wishlist_name], params[:event_date], params[:user_id]])
      @db.last_insert_row_id
    end

    def get_lists(params)
      @db.execute("SELECT * FROM lists WHERE user_id=?", [params[:user_id]]).map { |list| list_to_hash(list) }
    end    

    def update_list_wishlist_name(params)
      @db.execute("UPDATE lists SET wishlist_name =?, event_date =? WHERE id =?", [params[:wishlist_name], params[:gift_id], params[:event_date], params[:id]])
    end

    def update_list_date(params)
      p "Дата для обновления: #{params[:event_date]}"
      @db.execute("UPDATE lists SET event_date=? WHERE id=?", [params[:event_date], params[:id]])
    end
    
    def delete_list(params)
      @db.execute("DELETE FROM lists WHERE id =?", [params[:id]])
    end

    def find_or_create_user_by_chat_id(chat_id)
      user = get_user_by_chat_id(chat_id)
      if user.nil?
        create_user(chat_id: chat_id, state: 'initial_state')
        get_user_by_chat_id(chat_id)
      else
        user
      end
    end

    private

    def user_to_hash(user)
      { id: user[0], chat_id: user[1], state: user[2], current_wishlist_id: user[3] }
    end

    def gift_to_hash(gift)
      { id: gift[0], user_id: gift[1], gift: gift[2], link: gift[3], price: gift[4] }
    end

    def list_to_hash(list)
      { id: list[0], wishlist: list[1], gift_id: list[2], event_date: list[3] }
    end

    def close
      @db.close
    end
  end
end



# check if the gift had been chosen by smone. 0 true 1 false. The use of the type name BOOLEAN here is for readability, to SQLite it's just a type with NUMERIC affinity.