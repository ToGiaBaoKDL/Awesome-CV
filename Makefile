.PHONY: all compile compile-work-description local-compile resume togia-bao-resume tinytex-install clean

TINY_TEX_VERSION := 2026.09
TINY_TEX_PARENT := $(CURDIR)/.tools
TINY_TEX_ROOT := $(TINY_TEX_PARENT)/.TinyTeX
TINY_TEX_BIN := $(TINY_TEX_ROOT)/bin/x86_64-linux
TINY_TEX_ARCHIVE := TinyTeX-1-linux-x86_64-v$(TINY_TEX_VERSION).tar.xz
TINY_TEX_URL := https://github.com/rstudio/tinytex-releases/releases/download/v$(TINY_TEX_VERSION)/$(TINY_TEX_ARCHIVE)
TINY_TEX_SHA256 := cf9a4d19742eeb6d54a3de91fb5df071360f23877cafa5b39893421b32ca6295
TINY_TEX_STAMP := $(TINY_TEX_PARENT)/.tinytex-$(TINY_TEX_VERSION)-ready
TINY_TEX_PACKAGES := accsupp bookmark enumitem etoolbox fancyhdr fontawesome6 fontspec geometry hyperref ifmtarg iftex luatexbase parskip ragged2e roboto setspace sourcesans tcolorbox tikzfill tools unicode-math xcolor xifthen xstring
LATEX ?= $(TINY_TEX_BIN)/lualatex
RESUME_ROOT := resume
RESUME_DIR := $(RESUME_ROOT)/togia-bao-resume
RESUME_MAIN := $(RESUME_ROOT)/togia-bao-resume.tex
RESUME_OUTPUT := $(RESUME_ROOT)/togia-bao-resume.pdf
RESUME_SRCS := $(shell find $(RESUME_DIR) -name '*.tex')

.DEFAULT_GOAL := compile

all: compile

compile: $(RESUME_OUTPUT)

compile-work-description: $(RESUME_ROOT)/togia-bao-work-description.pdf

$(RESUME_ROOT)/togia-bao-work-description.pdf: $(TINY_TEX_STAMP) $(RESUME_ROOT)/togia-bao-work-description.tex $(RESUME_ROOT)/awesome-cv.cls
	$(LATEX) -interaction=nonstopmode -halt-on-error -file-line-error \
		-output-directory=$(RESUME_ROOT) $(RESUME_ROOT)/togia-bao-work-description.tex

local-compile: $(RESUME_OUTPUT)

resume: compile

togia-bao-resume: compile

tinytex-install: $(TINY_TEX_STAMP)

$(TINY_TEX_STAMP):
	mkdir -p $(TINY_TEX_PARENT)
	curl -fsSL $(TINY_TEX_URL) -o $(TINY_TEX_PARENT)/$(TINY_TEX_ARCHIVE)
	printf '%s  %s\n' $(TINY_TEX_SHA256) $(TINY_TEX_PARENT)/$(TINY_TEX_ARCHIVE) | sha256sum --check -
	tar -xf $(TINY_TEX_PARENT)/$(TINY_TEX_ARCHIVE) -C $(TINY_TEX_PARENT)
	$(TINY_TEX_BIN)/tlmgr install $(TINY_TEX_PACKAGES)
	rm -f $(TINY_TEX_PARENT)/$(TINY_TEX_ARCHIVE)
	touch $(TINY_TEX_STAMP)

$(RESUME_OUTPUT): $(TINY_TEX_STAMP) $(RESUME_MAIN) $(RESUME_SRCS) $(RESUME_ROOT)/awesome-cv.cls
	$(LATEX) -interaction=nonstopmode -halt-on-error -file-line-error \
		-output-directory=$(RESUME_ROOT) $(RESUME_MAIN)

clean:
	rm -f \
		$(RESUME_ROOT)/togia-bao-resume.aux \
		$(RESUME_ROOT)/togia-bao-resume.fdb_latexmk \
		$(RESUME_ROOT)/togia-bao-resume.fls \
		$(RESUME_ROOT)/togia-bao-resume.log \
		$(RESUME_ROOT)/togia-bao-resume.out \
		$(RESUME_ROOT)/togia-bao-resume.run.xml \
		$(RESUME_ROOT)/togia-bao-resume.toc
