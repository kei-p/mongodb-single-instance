name             'mongodb_on_single_server'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures mongo_on_single_server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "apt", ">= 1.8.2"
depends "yum", ">= 3.0.0"
depends "python", ">= 0.0.0"
depends "mongodb"
