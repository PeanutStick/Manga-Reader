#!/bin/bash

cat <<EOF > index.html.new
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mangaaaa</title>
<style>

body {
    background-color: #121212; 
  }
.manga-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
}

.manga a {
    text-decoration: none;
  }
  
.manga {
    background-color: #333;
    padding: 10px;
    margin: 10px;
    border-radius: 5px;
    width: calc(33.33% - 20px);
    max-width: 300px;
}

.image {
    width: 100%;
    height: auto;
    display: block;
    border-radius: 5px;
}

.title {
    font-family: 'Arial', sans-serif;
    font-weight: bold;
    color: white;
    font-size: 18px;
    text-align: center;
    margin-top: 5px;
}

.search-container {
    text-align: center;
    margin-bottom: 20px; 
 }

  .search-input {
    width: 80%; 
    padding: 10px;
    border-radius: 5px;
    border: 1px solid #666; 
    background-color: #222; 
    color: #fff;
    font-size: 16px;
    box-sizing: border-box;
}

.search-input:focus {
    outline: none; 
    border-color: #4CAF50; 
}

</style>
<script>
function filterMangas() {
  var input, filter, mangaContainer, manga, title, i, txtValue;
  input = document.getElementById('searchInput');
  filter = input.value.toUpperCase();
  mangaContainer = document.getElementsByClassName('manga-container')[0];
  manga = mangaContainer.getElementsByClassName('manga');
  for (i = 0; i < manga.length; i++) {
    title = manga[i].getElementsByClassName('title')[0];
    txtValue = title.textContent || title.innerText;
    if (txtValue.toUpperCase().indexOf(filter) > -1) {
      manga[i].style.display = "";
    } else {
      manga[i].style.display = "none";
    }
  }
}
</script>
<div class="search-container">
  <input type="text" id="searchInput" class="search-input" onkeyup="filterMangas()" placeholder="Rechercher par titre...">
</div>

<div class="manga-container">
EOF

for f in mangas/*; do
	title=$(echo $f |cut -d "/" -f 2)
	md5dir=$(tar -cf - "mangas/${title}" | md5sum | cut -d " " -f 1)
	update=1
	if grep -Fq "$md5dir" webpages/"$title".html
	then
		update=0
	fi
	
	if [ "$update" == 0 ] # Si le manga n'a pas changé
	then
		echo "No change for: $title - $md5dir"
		echo "  <div class=\"manga\">" >> index.html.new
		echo "    <a href=\"webpages/"${title}".html\">" >> index.html.new

		first_image=$(find mangas/"${title}" -maxdepth 2 -type f \( -iname "*.jpg" -o -iname "*.png" \) | sort | head -n 1)
		echo "<img src=\"${first_image}\" class=\"image\" alt=\"${title}\">" >> index.html.new

		echo "  <div class=\"title\">"${title}"</div>" >> index.html.new
		echo "</a>" >> index.html.new
		echo "</div>" >> index.html.new
		
	else # Si le manga a changé 
		start_time=$(date +%s.%N)
		firt_page=1 # To add the first page in cover
		cat chap1.txt > webpages/"$title".html
		echo -e "\n" >> webpages/"$title".html
		echo -e "\n" >> webpages/"$title".html
		# Creation  de l'index
		echo "  <div class=\"manga\">" >> index.html.new
		echo "    <a href=\"webpages/"${title}".html\">" >> index.html.new
		
		firt_page=1
		
		# Ajout des pages
		declare -A chapters
		chapters=()
		chapitres=()
		for f in mangas/"${title}"/*/*; do
			# Add cover page
			if [ "$firt_page" == 1 ]
			then
				echo "    <img src=\""${f}"\" class=\"image\" alt=\""${title}"\">" |grep '.jpg\|.png' >> index.html.new
			fi
			firt_page=0
			chapter=$(echo "$f" | cut -d'/' -f3)
			image=$(echo "$f" | cut -d'/' -f4)
			chapters[$chapter]+="../mangas/${title}/${chapter}/$image','"
			
			#Create list 
			if [[ ${chapitres[@]} != *"$chapter"* ]]
			then
				chapitres+=($chapter)
			fi
		done
			
		# To get the list in the right order
		for chapter in "${chapitres[@]}"; do
			echo "<a href=\"#\" class=\"chapter\" data-target=\"$chapter\">$chapter</a>" >> webpages/"$title".html
		done

		cat chap2.txt >> webpages/"$title".html

		IFS=$'\n' sorted=($(sort <<<"${!chapters[*]}"))
		unset IFS

		first=true
		for chapter in "${sorted[@]}"; do
			if [ "$first" = true ]; then
				echo "if (chapter === '$chapter') {" >> webpages/"$title".html
				sed -i 's/chap1/'$chapter'/g' webpages/"$title".html
				first=false
			else
				echo "} else if (chapter === '$chapter') {" >> webpages/"$title".html 
			fi
			echo "    images = ['$(echo "${chapters[$chapter]}" | sed 's/,$//')'];" >> webpages/"$title".html
		done
		echo "}" >> webpages/"$title".html
		cat chap3.txt >> webpages/"$title".html
		
		# Ajout du bas de page
		
		echo "  <div class=\"title\">"${title}"</div>" >> index.html.new
		echo "</a>" >> index.html.new
		echo "</div>" >> index.html.new
		
		sed -i 's/manga_name/'${title}'/g' webpages/"$title".html
		
		sed -i '/md5_hash:/d' webpages/"$title".html
		# Add md5 hash of the compressed directory to check any changes, like if you add a new chapter
		echo "<!--md5_hash: ${md5dir}-->" >> webpages/"$title".html
		
		end_time=$(date +%s.%N)
		elapsed_time=$(echo "$end_time - $start_time" | bc)
		echo "$elapsed_time seconds to generate $title"

	fi
done
mv index.html index.html.old
mv index.html.new index.html