import os

import flake8.checker as f8checker

from flake8_cached.cacher import Cacher


CACHE_PATH = ".cache/flake8"


class FileCheckerCached(f8checker.FileChecker):
    def __init__(self, *, filename, plugins, options):
        super().__init__(filename=filename, plugins=plugins, options=options)
        self.cacher = Cacher(filename, CACHE_PATH)

    def run_checks(self):
        """Cache wrapper of super.run_checks."""
        # handle both cases where cache is enabled/disabled or invalid
        saved = self.cacher.get()
        if saved is not None:
            self.filename, self.results, self.statistics = saved
        else:
            result = super().run_checks()
            self.cacher.save(result)
        return self.filename, self.results, self.statistics


if not os.path.exists(CACHE_PATH):
    os.makedirs(CACHE_PATH)

from flake8 import checker


# patch the class
checker.FileChecker = FileCheckerCached


def main():
    from flake8.main import cli

    cli.main()


if __name__ == "__main__":
    main()
