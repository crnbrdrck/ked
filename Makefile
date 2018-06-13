INSTALL_DIR = /usr/local/bin

build: src/**/*.cr
	# Build the ked interpreter
	crystal build --release -o ked src/ked.cr

.PHONY: ked

install: ked
	# Copy the created binary to $(INSTALL_DIR)
	cp ./ked $(INSTALL_DIR)

clean:
	# Remove the installed binary if one exists
	rm -f $(INSTALL_DIR)/ked
