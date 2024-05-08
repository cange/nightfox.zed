build:
	@lua lib/build.lua  # Run lua script for building in normal mode

dev:
	@DEV_MODE=1 lua lib/build.lua  # Set DEV_MODE environment variable and run script
