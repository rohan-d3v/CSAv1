CSA v1.0.0

For auto generated Documentation for auto rails lib generation refer: doc/app

Thank you to Aaron Neyer for help with understanding rails database backend Implementation. 
He was my senior and I have worked with him in the past to implement rails front end applications

UI, Calculator, Notes: Elizabeth 
Backend, webchat, admin features, login/user access: Rohan
Forum: Sasha
Amazon Alexa App: Ashley

Usage instructions
 1) Yigit (yxk38) now has access to admin functions, all buttons should be available.
 2) Andy will need to be registered in order to use the web chat to do this:
 	- Go to administrator, Manage students
 	- Click on Regisster using Case ID
 	- Register Andy
 	- You can then edit Andy's profile to make into admin if needed
 3) All buttons are now functional. All features will be available to the admin
 4) The admin has to register him/herself before the webchat is accessible
 5) Student/Common Buttons available
  - Home: index
  - Directory: Names with auto email on button click
  - Assignments: View all Assignments
  - Reservations: On button click to ksl student reservation system. KSL security does not allow reservation using embed
  - Syllabus: View syllabus as posted by teacher/faculty
 6) Webapps available
  - Webchat: Coded from scratch using php and html. refer public/chat
  - Calculator: Coded from scratch: Elizabeth. Refer public/calculator
  - Notes: Coded from Scratch: Elizabeth. Refer public/notes
  - Forum: Coded from scratch: Sasha. Refer Sasha's repo
  - Practice: Coded from scratch: Ashley. Refer Ashley's Repo
 7) Administrator Buttons available
  - Manage Courses: Manage Courses including Range/ start to End. Currently Ssupports a 20 day max
  - Manage Students: Manage registered students. Please register yourself to use the webchat
  - Course Tools: Mass emails
  - Manage Assignments: Manage all assignments, including delete
  - View Messages: View messages frorm contact admins page
 8) Contact Admins

If you would like to deploy your own copy: 
Please note that this is deployment as far as I remember
it might be different, if you run into errors, email me at rxr353@case.edu and I will get backk to you ASAP

 1) Install apache2
 2) Install php5 in apache2
 3) Install rvm
 4) Install ruby -v 2.0.0
 5) Install rails
 6) Git clone this repo to /var/www/
 7) sudo nano /etc/apache2/apache2.conf
   - Insert this after directory </var/www>
   -    # Tell Apache and Passenger where your app's 'public' directo$
    DocumentRoot /var/www/cwru-csa-source/public

    PassengerRuby /home/rohan/.rvm/gems/ruby-2.0.0-p648/wrappers/ruby

    # Relax Apache security settings
    <Directory /var/www/cwru-csa-source/public>
      Allow from all
      Options -MultiViews
      # Uncomment this if you're on Apache > 2.4:
      Require all granted
    </Directory>

   -Insert this at the bottom of the same conf file
   <VirtualHost *:80>

    # Tell Apache and Passenger where your app's 'public' directory is
    DocumentRoot /var/www/cwru-csa-source/public

    PassengerRuby /home/rohan/.rvm/gems/ruby-2.0.0-p648/wrappers/ruby

    # Relax Apache security settings
    <Directory /var/www/cwru-csa-source/public>
      Allow from all
      Options -MultiViews
      # Uncomment this if you're on Apache > 2.4:
      Require all granted
    </Directory>
    </VirtualHost>
    
    -Save and exit
8) cd sites-enabled
9) sudo nano 000-default.conf
 -Copy paste this and replace the .conf content

 <VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.

        ServerAdmin rxr353@case.edu
        DocumentRoot /var/www/cwru-csa-source/public
        RailsEnv development

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Directory "/var/www/cwru-csa-source/public">
         Options FollowSymLinks
         Require all granted
        </Directory>

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
 
 10) sudo apache2ctl -k graceful
 11) cd /var/www/cwru-csa-source
 12) bundle install 
 13) sudo nano db/database.yml
 14) Replace with your use
 15) bundle install
 16) rake db:schema:load

 Your app should now be live
