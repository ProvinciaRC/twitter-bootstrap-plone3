#BOOTSTRAP = ./docs/assets/css/bootstrap.css
#BOOTSTRAP_LESS = ./less/bootstrap.less
#BOOTSTRAP_RESPONSIVE = ./docs/assets/css/bootstrap-responsive.css
#BOOTSTRAP_RESPONSIVE_LESS = ./less/responsive.less

BOOTSTRAP_BASE = ./less/twitter-bootstrap-2.1.1
BOOTSTRAP_JS   = BOOTSTRAP_BASE/js
BOOTSTRAP_IMG  = BOOTSTRAP_BASE/img
BOOTSTRAP_LESS = ${BOOTSTRAP_BASE}/less/bootstrap.less
BOOTSTRAP_RESPONSIVE_LESS = ${BOOTSTRAP_BASE}/less/responsive.less
BOOTSTRAP_DESTINATION     = bootstrap

ASSETS_DESTINATION = assets
ASSETS_LESS        = less/styles.less
ASSETS_JS          = js
ASSETS_IMG         = img



#
# RUN JSHINT & QUNIT TESTS IN PHANTOMJS
#

test:
	jshint ${BOOTSTRAP_JS}*.js --config ${BOOTSTRAP_JS}.jshintrc
	jshint ${BOOTSTRAP_JS}tests/unit/*.js --config ${BOOTSTRAP_JS}.jshintrc
	node ${BOOTSTRAP_JS}tests/server.js &
	phantomjs ${BOOTSTRAP_JS}tests/phantom.js "http://localhost:3000/js/tests"
	kill -9 `cat ${BOOTSTRAP_JS}tests/pid.txt`
	rm ${BOOTSTRAP_JS}tests/pid.txt

#
# CLEANS THE ROOT DIRECTORY OF PRIOR BUILDS
#

clean:
	rm -r bootstrap

#
# BUILD SIMPLE BOOTSTRAP DIRECTORY
# recess & uglifyjs are required
#

bootstrap:
	mkdir -p ${BOOTSTRAP_DESTINATION}img
	mkdir -p ${BOOTSTRAP_DESTINATION}css
	mkdir -p ${BOOTSTRAP_DESTINATION}js
	cp ${BOOTSTRAP_IMG}* ${BOOTSTRAP_DESTINATION}img/
	recess --compile ${BOOTSTRAP_LESS} > ${BOOTSTRAP_DESTINATION}css/bootstrap.css
	recess --compress ${BOOTSTRAP_LESS} > ${BOOTSTRAP_DESTINATION}css/bootstrap.min.css
	recess --compile ${BOOTSTRAP_RESPONSIVE_LESS} > ${BOOTSTRAP_DESTINATION}css/bootstrap-responsive.css
	recess --compress ${BOOTSTRAP_RESPONSIVE_LESS} > ${BOOTSTRAP_DESTINATION}css/bootstrap-responsive.min.css
	cat ${BOOTSTRAP_JS}bootstrap-transition.js ${BOOTSTRAP_JS}bootstrap-alert.js ${BOOTSTRAP_JS}bootstrap-button.js ${BOOTSTRAP_JS}bootstrap-carousel.js ${BOOTSTRAP_JS}bootstrap-collapse.js ${BOOTSTRAP_JS}bootstrap-dropdown.js ${BOOTSTRAP_JS}bootstrap-modal.js ${BOOTSTRAP_JS}bootstrap-tooltip.js ${BOOTSTRAP_JS}bootstrap-popover.js ${BOOTSTRAP_JS}bootstrap-scrollspy.js ${BOOTSTRAP_JS}bootstrap-tab.js ${BOOTSTRAP_JS}bootstrap-typeahead.js ${BOOTSTRAP_JS}bootstrap-affix.js > ${BOOTSTRAP_DESTINATION}js/bootstrap.js
	uglifyjs -nc ${BOOTSTRAP_DESTINATION}js/bootstrap.js > ${BOOTSTRAP_DESTINATION}js/bootstrap.min.tmp.js
	echo "/*!\n* Bootstrap.js by @fat & @mdo\n* Copyright 2012 Twitter, Inc.\n* http://www.apache.org/licenses/LICENSE-2.0.txt\n*/" > ${BOOTSTRAP_DESTINATION}js/copyright.js
	cat ${BOOTSTRAP_DESTINATION}js/copyright.js ${BOOTSTRAP_DESTINATION}js/bootstrap.min.tmp.js > ${BOOTSTRAP_DESTINATION}js/bootstrap.min.js
	rm ${BOOTSTRAP_DESTINATION}js/copyright.js ${BOOTSTRAP_DESTINATION}js/bootstrap.min.tmp.js


assets:
	mkdir -p ${ASSETS_DESTINATION}img
	mkdir -p ${ASSETS_DESTINATION}css
	mkdir -p ${ASSETS_DESTINATION}js
	cp ${BOOTSTRAP_IMG}* ${ASSETS_DESTINATION}img/
	cp ${ASSETS_IMG}*    ${ASSETS_DESTINATION}img/
	recess --compile ${ASSETS_LESS} > ${ASSETS_DESTINATION}css/bootstrap.css
	recess --compress ${ASSETS_LESS} > ${ASSETS_DESTINATION}css/bootstrap.min.css

	cat ${BOOTSTRAP_JS}bootstrap-transition.js ${BOOTSTRAP_JS}bootstrap-alert.js ${BOOTSTRAP_JS}bootstrap-button.js ${BOOTSTRAP_JS}bootstrap-carousel.js ${BOOTSTRAP_JS}bootstrap-collapse.js ${BOOTSTRAP_JS}bootstrap-dropdown.js ${BOOTSTRAP_JS}bootstrap-modal.js ${BOOTSTRAP_JS}bootstrap-tooltip.js ${BOOTSTRAP_JS}bootstrap-popover.js ${BOOTSTRAP_JS}bootstrap-scrollspy.js ${BOOTSTRAP_JS}bootstrap-tab.js ${BOOTSTRAP_JS}bootstrap-typeahead.js ${BOOTSTRAP_JS}bootstrap-affix.js > ${ASSETS_DESTINATION}js/bootstrap.js
	uglifyjs -nc ${ASSETS_DESTINATION}js/bootstrap.js > ${ASSETS_DESTINATION}js/bootstrap.min.tmp.js
	echo "/*!\n* Bootstrap.js by @fat & @mdo\n* Copyright 2012 Twitter, Inc.\n* http://www.apache.org/licenses/LICENSE-2.0.txt\n*/" > ${ASSETS_DESTINATION}js/copyright.js
	cat ${ASSETS_DESTINATION}js/copyright.js ${ASSETS_DESTINATION}js/bootstrap.min.tmp.js > ${ASSETS_DESTINATION}js/bootstrap.min.js
	rm ${ASSETS_DESTINATION}js/copyright.js ${ASSETS_DESTINATION}js/bootstrap.min.tmp.js

	cp ${ASSETS_JS}*    ${ASSETS_DESTINATION}js/


#
# WATCH LESS FILES
#

watch:
	echo "Watching less files..."; \
	watchr -e "watch('less/.*\.less') { system 'make' }"
