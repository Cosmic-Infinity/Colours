# Colours

Now customise your Windows 10 task bar colours and looks with this little tool.

😉. Always wanted that clear taskbar? Now you can do it!<br/>
😏. Wanna go back to Windows 7 like translucency? Yes, yes, that's an option.<br/>
😜. Like the Windows 10 fluent Design? that's an option too.<br/>
 :heart_eyes:. And the best part? It's Simple.<br/>

### _It's all about that customisation. It's all about you! Welcome to Colours!_

<br/>


NOTE : This is just an automation tool and the functionality it provides can be done by hand as well, although, that's time taking and slow.

To use it, you'll need :

1. **TranslucentTB** by _Charles Milette_ (https://github.com/TranslucentTB/TranslucentTB/releases/latest)

The Taskbar Blur Levels and Blur Style can be changed from TranslucentTB itself.


<br/>

## **HOW DID WE GET HERE?**


Because TranslucentTB has it's limitations.

 ‣ All advanced controls have to be modified via it's config file.
 
 <img width="322" alt="Screenshot (15)" src="https://user-images.githubusercontent.com/64971616/119177460-fba34800-ba89-11eb-99f0-e8562c1bcafe.png">

 ‣ Once the Style of taskbar is set (say you have Normal blur with an orange colour.)
 
 <img width="269" alt="Annotation 2021-05-21 230340" src="https://user-images.githubusercontent.com/64971616/119176499-cd713880-ba88-11eb-87bc-126cb9d7ddd7.png">
 
  And then you change the wallpaper to, say, something Blue. TranslucentTB CANNOT change the taskbar colour automaticlly, unlike native Windows where you can you leave the "Automatically pick an accent colour from my background" and forget about it.
  For doing so with TranslucentTB you'll have to manually look for a colour of your choice/choose from windows personalization colour palette, THEN find the HEX value of that colour, and THEN manually input that in every colour field of the TranslucentTB config file.
  
 <img width="328" alt="Annotation 2021-05-21 230624" src="https://user-images.githubusercontent.com/64971616/119176830-2f31a280-ba89-11eb-924f-fdb5144aa836.png">
  Doing that is a huge waste of time.
  
  _**This is exactly what "Colours" tries to automate**_
  
  
  <br/>
  
  
  ## **BUT THERE ARE NO SHORTCUTS IN LIFE!**
  
  Well, there are, when you're dealing with computers. Here's what "Colours" does
  
  ◦ Opens settings and checks for currently selected.
  
  ◦ Takes the HEX of that colour.
  
  ◦ Open the TranslucentTB config file and update to the new colour.
  
  ◦ Restart TranslucentTB for changes to take effect.
  
  
  <br/>
  <br/>
  
  ## _Regarding Safety and flagging_
    
 I'm still very new to application developement, and because of my bad programming skills, some security checks might trip here and there. Like :
 
   ‣  Chrome flagging Colours as unsafe. I think it's because of lack of signature or something on my application. I'm still figuring this out and it should get fixed in the future.
 
   ‣  Windows flagging it as unsafe to run. Again, due to lack of signature.
 
 I'm still learning to avoid bad programming practices. I'm afraid till then even some antiviruses might flag it. I can assure you of safety, but you don't have to take my word for it. Feel free to review and compile the code yourself! 🙂 
 Speaking of...
 
 <br/>
 
 ## _Compiling it youself_
 Autoit code is relatively easy to compile. All you need is the autoit compiler which comes with the autoit package. You can get autoit from : https://www.autoitscript.com/
 
1. `Download` the required file from this repository. (either GUI or Non-GUI version)
2. `Download` and `Install` Autoit
3. Open `Compile Script to .exe (x64)` (reccomended) or `Compile Script to .exe (x86)`
4. `Select` the script file which you want to convert to .exe
5. `Select` an icon (optional)
6. Click `Convert`
7. Enjoy!
