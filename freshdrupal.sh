# The site name should be passed in as a first parameter to the shell script.
siteName=$1

# Drop the database with the specified name if it exists
mysql -u "root" -e "DROP DATABASE $siteName;"

# Create a database with the same name as the site name.
mysql -u "root" -e "CREATE DATABASE $siteName;"

# Download drupal and rename the project folder to the site name. ###
# --drupal-project-rename creates errors so for now as a workaround just hardcode the latest drupal version.
drush pm-download drupal-7 --drupal-project-rename=$siteName

# Go to the root of the the site so that the drush commands could apply there.
cd $siteName

# Create modules directory structure
mkdir sites/all/modules/contrib
mkdir sites/all/modules/custom
mkdir sites/all/modules/features

# Initialize the site install, with user:pass = admin:admin
drush site-install standard --account-name=admin --account-pass=admin --db-url=mysql://root:@localhost/$siteName --site-name=$siteName -y

# Disable and uninstall some modules, activated by default.
drush pm-disable toolbar overlay -y
drush pm-uninstall toolbar overlay -y

# Download a bunch of useful modules, that would be used on almost any site.
drush pm-download ctools entity entityreference devel views admin_menu token libraries module_filter rules search_krumo features strongarm diff fpa -y

# Enable those modules.
drush pm-enable page_manager entityreference devel devel_generate views_ui admin_menu_toolbar token libraries module_filter rules_admin search_krumo features strongarm diff fpa -y
