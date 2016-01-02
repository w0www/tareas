# Redmine Login Audit

If you like this plugin, you're welcome to endorse me on CoderWall!
[![endorse](https://api.coderwall.com/martin-denizet/endorsecount.png)](https://coderwall.com/martin-denizet)
You can also visit my blog: http://martin-denizet.com

## Features

* Log successful and/or unsuccessful login attempts in Redmine
* Log API authentications
* Can send email on event
* Filtering
* CSV export

## Roadmap

* Notify by email of failures
* Modify the way records are deleted
* Allow to select visible columns of the table
* Allow to configure "honeypot" users
* Prevent brute-force password guessing

## Compatibility

Tested on Redmine 3.1.x and 3.2.x with Ruby 2.2.3
For Redmine 2.x compatibility, check the 1.x version of the plugin

## Downloading and installing the plugin

First download the plugin using git, open a terminal in your Redmine installation directory:

```git clone git@github.com:martin-denizet/redmine_login_audit.git ./plugins/```

Install the dependencies:

```bundle install```

Run the database migrations:

```RAILS_ENV=production bundle exec rake redmine:plugins:migrate```

The installation is now finished and you will be able to use the plugin after you restart your Redmine instance.


## Configuration

Please check the plugin configuration page before using it.
Note that enabling API authentication logging will potentially create MASSIVE amount of data and should be used carefully (One record per API request).

## Known issues

* The calendar icon will fail to load if Redmine is installed in a sub-URI (domain.com/redmine)

## Credits

* Krzysztof Dryja: Original idea and code contribution
* Martin Denizet: Development
* AlexStein: Code contribution
* Maiko de Andrade: Brasilian Portuguese translation
* Sergei Bershadsky: Russian translation
* R-i-c-k-y: Italian translation
* kotashiratsuka: Japanese translations
* alexandermeindl: German translations

Uses "Silk icon" by Mark James at http://www.famfamfam.com/ licensed under "Creative Commons Attribution 2.5 License"
Uses WiceGrid gem by Yuri Leikind licensed under "MIT License"

## How to contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Donations

As manager of this plugin, I accept donations. It helps me justifying taking time away from lucrative work and family. Many thanks!

<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=XSNA28NKNU76S&lc=FR&item_name=Martin%20Denizet&item_number=redmine_login_audit&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif" alt="[paypal]" /></a>

## License

Copyright (C) 2014, 2015 Martin Denizet <martin.denizet@supinfo.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The Software shall not be used nor made available to TESTTailor or any
individual or organization related or operated by Adarsh Mehta from Germany;
some people just don't deserve free work to be made available to them.
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



