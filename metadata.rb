name             "otrs"
maintainer       "TYPO3 Association"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache 2.0"
description      "Deploy and configure OTRS (Open Ticket Request System)."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       "https://github.com/TYPO3-cookbooks/otrs" if respond_to?(:source_url)

version          "2.1.0"

supports         "debian"

depends          "t3-mysql",        "~> 0.1.3"

depends          "database",        "= 1.3.12"
depends          "apache2"                     # tested with 3.2.2
depends          "build-essential"             # tested with 2.0.6
depends          "cron"                        # tested with 1.4.3
depends          "perl"                        # tested with 2.0.0
