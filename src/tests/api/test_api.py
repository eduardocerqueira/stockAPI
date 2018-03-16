import pytest
from api.iex import IEX


class TestIEXAPI(object):
    """Tests for API class"""

    iex = IEX()
    symbol = "rht"

    def test_get_market_news_by_symbol(self):
        """Retrieve market news from an given stock symbol"""
        news = self.iex.get_market_news_by_symbol(self.symbol)
        assert len(news) > 0
        print(news)

    def test_get_last_n_market_news_by_symbol(self):
        """Retrieve market news from an given stock symbol"""
        news = self.iex.get_market_news_by_symbol(self.symbol, last=1)
        assert len(news) > 0
        print(news)
