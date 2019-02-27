all : BootLoader Disk.img

BootLoader:
	@echo
	@echo ==================== Build BootLoader========================
	@echo

	make -C kude.BootLoader

	@echo
	@echo ==================== Build Complete========================
	@echo

Disk.img:kude.BootLoader/bootLoader.bin
	@echo
	@echo ==================== Disk Image Build ========================
	@echo

	cp kude.BootLoader/bootLoader.bin Disk.img
 
	@echo
	@echo ==================== All Build ========================
	@echo

clean:
	make -C kude.BootLoader clean
	rm -f Disk.img