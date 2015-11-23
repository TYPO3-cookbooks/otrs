name             "otrs"
maintainer       "TYPO3 Association"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache 2.0"
description      "Deploy and configure OTRS (Open Ticket Request System)."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       "https://github.com/TYPO3-cookbooks/otrs" if respond_to?(:source_url)

version          "1.2.1"

supports         "debian"

depends          "apache2", "= 3.1.0"
depends          "build-essential", "= 2.0.6"
depends          "cron", "= 1.4.3"
depends          "database", "= 2.3.1"
depends          "mysql", "= 5.6.3"
depends          "perl", "= 1.2.4"
