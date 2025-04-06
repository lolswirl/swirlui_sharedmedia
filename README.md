# SharedMedia_Template

This project is a template and tutorial for creating a custom media Addon for WeakAuras and other AddOns that use [LibSharedMedia-3.0](https://www.curseforge.com/wow/addons/libsharedmedia-3-0). The project is set up to create a custom media AddOn that can be uploaded to [Wago Addons](https://addons.wago.io/) and be directly embedded in [Wago UI Packs](https://uipacks.wago.io/)

# Instructions

1. Create a new Wago Addon project at [https://addons.wago.io/developers](https://addons.wago.io/developers)

   1. Create a new Wago Developer account if you don't already have one.
   2. Click "New Addon"

      ![Example Image](https://i.imgur.com/x4hg4vb.png)

   3. Click on "Custom Addon Creation" and fill in the form as shown in the screenshot below and click "Create Addon". Pick a name good name for your Addon such as "SharedMedia_YourNameUI" or "YourNameUI_Media" etc. We will use the same name in a later step.

      ![Example Image](https://i.imgur.com/HNy20WY.png)

   4. Take note of the Wago ID of the project. We will use this ID in a later step.

      ![Example Image](https://i.imgur.com/KxpSRbU.png)

2. Download the SharedMedia Template (this repository) [here](https://github.com/Nnoggie/SharedMedia_Template/archive/refs/heads/main.zip)
3. Open the zip and drag the folder SharedMedia_Template-main to your World of Warcraft/Interface/AddOns folder

   ![Example Image](https://i.imgur.com/0CkLTQr.png)

4. Rename the extracted folder SharedMedia_Template-main to the same name you chose for the Addon in step 1.

   ![Example Image](https://i.imgur.com/8NyTdWD.png)

5. Right click the file UpdateMedia.ps1 and select "Run with PowerShell" If Windows blocks the file, click "More info" and then "Run anyway". Follow the steps in the console window. When asked for the Wago ID, enter the ID you got in step 1 and press Enter.

   ![Example Image](https://i.imgur.com/acGWEpe.png)

6. Add your custom media to the appropriate folders that the script created in step 5. You can add textures, sounds, fonts etc.
7. Run UpdateMedia.ps1 again to register the files.
8. The Script has also automatically created a zip file of the Addon for you to distribute. It is located within the directory of your SharedMedia_YourName Addon! Navigate back to the Wago Addons project you created in step 1 and click "New Release"

   ![Example Image](https://i.imgur.com/dnWqihM.png)

9. Upload the zip file that the script created for you and fill in the form as shown in the screenshot below. Label the release as "1.0" and click "Create Version".

   ![Example Image](https://i.imgur.com/PqnLOF2.png)

10. You're done! You can now share your custom media AddOn with others or embed it in your UI Pack via the WagoUI Creator Addon. If you want to update the media, just add more media to the folders and run the bat file again and upload a new release with the new zip file, a new version number like "1.1" and a descriptive changelog. Make sure to only upload the generated zip file and not the entire folder.
