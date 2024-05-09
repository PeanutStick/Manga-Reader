#!/bin/bash
website="https://mangakatana.com/manga"
for f in mangas/*; do
	manga_directory=$(echo $f |cut -d "/" -f 2)

	if [ -f "mangas/${manga_directory}/link.txt" ]; then
		manga_mame=$(cat "mangas/${manga_directory}/link.txt")
		manga_url="${website}/${manga_mame}"
		urls_chapitres=$(curl -s ${manga_url} | grep -Eo ${manga_url}'/c[0-9]+(\.[0-9]+)?')
		#echo $urls_chapitres
		echo "${urls_chapitres}" | while IFS= read -r url; do

			single_chap=$(echo $url |rev|cut -d "/" -f 1|rev)

			
			#Remove c from single_chap
			if [[ "$single_chap" =~ "." ]]; then
				sub_chap=$(echo $single_chap|cut -d "." -f2)
				dir_chap=$(echo "c$(printf %03d $(echo "$single_chap" | rev | cut -d "/" -f 1 | rev | cut -d "c" -f 2|cut -d . -f1)).$sub_chap")
			else
				dir_chap=$(echo "c$(printf %03d $(echo "$single_chap" | rev | cut -d "/" -f 1 | rev | cut -d "c" -f 2))")
			fi

			chapter_directory="mangas/${manga_directory}/${dir_chap}"
			if [ ! -d "${chapter_directory}" ]; then
				echo "Downloading ${manga_directory} Chapter ${single_chap} ..."
				mkdir -p "mangas/${manga_directory}/${dir_chap}"
				content=$(curl -s "${manga_url}/${single_chap}")
				image_urls=$(echo "${content}" | grep -o 'https://i1\.mangakatana\.com/token/[a-zA-Z0-9%/.:-]*\.jpg')
				
				echo "${image_urls}" | while read -r url; do
					wget --quiet "${url}" -P "mangas/${manga_directory}/${dir_chap}"
					
					#echo "${manga_directory} ${dir_chap} ${image_urls}"
				done
				find  "mangas/${manga_directory}/${dir_chap}" -type f ! -name "*.jpg" -exec rm -f {} +
				cd "mangas/${manga_directory}/${dir_chap}"
				rename 's/\d+/sprintf("%03d",$&)/e' *.jpg
				cd ../
				#rm -rf c
				cd ../../

			fi
		done
	fi
done












# Créer le répertoire pour les images du chapitre
#mkdir -p "mangas/${manga_directory}/${chapter}"

# Récupérer le contenu HTML de la page du chapitre
#content=$(curl -s "${manga_url}/${chapter}")

# Extraire les URLs des images au format JPG
#image_urls=$(echo "${content}" | grep -o 'https://i1\.mangakatana\.com/token/[a-zA-Z0-9%/.:-]*\.jpg')

# Télécharger chaque image dans le répertoire du chapitre
#echo "${image_urls}" | while read -r url; do
#	wget "${url}" -P "mangas/${manga_directory}/${chapter}"
#done

#find  "mangas/${manga_directory}/${chapter}" -type f ! -name "*.jpg" -exec rm -f {} +
#cd mangas/${manga_directory}/${chapter}
#rename 's/\d+/sprintf("%03d",$&)/e' *.jpg






# Faire un diff

# Garder les elléments du site non présent dans le répertoire
