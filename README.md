Projet Systèmes Informatiques

Le dossier Lex_Yacc contient :

-Une version finale des règles lexicales qu'on a nommé analysev2.lex qui analysent un fichier C afin de retrouver les tokens

-une grammaire grammaire.y qui à partir des tokens envoyés par regle.lex génère un code ASM correspondant au fichier example.c (code C minimaliste).

Commande pour compilation du générateur et interpréteur: make

Commande pour lancement du générateur: make run example.c 

Commande pour lancement du générateur: make run test-asm.txt

Clean fichiers: clean


