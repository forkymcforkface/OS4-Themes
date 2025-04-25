**This is an automated theme downloader/updater for RGB-Pi OS4**  

<img src="https://github.com/user-attachments/assets/e1ac16f6-4a72-4daa-8ebe-7b090907d263" width="15%">
<img src="https://github.com/user-attachments/assets/c3eafe09-831b-4177-a8f2-04f5b6d4fecf" width="15%">
<img src="https://github.com/user-attachments/assets/457741ca-8437-4fbe-bbdb-955fc6b47a07" width="15%">
<img src="https://github.com/user-attachments/assets/a5e98721-6f5e-46bc-9ba4-bab4c413ddac" width="15%">
<img src="https://github.com/user-attachments/assets/bcc0631a-b9da-40b8-ab98-4f97bc75b3bc" width="15%">
<img src="https://github.com/user-attachments/assets/365d919f-4dec-4419-9763-9651fd85618b" width="15%">


Check out how to make themes via the [RGB-Pi Wiki](https://www.mortaca.com/rgb-pi/wiki/index.php?title=OS4_Theme_Creation) and also the [Telegram group](https://t.me/+9b0og61HyixhNjg0)!

-------------------------------------- 

- Download Instructions
  - For USB Download [installer.zip](https://github.com/forkymcforkface/OS4-Themes/raw/refs/heads/main/data/installer/installer.zip) and extract to the root of the OS4 usb drive.
  - For SD Card Download [Update Themes.sh](https://github.com/forkymcforkface/OS4-Themes/blob/main/Update%20Themes.sh) and place in a new folder called 'Theme Manager' within ports.
  - You will now have '/roms/ports/Theme Manager/Update Themes.sh' on your drive
- Scan for games in the OS4 UI, and you will now have a folder Called 'Theme Manager' under 'Ports'
- Go to the 'Theme Manager" folder and run 'Update Themes' which will download the initial theme package (about 1.5GB)
  
  ![Mega Tech_04](https://github.com/user-attachments/assets/2b2fda1b-a4db-43d8-96a4-a900f4d51d94)
- Once the themes download, the OS4 UI will reload.
- In the 'Theme Manager' you will now new folders, you can now install all Themes or install individual themes from the list.
  - While selected over an individual theme press the info button to see a image of the theme
  - New themes/updates can be downloaded by simply running 'Update Themes' again (very quick)
    
  ![Mega Tech_07](https://github.com/user-attachments/assets/df499513-947f-484d-a9e3-66fa5b6411a1) ![Mega Tech_08](https://github.com/user-attachments/assets/e3577284-124e-4ea5-b01c-ee4c0e3b53ee)


-------------------------------------- 
**Tools**

- Enable Random Boot theme does as it says. When RGB-Pi boots it picks a random theme.
- Reboot UI. Quick restart of the UI without a full Pi reboot. For testing only.
- Scraper Update. Updates the games.dat so the scraper images show up properly. This will have to be run anytime you scan for new games.

  ![Mega Tech_07](https://github.com/user-attachments/assets/087ed4b1-7fa3-4d51-b996-524099bd9723)


--------------------------------------
**To add your own themes to this repo**

- Fork this repo
- Optimize your theme files
  - Reduce music size with tools [here](https://www.freeconvert.com/mp3-compressor) or [here](https://github.com/MartinEesmaa/awesome-compopt?tab=readme-ov-file#audio)
  - Reduce gif backgroud size with tools [here](https://ezgif.com/optimize) or [here](https://github.com/MartinEesmaa/awesome-compopt?tab=readme-ov-file#image)
- Compress your core theme folder (no extra folder layers) into a 7z, Zip, Rar (100mb max size) and place it in /data/themes.
  - Example: 'Bubble Bobble - Theme By Kev.7z'
- Copy the [Theme Template](https://github.com/forkymcforkface/OS4-Themes/blob/main/themes/THEME%20TEMPLATE.txt) to /themes and change it to .sh
  - Example: 'Bubble Bobble - Theme.sh'
- Open the template and replace line 5 information with your compressed 7z filename
  - Example *ARCHIVE_FILENAME="themefilename.7z"* to *ARCHIVE_FILENAME="Bubble Bobble - Theme By Kev.7z"*
- add you scraper images into /data/images with the format following the .sh file name with _title_usa appended.
  - Example: Bubble Bobble_title_usa.png
- Submit a pull request for your theme to be added to this repo


