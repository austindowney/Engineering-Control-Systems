PYTHON ?= python3
TECTONIC ?= tectonic
FIGURE_PIPELINE := scripts/figure_pipeline.py
BOOK_SOURCE := Engineering_Control_Systems.tex
BOOK_OUTPUT := Engineering_Control_Systems.pdf
BOOK_BUILD_DIR := ../build/book

.PHONY: book book-check book-typography-check figure figure-specimens figures \
	check-figures figure-review test-figures test

book:
	@mkdir -p build/book
	cd source_material && \
		$(TECTONIC) $(BOOK_SOURCE) \
		--outdir $(BOOK_BUILD_DIR) --keep-logs

book-check: book
	@test -s build/book/$(BOOK_OUTPUT)
	@pdfinfo build/book/$(BOOK_OUTPUT) | grep -q "^Pages:"

figure:
	@if [ -z "$(FIGURE)" ]; then \
		echo "error: FIGURE is required (for example: make figure FIGURE=tests/specimens/diagram)"; \
		exit 2; \
	fi
	$(PYTHON) $(FIGURE_PIPELINE) figure --figure "$(FIGURE)"

figure-specimens:
	$(PYTHON) $(FIGURE_PIPELINE) figure-specimens

figures:
	$(PYTHON) $(FIGURE_PIPELINE) figures

check-figures:
	$(PYTHON) $(FIGURE_PIPELINE) check-figures

figure-review:
	$(PYTHON) $(FIGURE_PIPELINE) figure-review

test-figures:
	$(PYTHON) $(FIGURE_PIPELINE) test-figures

book-typography-check:
	@mkdir -p build/book-typography
	cd source_material/tests/typography && \
		$(TECTONIC) typography_check.tex \
		--outdir ../../../build/book-typography --keep-logs
	@pdffonts build/book-typography/typography_check.pdf | \
		grep -q "TeXGyreTermes-Regular"
	@pdffonts build/book-typography/typography_check.pdf | \
		grep -q "TeXGyreTermes-Bold"
	@pdffonts build/book-typography/typography_check.pdf | \
		grep -q "TeXGyreTermes-Italic"
	@pdffonts build/book-typography/typography_check.pdf | \
		grep -q "TeXGyreTermes-BoldItalic"
	@pdffonts build/book-typography/typography_check.pdf | \
		grep -q "TeXGyreTermesMath-Regular"

test:
	$(PYTHON) $(FIGURE_PIPELINE) test
