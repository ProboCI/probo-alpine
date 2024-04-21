#!/bin/php
<?php
$php_information = explode("\n", `php --version`);
$apache_information = explode("\n", `httpd -v`);
// ----------------------------------------------------------------------------
$php_version = $php_information[0];
$apache_version = $apache_information[0];
$chrome_version = `chromium-browser --version`;
$chromedriver_version = `chromedriver --version`;
$mysql_version = `mysql --version`;
$linux_kernel = `uname -r`;
$solr_version = `/opt/solr/bin/solr version`;
$composer_version = `composer --version`;
$node_version = `node --version`;
$wp_cli_version = `wp --version --allow-root`; 
$acli_version = `acli --version`;
$terminus_version = `terminus --version`;
$bee_version = `bee version`;

print "\n\n";
print "\e[1;33m------------------------------------------\n";
print "Probo.CI - Software Versions Report:\n";
print "Alpine Linux Distribution - v3.18\n";
print "------------------------------------------\e[0m\n";
print $php_version . "\n";
print "Apache: " . $apache_version . "\n";
print $chrome_version;
print $chromedriver_version;
print $mysql_version;
print "Kernel: " . $linux_kernel;
print "SOLR: " . $solr_version;
print $composer_version;
print "Node: " . $node_version;
print "WordPress CLI: " . $wp_cli_version;
print "Pantheon " . $terminus_version;
print "Acquia CLI: " . $acli_version;
print $bee_version;
print "\n\n";
