import requests
from constants import IEXConfig


class IEX(object):

    api = IEXConfig.ENDPOINT

    def get_market_news_by_symbol(self, symbol, last=None):
        """
            Retrieve last marketing news from given stock symbol

            :param symbol (str) valid stock symbol
            :param last (int) range 1-50 to retrieve news for given stock symbol
            :return (list) news in a json format
        """
        if last:
            news_range = f"news/last/{last}"
        else:
            news_range = f"news"

        endpoint = f"{self.api}/stock/{symbol}/{news_range}"
        news = requests.get(endpoint)
        if news.status_code == 200 and len(news.content) > 0:
            return news.json()

    def get_market_wide_news(self, last=None):
        """
            Retrieve marketing wide news

            :param last (int) range 1-50 to retrieve news for given stock symbol
            :return (list) news in a json format
        """
        if last:
            news_range = f"news/last/{last}"
        else:
            news_range = f"news"

        endpoint = f"{self.api}/stock/market/{news_range}"
        news = requests.get(endpoint)
        if news.status_code == 200 and len(news.content) > 0:
            return news.json()

    def get_price_by_symbol(self, symbol):
        """
            Retrieve stock info by symbol

            :param symbol (str) valid stock symbol
            :return (str) current price
        """
        endpoint = f"{self.api}/stock/{symbol}/price"
        price = requests.get(endpoint)
        if price.status_code == 200:
            return price.text
