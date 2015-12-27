name             "otrs"
maintainer       "TYPO3 Association"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache 2.0"
description      "Deploy and configure OTRS (Open Ticket Request System)."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       "https://github.com/TYPO3-cookbooks/otrs" if respond_to?(:source_url)

version          "1.2.5"

supports         "debian"

depends          "apache2"                     # tested with 3.1.0
depends          "build-essential"             # tested with 2.0.6
depends          "cron"                        # tested with 1.4.3
depends          "database",        "~> 2.3.1" # tested with 2.3.1
depends          "mysql",           "< 6.0"    # tested with 5.6.3
depends          "perl"                        # tested with 2.0.0
