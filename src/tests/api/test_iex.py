import pytest
import requests
from constants import IEX


class TestsIEX(object):
    """Tests for IEX API"""

    api = IEX.API
    symbol = "rht"

    def test_get_all_symbols(self):
        """Retrieve all available symbols"""
        endpoint = f"{self.api}/{'/ref-data/symbols'}"
        symbols = requests.get(endpoint)
        assert symbols.status_code == 200
        print(f"total symbols: {len(symbols.json())}")

    def test_get_price_by_symbol(self):
        """Retrieve stock info by symbol"""
        endpoint = f"{self.api}/stock/{self.symbol}/price"
        price = requests.get(endpoint)
        assert price.status_code == 200
        print(f"{self.symbol} = {price.text}")

    def test_get_quote_by_symbol(self):
        """Retrieve stock quote by symbol"""
        endpoint = f"{self.api}/stock/{self.symbol}/quote"
        quote = requests.get(endpoint)
        assert quote.status_code == 200
        print(f"{self.symbol} = {quote.text}")

    def test_get_market_news_by_symbol(self):
        """Retrieve last 3 market news from an given stock symbol"""
        endpoint = f"{self.api}/stock/{self.symbol}/news/last/3"
        news = requests.get(endpoint)
        assert news.status_code == 200
        for new in news.json():
            print(f"{self.symbol} \n {new}")
