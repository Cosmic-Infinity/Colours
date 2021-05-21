# Colours

Now customise your Windows 10 task bar colours and looks with this little tool.

😉. Always wanted that clear taskbar? Now you can do it!<br/>
😏. Wanna go back to Windows 7 like translucency? Yes, yes, that's an option.<br/>
😜. Like the Windows 10 fluent Design? that's an option too.<br/>
. And the best part? It's all automated.<br/>

_It's all about that coutomisation. It's all about you! Welcome to Colours!_


NOTE : This is just an automation tool and the functionality it provides can be done by hand as well, although, that's time taking and slow.

To use it, you'll need :

1. **TranslucentTB** by _Charles Milette_ (https://github.com/TranslucentTB/TranslucentTB/releases/latest)
2. **PowerToys** by _Microsoft_ (https://github.com/microsoft/PowerToys/releases/latest)

It makes use of TranslucentTB and PowerToys to automate the Taskbar colour changing process. The Taskbar Blur Levels and Blur Style can be changed from TranslucentTB itself.


<br/>

## **HOW DID WE GET HERE?**


Because TranslucentTB has it's limitations.

 ‣ All advanced controls have to be modified via it's config file.
 
 <img width="322" alt="Screenshot (15)" src="https://user-images.githubusercontent.com/64971616/119177460-fba34800-ba89-11eb-99f0-e8562c1bcafe.png">

 ‣ Once the Style of taskbar is set (say you have Normal blur with an orange colour.)
 
 <img width="269" alt="Annotation 2021-05-21 230340" src="https://user-images.githubusercontent.com/64971616/119176499-cd713880-ba88-11eb-87bc-126cb9d7ddd7.png">
 
  And then you change the wallpaper to, say, something Blue. TranslucentTB CANNOT change the taskbar colour automaticlly, unlike native Windows where you can you leave the "Automatically pick an accent colour from my background" and forget about it.
  For doing so with TranslucentTB you'll have to manually look for a colour of your choice/choose from windows perssonalization colour palette, THEN find the HEX value of that colour _(good luck finding hex of a random colour on screen XD)_, and THEN manually input that in every colour field of the TranslucentTB config file.
  
 <img width="328" alt="Annotation 2021-05-21 230624" src="https://user-images.githubusercontent.com/64971616/119176830-2f31a280-ba89-11eb-924f-fdb5144aa836.png">
  Doing that is another huge waste of time.
  
  _**This is exactly what "Colours" tries to automate**_
  
  
  <br/>
  
  
  ## **BUT THERE ARE NO SHORTCUTS IN LIFE!**
  
  Well, there are, when you're dealing with computers. Here's what "Colours" does
  
  ◦ Launch Windows Personalisation and choose the Color Windows 'thinks' fits wallpaper you've currently set. _**MAKE SURE THE "Automatically pick an accent colour from my background" IS ON OTHERWISE COLOURS WON'T CHANGE AUTOMATICALLY_**
  
  
  ◦ Use PowerToys' System Wide colour picker to find the HEX of that colour.
  
  ◦ Open the TranslucentTB confi file and replaces the colour values so that the new colour is refected.
  
  ◦ Restart TranslucentTB for changes to take effect.

