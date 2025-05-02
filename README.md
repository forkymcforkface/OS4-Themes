<div align="center">

**This is an automated theme downloader/updater for [RGB-Pi OS4](https://ko-fi.com/s/4119fb48b8)**  

**75+ themes available!**

</div>


<p align="center">
  <img src="https://github.com/user-attachments/assets/d8b6baeb-f061-4efd-bbfa-3dafd3f5e533" width="15%">
  <img src="https://github.com/user-attachments/assets/bf58f3da-c1f5-4a1b-801a-98020e148cc0" width="15%">
  <img src="https://github.com/user-attachments/assets/fe26559b-843b-4980-9d24-da60a8d56239" width="15%">
  <img src="https://github.com/user-attachments/assets/e5ae8af5-f02f-47ff-ac89-83057bc22c53" width="15%">
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/75946e22-5e9b-4f70-8d9c-9a86ed87a972" width="15%">
  <img src="https://github.com/user-attachments/assets/0f2c6c2e-e6a1-42ff-9d55-fe953458fed1" width="15%">
  <img src="https://github.com/user-attachments/assets/5303d46e-a473-45e9-8114-b933b2c25bc6" width="15%">
  <img src="https://github.com/user-attachments/assets/b99eb1c9-41be-45ff-b3b0-f28a5b0f1e50" width="15%">
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/fb211250-fabf-4b10-bfc5-99c2f910eb2c" width="15%">
  <img src="https://github.com/user-attachments/assets/51eaf920-f92c-4105-b23e-61a00cb421eb" width="15%">
  <img src="https://github.com/user-attachments/assets/f9631686-5226-4d74-a0bd-d9929a332331" width="15%">
  <img src="https://github.com/user-attachments/assets/5ac28213-87d2-4e94-ac4f-cef91e646da2" width="15%">
</p>


--------------------------------------

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


