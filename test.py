import random
import telegram
from pprint import pprint

def collect_words():
    words = list()
    dic = open("words.txt")
    for line in dic:
        line = line.rstrip().split(":")
        words.append(line)
    return words

def answer(text, rnd_def, true_word):
    user_choice = int(text)
    if rnd_def[user_choice-1] == true_word[1]:
        return 1
    else: return 0
    
def fictionary_game(words):
    random.shuffle(words)
    true_word = words[0]
    rnd_def = [words[i][1] for i in range(0, 3)]
    random.shuffle(rnd_def)
    return rnd_def, true_word


def main():
    token = "149201341:AAGZLccs5ce8RRTIJhBz5Mcvpzf4a-Kuixc"
    bot = telegram.Bot(token = token)
    words = collect_words()
    custom_keyboard = [["1", "2", "3"], ["/start", "/stats"]]
    reply_markup = telegram.ReplyKeyboardMarkup(custom_keyboard)
    rnd_def, true_word = fictionary_game(words)
    rating = dict()
    try:
        update_id = bot.getUpdates()[0].update_id
    except IndexError:
        update_id = None

    while True:
        for update in bot.getUpdates(offset = update_id):
            chat_id = update.message.chat_id
            update_id = update.update_id + 1
            text = update.message.text
            user_name= update.message.chat.first_name
            if user_name not in rating:
                rating[user_name] = 0
            if text == "/start":
                rnd_def, true_word = fictionary_game(words)
                bot.sendMessage(chat_id, "Слово: {0} \n /1 {1} \n /2 {2} \n /3 {3}".format(true_word[0], rnd_def[0], rnd_def[1], rnd_def[2]), reply_markup=reply_markup)
            elif text == "/stats":
                bot.sendMessage(chat_id, "Рейтинг пользователей:")
                for user in rating.keys():
                    bot.sendMessage(chat_id, "{0}: {1}".format(user, rating[user]))
            else:
                try:
                    user_answer = answer(text, rnd_def, true_word)
                    if user_answer == 1:
                        rating[user_name] += 1
                        bot.sendMessage(chat_id, "Вы восхитительны!")
                    else:
                        rating[user_name] -= 1
                        bot.sendMessage(chat_id, "Неправильно. Ответ: {0}".format(true_word[1]))
                    rnd_def, true_word = fictionary_game(words)
                    bot.sendMessage(chat_id, "Слово: {0} \n /1 {1} \n /2 {2} \n /3 {3}".format(true_word[0], rnd_def[0], rnd_def[1], rnd_def[2]))
                except: continue
                
main()
