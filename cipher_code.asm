.data 
text : .space 1024
key : .space 1024
emplacementCrypte : .space 1024
emplacementDecrypte : .space 1024
nouvelEmplacement : .asciiz ""

demandeChoix : .asciiz "\nBonjour, veuillez sélectionner votre choix : \n 1 : Cryptage ; 2 : Décryptage \n 3 : Cryptage d'un fichier texte ; 4 : Décryptage d'un fichier texte \n 5 : sortir \n"

welcomeCryptage1 : .asciiz "Veuillez entrer votre texte : \0"
welcomeCryptage2 : .asciiz "Veuillez entrer votre clé : \0"

welcomeDecryptage1 : .asciiz "Veuillez entrer votre texte crypté : \0"
welcomeDecryptage2 : .asciiz "Veuillez entrer votre clé : \0"

welcomeCryptageTxt1 :.asciiz "Veuillez entrer l'emplacement complet où se situe le texte non crypté : \0"
welcomeCryptageTxt2 : .asciiz "Veuillez entrer l'emplacement complet où vous voulez enregistrer votre texte crypté : \0"
welcomeCryptageTxt3 : .asciiz "Veuillez entrer votre clé : \0"

welcomeDecryptageTxt1 :.asciiz "Veuillez entrer l'emplacement complet où se situe le texte crypté : \0"
welcomeDecryptageTxt2 :.asciiz "Veuillez entrer l'emplacement complet où vous voulez enregistrer le texte décrypté : \0"
welcomeDecryptageTxt3 : .asciiz "Veuillez entrer votre clé : \0"

.text :

#initialisation du programme, pour savoir quoi prendre
		
choix :		
		li $v0, 4
		la $a0, demandeChoix
		syscall
		
		li $v0, 5
		syscall
		
		beq $v0, 1, DébutCryptage
		beq $v0, 2, DébutDéCryptage
		beq $v0, 3, DébutCryptageTxt
		beq $v0, 4, DébutDecryptageTxt 
		beq $v0, 5, exit
		j choix				#on retourne sur choix, au cas où la personne s'est trompée
	
#fonction utilisée pour le début du cryptage

DébutCryptage :	

		li $v0, 4
		la $a0, welcomeCryptage1	#affichage du texte welcome 1
		syscall
		
		li $v0, 8
		la $a0, text			#on rentre le texte à crypter
		li $a1, 1024
		syscall
		move $s0, $a0			#on stocke le texte dans $s0
		
		li $v0, 4
		la $a0, welcomeCryptage2	#on affiche le texte welcome 2
		syscall
		
		li $v0, 8
		la $a0, key			#on rentre la clé
		li $a1, 1024
		syscall
		move $s1, $a0			#on stocke la clé dans $s1
		li $t0, 0
		li $t6, 0
		jal taille_Cle			
		j Crypteur

#fonction pour initialiser le décryptage
	
DébutDéCryptage :
	
		li $v0, 4
		la $a0, welcomeDecryptage1	#affichage du texte welcomeDécryptage1
		syscall
		
		li $v0, 8
		la $a0, text			#on rentre le texte à décrypter
		li $a1, 50
		syscall
		move $s0, $a0			#on stocke le texte dans $s0
		
		li $v0, 4
		la $a0, welcomeDecryptage2	#on affiche le texte welcomeDécryptage2
		syscall
		
		li $v0, 8
		la $a0, key			#on rentre la clé
		li $a1, 50
		syscall
		move $s1, $a0			#on stocke la clé dans $s1
		li $t0, 0
		li $t6, 0
		jal taille_Cle			
		j Décrypteur
		
#fonction pour créer un texte crypté dans un .txt
				
DébutCryptageTxt :	
		li $v0, 4
		la $a0, welcomeCryptageTxt1	
		syscall
		
		li $v0, 8
		la $a0, emplacementCrypte	#on rentre le chemin du texte à lire
		li $a1, 1024
		syscall
		move $s0, $a0			#stockage chemin du texte dans $s0	
		
		li $v0, 4
		la $a0, welcomeCryptageTxt2	
		syscall
		
		li $v0, 8
		la $a0, emplacementDecrypte	#on rentre le chemin du fichier où le texte sera crypté
		li $a1, 1024
		syscall
		move $s4, $a0			#stockage chemin de l'endroit où on voudra enregistrer dans $s4
		
		li $v0, 4
		la $a0, welcomeCryptageTxt3	
		syscall
		
		li $v0, 8
		la $a0, key			#on rentre la clé
		li $a1, 1024
		syscall
		move $s1, $a0			#on stocke la clé dans $s1
		
		li $v1, 0			#utilisation de v1 pour conserver la taille exacte de la chaine de caractère pour la création du .txt
		li $t6, 0
		jal taille_Cle
		jal enregistrementTexte
		li $v0, 9			#attribution mémoire dans le tas
		li $a0, 1024
		syscall
		
		move $s6, $v0			#on stocke l'adresse de cette attribution dans s6
		j crypteurTxt			

#fonction pour initialiser le décryptage		
		
DébutDecryptageTxt :	
		li $v0, 4
		la $a0, welcomeDecryptageTxt1	
		syscall
		
		li $v0, 8
		la $a0, emplacementCrypte	#on rentre le chemin du texte qu'on voudra décrypter
		li $a1, 1024
		syscall
		move $s0, $a0			#stockage chemin du texte dans $s0	
		
		li $v0, 4
		la $a0, welcomeDecryptageTxt2	
		syscall
		
		li $v0, 8
		la $a0, emplacementDecrypte	#on rentre le chemin du fichier où le texte sera décrypté
		li $a1, 1024
		syscall
		move $s4, $a0			#stockage chemin de l'endroit où on voudra enregistrer dans $s4
		
		li $v0, 4
		la $a0, welcomeDecryptageTxt3	
		syscall
		
		li $v0, 8
		la $a0, key			#on rentre la clé
		li $a1, 1024
		syscall
		move $s1, $a0			#on stocke la clé dans $s1
		
		li $v1, 0			#utilisation de v1 pour connaitre la taille exacte de la chaine de caractère pour la création du .txt
		li $t6, 0
		jal taille_Cle
		jal enregistrementTexte
		li $v0, 9			#attribution mémoire dans le tas
		li $a0, 1024
		syscall
		
		move $s6, $v0			#on stocke l'adresse de cette attribution dans s6
		j decrypteurTxt			
		
		
	
#fonction pour connaitre la taille exacte de la clé

taille_Cle :	
		add $s3, $s3, 1			#on regarde la taille de la clé, pour pouvoir boucler plus tard	
		add $t7, $s1, $s3
		lb $t5, ($t7)
		beq $t5, 0, retour
		j taille_Cle
		
#fonction de retour dans la boucle principale

retour :	sub $s3, $s3, 1			#on profite de retour pour initialiser des valeurs pour le calcul du cryptage/decryptage
		li $s2, 95			#la taille de la table qu'on utilise dans l'ASCII
		li $s4, 64			#ici, la taille minimale de l'addition des 2 bits
		li $s5, 32			#ajout pour le cryptage
		jr $ra

#fonction utilisée pour crypter le message.
	
Crypteur : 	
		add $t1, $s0, $t0		#on incrémente au prochain bit pour la clé et le texte (t1 = texte, t2 = clé)	
		add $t2, $s1, $t6		
		lb $t3, ($t1)			#on enregistre le bit dans t3, celui avec le rang de t1
		lb $t4, ($t2)
		beq $t3, 10, choix
		
		add $t3, $t3, $t4		#on ajoute les deux lettres, puis on fait en sorte de retrouver les indices de l'alphabet
		sub $t3, $t3, $s4		
		div $t3, $s2			#on fait en sorte que si on arrive à la fin de l'alphabet, on retourne au début
		mfhi $t3
		add $t3, $t3, $s5		#on retrouve la valeur dans la table ascii
			
		la $a0, ($t3)			#affichage cryptage
		li $v0, 11
		syscall
		
		addi $t0, $t0, 1
		addi $t6, $t6, 1
		div $t6, $s3			#on fait en sorte que la clé puisse boucler, pour pouvoir l'utiliser dans tout le code
		mfhi $t6
		
		j Crypteur

#fonction pour décrypter un message avec une clé
	
Décrypteur : 		
		add $t1, $s0, $t0		#incrémentation pour parcourir le texte en entier
		add $t2, $s1, $t6			
		lb $t3, ($t1)
		lb $t4, ($t2)
		beq $t3, 10, choix
		
		add $t3, $t3, $s2		#on ajoute à t3 la taille de la table, pour éviter les éventuelles valeurs négatives
		sub $t3, $t3, $t4		
		div $t3, $s2			#on fait en sorte que si on arrive à la fin de l'alphabet, on retourne au début
		mfhi $t3
		add $t3, $t3, $s5		#on retrouve la valeur dans la table ascii
		
		la $a0, ($t3)			#affichage decryptage
		li $v0, 11
		syscall
		
		addi $t0, $t0, 1
		addi $t6, $t6, 1
		div $t6, $s3			#on fait en sorte que la clé puisse boucler, pour pouvoir l'utiliser dans tout le code
		mfhi $t6
		j Décrypteur

#fonction pour crypter un message dans un .txt 

crypteurTxt :		 
		add $t1, $s0, $v1		#on incrémente au prochain bit pour la clé et le texte (t1 = texte, t2 = clé)	
		add $t2, $s1, $t6		
		lb $t3, ($t1)			#on enregistre le bit dans t3, celui avec le rang de t1
		lb $t4, ($t2)
		beq $t3, 0, nouveauTxt		#on va enregistrer le texte dans un nouveau .txt dès qu'on arrive à \0 (pas obligé d'avoir le \n)
		
		add $t3, $t3, $t4		#on ajoute les deux lettres, puis on fait en sorte de retrouver les indices de la table
		sub $t3, $t3, $s4		
		div $t3, $s2			#on fait en sorte que si on arrive à la fin de la table, on retourne au début
		mfhi $t3
		add $t3, $t3, $s5		#on retrouve la valeur dans la table ascii
			
		add $t9, $s6, $v1
		sb $t3, ($t9)			#on enregistre ici le bit dans l'adresse de t9, à savoir le prochain bit de s6
		
		
		addi $v1,$v1, 1
		addi $t6, $t6, 1
		div $t6, $s3			#on fait en sorte que la clé puisse boucler, pour pouvoir l'utiliser dans tout le code
		mfhi $t6
		
		j crypteurTxt

#fonction utilisée pour décrypter, puis enregistrer dans un .txt

decrypteurTxt :		 
		add $t1, $s0, $v1		#on incrémente au prochain bit pour la clé et le texte (t1 = texte, t2 = clé)	
		add $t2, $s1, $t6		
		lb $t3, ($t1)			#on enregistre le bit dans t3, celui avec le rang de t1
		lb $t4, ($t2)
		beq $t3, 0, nouveauTxt		#on va enregistrer le texte dans un nouveau .txt avec le chemin qu'on nous a donné précédemment une fois fini
		
		add $t3, $t3, $s2		#on ajoute à t3 la taille de la table, pour éviter les éventuelles valeurs négatives
		sub $t3, $t3, $t4		
		div $t3, $s2			#on fait en sorte que si on arrive à la fin de l'alphabet, on retourne au début
		mfhi $t3
		add $t3, $t3, $s5		#on retrouve la valeur dans la table ascii
			
		add $t9, $s6, $v1
		sb $t3, ($t9)			#on enregistre ici le bit dans l'adresse de t9, à savoir le prochain bit de s6
		
		
		addi $v1,$v1, 1
		addi $t6, $t6, 1
		div $t6, $s3			#on fait en sorte que la clé puisse boucler, pour pouvoir l'utiliser dans tout le code
		mfhi $t6
		
		j decrypteurTxt
		
#on enregistre le texte grâce à cette fonction dans un .txt

enregistrementTexte :
		move $sp, $ra
		jal nettoyeurNom
		move $ra, $sp
		li   $v0, 13       		# on va ouvrir le fichier
  		la   $a0, ($s0)			# l'adresse de fichier est récupérée
  		li   $a1, 0       		# on le met en read mode
  		syscall            
  		move $t8, $v0			# on prend le descripteur dans t8
  		
  		li $v0, 14			#on lit le texte dans le fichier
  		move $a0, $t8
  		la $a1, text
  		li $a2, 50
  		syscall
  		
  		li $v0, 16			#on ferme le fichier
  		move $a0, $t8
  		syscall
  		la $s0, text
  		
		jr $ra

#3 procédures pour nettoyer la fin du nom du fichier

nettoyeurNom2:
    		li $t0, 0       		#on initialise un compteur
nettoyeur2:
    		beq $t0, 50, finNettoyeur2
    		lb $t3, emplacementDecrypte($t0)
    		bne $t3, 10, increment2
    		sb $zero, emplacementDecrypte($t0)		#une fois arrivé au terme \n, on le remplace par zéro pour éviter les problèmes

increment2 :
		add $t0, $t0, 1
    		j nettoyeur2

finNettoyeur2 :
		li $t0, 0			#on réinitialise à zéro
		li $t3, 0 
		jr $ra

#3 procédures pour nettoyer la fin du nom du fichier

nettoyeurNom:
    		li $t0, 0       		#on initialise un compteur
nettoyeur:
    		beq $t0, 50, finNettoyeur
    		lb $t3, emplacementCrypte($t0)
    		bne $t3, 10, increment
    		sb $zero, emplacementCrypte($t0)		#une fois arrivé au terme \n, on le remplace par zéro pour éviter les problèmes

increment :
		add $t0, $t0, 1
    		j nettoyeur

finNettoyeur :
		li $t0, 0			#on réinitialise à zéro
		li $t3, 0 
		jr $ra

#fonction pour enregistrer dans un nouveau .txt 

nouveauTxt :	
		jal nettoyeurNom2
		li $v0, 13       		# on ouvre le fichier.
  		la $a0, emplacementDecrypte	# l'adresse de fichier est récupérée
  		li $a1, 1        		# ecriture (0 read 1 ecriture)
  		li $a2, 0
  		syscall            
  		move $s7, $v0      		# sauvegarde dans s7
  		
		li $v0, 15       		#écriture
  		move $a0, $s7      		# on prend le fichier dans a0
  		la $a1, ($s6)	  		# l'adresse du texte a prendre
  		move $a2, $v1       		# longueur du buffer
  		syscall
  		
  		li $v0, 16       
  		move $a0, $s7      		# nom du fichier a fermer
  		syscall
  		j choix
#fonction pour arrêter

exit :	
		li $v0, 10
		syscall
