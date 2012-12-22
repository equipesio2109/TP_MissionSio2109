//Cette fonction permet de créer une grille en mémoire
List construire_grille(int ligne, int colonne, int nombre_bombes)
{
  List grille;

  for(int i = 0; i<ligne;i++)
  {
    List liste_rangee;

    //crééer les rangé
    for(int j=0;j<colonne;j++)
    {
      liste_rangee.add(creer_case(ligne, colonne));
    }

    //ajouter la rangée à la liste
    grille.add(liste_rangee);
  }

  grille = placer_bombe(grille, nombre_bombes);

  return grille;
}


//Permet de créer une case vide
Map creer_case(int ligne, int colonne)
{
   var une_case = new Map();
   une_case['ligne'] = ligne;
   une_case['colonne'] = colonne;
   //L'état de la case : vide bombe affiche_chiffre 1 2 3 4 5 6 7 8
   une_case['etat'] = 'vide';

   return une_case;
}

//Permet de placer des bombes dans une grille
List placer_bombe(List grille, int nombre_bombes)
{
  var rng = new Random();

  for(int i = 0; i<nombre_bombes;i++)
  {
    int ligne_aleatoire = rng.nextInt(grille.length);
    int colonne_aleatoire = rng.nextInt(grille[0].length);

    //Vérifier s'il y a déjà une bombe sinon en place une
    if(grille[ligne_aleatoire][colonne_aleatoire]['etat'] == 'vide' )
    {
      grille[ligne_aleatoire][colonne_aleatoire]['etat'] = 'bombe';
    }
    else
    {
      //Il y a avait déjà une bombe déclémenter la variable pour pouvoir en placer une autre à un autre place
      i = i - 1;
    }

  }

  return grille;
}




afficher_grille(CanvasRenderingContext2D  context, List grille, int largeur, int hauteur)
{

   for(int i = 0; i<grille.length;i++)
   {
      for(int j = 0; j<grille[0].length;i++)
      {

        if(grille[i][j]['etat']=='bombe')
        {
          context.fillStyle = 'red';
        }
        else
        {
          context.fillStyle = 'yellow';
        }

        var position_x = i*largeur;
        var position_y = i*largeur;

        context.rect(position_x, position_y, largeur, hauteur);



        context.fill();
        context.lineWidth = 1;
        context.strokeStyle = 'black';
        context.stroke();

      }
   }

}
