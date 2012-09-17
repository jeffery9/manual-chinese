# Makefile for the Neo4j Manual in French.
#
# Note: requires mvn to unpack some stuff first.

PROJECTNAME      = manual-chinese
BUILDDIR         = $(CURDIR)/target
TOOLSDIR         = $(BUILDDIR)/tools
SRCDIR           = $(CURDIR)
RESOURCEDIR      = $(BUILDDIR)/classes
SRCFILE          = $(SRCDIR)/$(PROJECTNAME).asciidoc
IMGDIR           = $(SRCDIR)/images
IMGTARGETDIR     = $(BUILDDIR)/classes/images
CSSDIR           = $(TOOLSDIR)/main/resources/css
JSDIR            = $(TOOLSDIR)/main/resources/js
CONFDIR          = $(SRCDIR)/conf
TOOLSCONFDIR     = $(TOOLSDIR)/main/resources/conf
DOCBOOKFILE      = $(BUILDDIR)/$(PROJECTNAME)-shortinfo.xml
DOCBOOKFILEHTML  = $(BUILDDIR)/$(PROJECTNAME)-html.xml
FOPDIR           = $(BUILDDIR)/pdf
FOPFILE          = $(FOPDIR)/$(PROJECTNAME).fo
FOPPDF           = $(FOPDIR)/$(PROJECTNAME).pdf
TEXTWIDTH        = 80
TEXTDIR          = $(BUILDDIR)/text
TEXTFILE         = $(TEXTDIR)/$(PROJECTNAME).txt
TEXTHTMLFILE     = $(TEXTFILE).html
SINGLEHTMLDIR    = $(BUILDDIR)/html
SINGLEHTMLFILE   = $(SINGLEHTMLDIR)/index.html
ANNOTATEDDIR     = $(BUILDDIR)/annotated
ANNOTATEDFILE    = $(HTMLDIR)/$(PROJECTNAME).html
CHUNKEDHTMLDIR   = $(BUILDDIR)/chunked
CHUNKEDOFFLINEHTMLDIR = $(BUILDDIR)/chunked-offline
CHUNKEDTARGET     = $(BUILDDIR)/$(PROJECTNAME).chunked
CHUNKEDSHORTINFOTARGET = $(BUILDDIR)/$(PROJECTNAME)-html.chunked
MANPAGES         = $(BUILDDIR)/manpages
UPGRADE          = $(BUILDDIR)/upgrade
EXTENSIONSRC     = $(TOOLSDIR)/bin/extensions
EXTENSIONDEST    = $(HOME)/.asciidoc
ASCIDOCDIR       = $(TOOLSDIR)/bin/asciidoc
ASCIIDOC         = $(ASCIDOCDIR)/asciidoc.py
A2X              = $(ASCIDOCDIR)/a2x.py

SCRIPTDIR        = $(CURDIR)/conf/build
CONFDIR          = $(CURDIR)/conf

ifdef VERBOSE
	V = -v
	VA = VERBOSE=1
endif

ifdef KEEP
	K = -k
	KA = KEEP=1
endif

ifdef VERSION
	VERSNUM =$(VERSION)
else
	VERSNUM =-neo4j-version
endif

ifdef IMPORTDIR
	IMPDIR = --attribute importdir="$(IMPORTDIR)"
else
	IMPDIR = --attribute importdir="$(BUILDDIR)/docs"
	IMPORTDIR = "$(BUILDDIR)/docs"
endif

ifneq (,$(findstring SNAPSHOT,$(VERSNUM)))
	GITVERSNUM =master
else
	GITVERSNUM =$(VERSION)
endif

ifndef VERSION
	GITVERSNUM =master
endif

VERS =  --attribute neo4j-version=$(VERSNUM)

GITVERS = --attribute gitversion=$(GITVERSNUM)

ASCIIDOC_FLAGS = $(V) $(VERS) $(GITVERS) $(IMPDIR)

A2X_FLAGS = $(K) $(ASCIIDOC_FLAGS)

.PHONY: preview help

help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo "  preview     to generate a preview"
	@echo "For verbose output, use 'VERBOSE=1'".
	@echo "To keep temporary files, use 'KEEP=1'".
	@echo "To set the version, use 'VERSION=[the version]'".
	@echo "To set the importdir, use 'IMPORTDIR=[the importdir]'".

#dist: installfilter offline-html html html-check text text-check pdf manpages upgrade cleanup yearcheck

preview: initialize installextensions simple-asciidoc
dist: initialize installextensions installfilter offline-html

cleanup:
	#
	#
	# Cleaning up.
	#
	#
ifndef KEEP
	rm -f "$(DOCBOOKFILE)"
	rm -f "$(BUILDDIR)/"*.xml
	rm -f "$(ANNOTATEDDIR)/"*.xml
	rm -f "$(FOPDIR)/images"
	rm -f "$(FOPFILE)"
	rm -f "$(UPGRADE)/"*.xml
	rm -f "$(UPGRADE)/"*.html
endif

initialize:
	#
	#
	# Setting correct file permissions.
	#
	#
	find $(TOOLSDIR) \( -path '*.py' -o -path '*.sh' \) -exec chmod 0755 {} \;

installextensions: initialize
	#
	#
	# Installing asciidoc extensions.
	#
	#
	mkdir -p $(EXTENSIONDEST)
	cp -fr "$(EXTENSIONSRC)/"* $(EXTENSIONDEST)
	cp "$(CONFDIR)/queryresult.py" "$(EXTENSIONDEST)/filters/queryresult/"

simple-asciidoc: initialize installextensions
	#
	#
	# Building HTML straight from the AsciiDoc sources.
	#
	#
	mkdir -p "$(SINGLEHTMLDIR)/images"
	mkdir -p "$(SINGLEHTMLDIR)/css"
	mkdir -p "$(SINGLEHTMLDIR)/js"
	"$(ASCIIDOC)" $(ASCIIDOC_FLAGS) --conf-file="$(TOOLSCONFDIR)/asciidoc.conf"  --conf-file="$(CONFDIR)/asciidoc.conf" --attribute lang=zh_cn --attribute docinfo1 --attribute toc --out-file "$(SINGLEHTMLFILE)" "$(SRCFILE)"
	rsync -ru "$(IMGTARGETDIR)/"* "$(SINGLEHTMLDIR)/images"
	rsync -ru "$(CSSDIR)/"* "$(SINGLEHTMLDIR)/css"
	rsync -ru "$(JSDIR)/"* "$(SINGLEHTMLDIR)/js"












#------------------------------------------------------------------------------
installfilter:
	#
	#
	# Installing asciidoc filters.
	#
	#
	cp "$(CONFDIR)/lang-zh_cn.conf" "$(TOOLSDIR)/bin/asciidoc/"
copyimages:
	#
	#
	# Copying images from source projects.
	#
	#
	"$(SCRIPTDIR)/copy-images.sh" "$(IMPORTDIR)" "$(IMGDIR)"

manpages:
	#
	#
	# Building manpages.
	#
	#
	mkdir -p "$(MANPAGES)"
	#"$(SCRIPTDIR)/manpage.sh" "$(V)" "$(MANPAGES)" "$(IMPORTDIR)" "$(A2X)" "$(CONFDIR)" "neo4j server" "neo4j-shell shell" "neo4j-coordinator server" "neo4j-coordinator-shell server" "neo4j-backup backup"
	# clean up
	#mkdir -p "$(ANNOTATEDDIR)"
	#cp "$(MANPAGES)/"*.xml "$(ANNOTATEDDIR)"
	#mv "$(MANPAGES)/"*.xml "$(BUILDDIR)"
	#rm -rf "$(MANPAGES)/"*.html

docbook-html:  manpages copyimages
	#
	#
	# Building docbook output with short info for html outputs.
	# Checking for missing include files.
	# Checking DocBook validity.
	#
	#
	mkdir -p "$(BUILDDIR)"
	"$(ASCIIDOC)" $(ASCIIDOC_FLAGS) --backend docbook --attribute lang=zh_cn --attribute docinfo1 --attribute console=1 --doctype book --conf-file="$(CONFDIR)/asciidoc.conf" --conf-file="$(CONFDIR)/docbook45.conf" --conf-file="$(CONFDIR)/linkedimages.conf" --out-file "$(DOCBOOKFILEHTML)" "$(SRCFILE)" 2>&1 | "$(SCRIPTDIR)/outputcheck-includefiles.sh"
	xmllint --nonet --noout --xinclude --postvalid "$(DOCBOOKFILEHTML)"

offline-html:  manpages copyimages docbook-html
	#
	#
	# Building html output for offline use.
	#
	#
	"$(A2X)" $(V) -L -f chunked -D "$(BUILDDIR)" --xsl-file="$(CONFDIR)/chunked-offline.xsl" -r "$(IMGTARGETDIR)" -r "$(CSSDIR)" --xsltproc-opts "--stringparam admon.graphics 1" --xsltproc-opts "--xinclude" --xsltproc-opts "--stringparam chunk.section.depth 1" --xsltproc-opts "--stringparam toc.section.depth 1" "$(DOCBOOKFILEHTML)"
	rm -rf "$(CHUNKEDOFFLINEHTMLDIR)"
	mv "$(CHUNKEDSHORTINFOTARGET)" "$(CHUNKEDOFFLINEHTMLDIR)"
	cp -fr "$(JSDIR)" "$(CHUNKEDOFFLINEHTMLDIR)/js"
	cp -fr "$(CSSDIR)/"* "$(CHUNKEDOFFLINEHTMLDIR)/css/"
	cp -fr "$(IMGTARGETDIR)/"*.png "$(CHUNKEDOFFLINEHTMLDIR)/images"

	cp -fr "$(CONFDIR)/neo.css" "$(CHUNKEDOFFLINEHTMLDIR)/css/neo.css"
	cp -fr "$(RESOURCEDIR)/js/version.js" "$(CHUNKEDOFFLINEHTMLDIR)/js/version.js"		
	

