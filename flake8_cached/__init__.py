from pkg_resources import get_distribution, DistributionNotFound

try:
    __version__ = get_distribution('flake8-cached').version
except DistributionNotFound:
    __version__ = '(local)'
