require 'telegram/bot'
require 'sqlite3'

def initialize

  token = "7920089609:AAEWYqYMdWWorwXRmvODqpimj19VylTm5qs"

  @bot = Telegram::Bot::Client.new(token)

end


begin
  # Устанавливаем соединение с базой данных.  Если файла не существует, он будет создан.
  db = SQLite3::Database.new 'my_database.db'

  # Создаем таблицу, если она еще не существует.  Обратите внимание на использование PRIMARY KEY и NOT NULL.
  db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      gift TEXT NOT NULL,
      link TEXT,
      price INTEGER,
      date TEXT
    )
  SQL

  # Добавляем некоторые примерные данные
  db.execute "INSERT INTO items (gift, link, price) VALUES (?, ?, ?)", ['Пример текста 1', 'https://example.com/1', 10]
  db.execute "INSERT INTO items (gift, link, price) VALUES (?, ?, ?)", ['Пример текста 2', 'https://example.com/2', 20]


  # Запрос данных из таблицы
  results = db.execute "SELECT * FROM items"
  puts "Данные из таблицы:"
  results.each do |row|
    puts row.inspect
  end

  #Пример обновления данных
  db.execute "UPDATE items SET price = 30 WHERE id = 1"

  #Пример удаления данных
  db.execute "DELETE FROM items WHERE id = 2"

  # Еще раз запрашиваем данные, чтобы увидеть изменения
  results = db.execute "SELECT * FROM items"
  puts "\nДанные из таблицы после изменений:"
  results.each do |row|
    puts row.inspect
  end


rescue SQLite3::Exception => e
  puts "Ошибка SQLite3: #{e}"
ensure
  # Закрываем соединение с базой данных
  db.close if db
end

def add_gift_to_db(gift_data)
  begin
    db = SQLite3::Database.new 'my_database.db'
    db.execute "INSERT INTO items (gift, link, price, date) VALUES (?, ?, ?, ?)", [gift_data[:gift], gift_data[:link] || '', gift_data[:price], Date.today.strftime('%Y-%m-%d')]

    def add_gift_to_db(gift_data)
      db = SQLite3::Database.new 'wishlist.db'
      db.execute("INSERT INTO items (user_id, gift, link, price, event_date) VALUES (?, ?, ?, ?, ?)", gift_data.values)
      db.close
    end