INSTALL_DIR = /usr/local/bin

build: src/**/*.cr
	# Ensure the bin folder exists
	mkdir -p ./bin
	# Build the ked interpreter
	crystal build --release -o ./bin/ked src/ked.cr

.PHONY: ./bin/ked

install: ./bin/ked
	# Copy the created binary to $(INSTALL_DIR)
	cp ./bin/ked $(INSTALL_DIR)

clean:
	# Remove the installed binary if one exists
	rm -f $(INSTALL_DIR)/ked
