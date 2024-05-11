build:
	@lua lib/build.lua

dev:
	@DEV_MODE=1 lua lib/build.lua

