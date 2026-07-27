.PHONY: all compile local-compile resume togia-bao-resume clean

DOCKER ?= docker
TEXLIVE_IMAGE ?= texlive/texlive:latest
LATEX ?= lualatex
USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)
RESUME_ROOT := resume
RESUME_DIR := $(RESUME_ROOT)/togia-bao-resume
RESUME_MAIN := $(RESUME_ROOT)/togia-bao-resume.tex
RESUME_OUTPUT := $(RESUME_ROOT)/togia-bao-resume.pdf
RESUME_SRCS := $(shell find $(RESUME_DIR) -name '*.tex')

.DEFAULT_GOAL := compile

all: compile

compile:
	$(DOCKER) run --rm \
		--user "$(USER_ID):$(GROUP_ID)" \
		--workdir /doc \
		--volume "$(CURDIR):/doc" \
		$(TEXLIVE_IMAGE) make local-compile

local-compile: $(RESUME_OUTPUT)

resume: compile

togia-bao-resume: compile

$(RESUME_OUTPUT): $(RESUME_MAIN) $(RESUME_SRCS) $(RESUME_ROOT)/awesome-cv.cls
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
