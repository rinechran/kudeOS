all : BootLoader Disk.img

BootLoader:
	@echo
	@echo ==================== Build BootLoader========================
	@echo

	make -C 00.BootLoader

	@echo
	@echo ==================== Build Complete========================
	@echo

Disk.img:00.BootLoader/bootLoader.bin
	@echo
	@echo ==================== Disk Image Build ========================
	@echo

	cp 00.BootLoader/bootLoader.bin Disk.img
 
	@echo
	@echo ==================== All Build ========================
	@echo

clean:
	make -C 00.BootLoader clean
	rm -f Disk.img