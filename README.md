# Manga-Reader
A manga website reader generator, writen in Bash.    
The website is made with HTML and JS.


# Usage 
## Create the directories
```bash
mkdir "mangas/dr. stone" -p
mkdir webpages
# Optional
echo "dr-stone.18416" > "mangas/dr. stone/link.txt"
```
## Download the mangas
1. Create a file `link.txt` in the mangas directory (ex: 'mangas/dr. stone/link.txt')
2. Put a part of the link inside like `dr-stone.18416` for `https://mangakatana.com/manga/dr-stone.18416`.    
3. Run the script `manga_downloader.sh`.    
## Generate the webpage
1. Put the mangas in the mangas directory.
2. Run the script `gen_website.sh`.    

# Features
[x] 1. Save the chapter of the page to come back at the right chapter.    
[x] 2. Fast generation by generating only the new webpages pages.    
[x] 3. Search bar.    
[x] 4. Hide the buttons by clicking on `Chapters`.    
[x] 5. Add the next button at the end of the page.    
[x] 6. Responsive.    
[x] 7. Create a script to download the chapters.    
[ ] 8. Save the page of the chapter to come back at the right page.    
[ ] 9. Fix the size of the images in the index.     
[ ] 10. Add pages in the index.    

# File structure    
```
📦
┣📜gen_website.sh
┣📜index.html
┣📜style.css
┣📜chap1.txt
┣📜chap2.txt
┣📜chap3.txt
┣📂 mangas
┃ ┣─📂 Berserk
┃ ┗─📂 Grand Blue
┃    ┣─📂 c001
┃    ┃  ┗──📜001.jpg
┃    ┃  ┗──📜002.jpg
┃    ┣─📂c002
┃    ┃  ┗──📜001.jpg
┃    ┃  ┗──📜002.jpg
┃    ┗─📂c003
┗📂webpages
┃ ┣─📜Berserk.html
┃ ┗─📜Grand Blue.html
```
# Screenshots
### Index.html
![](https://i.imgur.com/CedFXPr.png)
### Manga
![](https://i.imgur.com/CC5RJb4.png)
### End of page
![](https://i.imgur.com/5sFpADJ.png)
### On mobile
![](https://i.imgur.com/X50l63P.png)
