#!/usr/bin/env ruby

require 'aws-sdk'
require 'highline/import'
require 'net-ldap'
require 'onelogin/ruby-saml'


# ***************************************************************
# BEGIN: functions

# identity provider initialization
def idpinit
	print "creating OneLogin Authrequest\n"
	request = OneLogin::RubySaml::Authrequest.new
	return request.create(saml_settings)
end

# SAML settings
def saml_settings
	idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
	settings = idp_metadata_parser.parse_remote("https://signin.aws.amazon.com/static/saml-metadata.xml")
	settings.assertion_consumer_service_url 	= "https://signin.aws.amazon.com/saml"
	settings.issuer 							= "https://signin.aws.amazon.com/static/saml-metadata.xml"
	settings.idp_sso_target_url					= "https://devsso.vubiquity.com/adfs/ls/IdpInitiatedSignOn.aspx"
	settings
end

# the redirect to IDP from initialization point
def redirect_to
	print "redirect to"
end

# END: functions 
# ***************************************************************


## log file
OneLogin::RubySaml::Logging.logger = Logger.new(File.open('./ruby-saml.log', 'w'))


# ***************************************************************
# BEGIN: configuration
#
# AWS/ADFS/SAML Federation vars
awsconfigfile = '~/.aws/credentials'
ENV['AWS_REGION'] = "us-west-2"


# adfs
# URL overview -> https://msdn.microsoft.com/en-us/library/ee895361.aspx
adfs = "https://devsso.vubiquity.com/adfs/ls/IdpInitiatedSignOn.aspx"

iam_dev_api_arn = "arn:aws:iam:us-west-2:394239475846:group/Service_Accounts"

# relaying party federation metadata url
aws_metadataurl = "https://signin.aws.amazon.com/static/saml-metadata.xml"
#
# END: configuration
# ***************************************************************


# get the username and password
print "enter username: " 
username = gets.chomp 

print "enter password: " 
password = ask(" ") { |q| q.echo = "x" }

# eventually we'll want to check for a cached access file and prompt the user
# to enter their credentials if it doesn't exist

# ***************************************************************
# steps, ordered by number
#
#
# 1) request target resource

# 2) discover the idp
idp = idpinit()

# 3) redirect to SSO services

# 4) request SSL services
# 5) respond with SAML authnrequest
# 6) redirect to assertion consumer service
# 7) request assertion consumer service
# 8) request artifact resolution service
# 9) respond with SAML assertion
# 10) redirect to target resource
# 11) request target resource 
# 12) respond with requested resource


