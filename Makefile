TECTONIC ?= tectonic
BOOK_SOURCE := Engineering_Control_Systems.tex
BOOK_OUTPUT := Engineering_Control_Systems.pdf
BOOK_BUILD_DIR := ../build/book

.PHONY: book book-check book-typography-check

book:
	@mkdir -p build/book
	cd source_material && \
		$(TECTONIC) $(BOOK_SOURCE) \
		--outdir $(BOOK_BUILD_DIR) --keep-logs

book-check: book
	@test -s build/book/$(BOOK_OUTPUT)
	@pdfinfo build/book/$(BOOK_OUTPUT) | grep -q "^Pages:"

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
