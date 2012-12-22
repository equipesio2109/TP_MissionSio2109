import 'dart:html';
import 'dart:math';
import 'dart:isolate';

List grille;

int largeur_case = 30;
int hauteur_case = 30;
int nombre_case_largeur = 20;
int nombre_case_hauteur = 20;
int nombre_bombe = 50;
int nombre_seconde = 0;
bool partie_terminer = false;






void main() {
  grille = construire_grille(nombre_case_largeur, nombre_case_hauteur, nombre_bombe);
  afficher_grille();
  CanvasElement canvas =  document.query('#canvas');



  canvas.on.click.add((MouseEvent me) {
  selectionner_case_cliquer(me.offsetX, me.offsetY);
  verifier_si_on_a_gagner();

  afficher_grille();
  });



  document.$dom_getElementById('facile').on.click.add((MouseEvent me) {
    nombre_bombe = 50;
    partie_terminer = false;
    nombre_case_largeur = 15;
    nombre_case_hauteur = 15;
    nombre_seconde = 0;
    grille = construire_grille(nombre_case_largeur, nombre_case_hauteur, nombre_bombe);
    afficher_grille();
  });

  document.$dom_getElementById('moyen').on.click.add((MouseEvent me) {
    nombre_bombe = 100;
    partie_terminer = false;
    nombre_case_largeur = 20;
    nombre_case_hauteur = 20;
    nombre_seconde = 0;
    grille = construire_grille(nombre_case_largeur, nombre_case_hauteur, nombre_bombe);
    afficher_grille();

  });

  document.$dom_getElementById('difficile').on.click.add((MouseEvent me) {
    nombre_bombe = 200;
    partie_terminer = false;

    nombre_case_largeur = 30;
    nombre_case_hauteur = 30;
    nombre_seconde = 0;
    grille = construire_grille(nombre_case_largeur, nombre_case_hauteur, nombre_bombe);
    afficher_grille();
  });

  //http://www.dartlang.org/docs/tutorials/web-ui/
  //Exemple pour afficher un interval  :  http://www.primitivetype.com/resources/js_clock.php
  window.setInterval(updateTime, 1000);
}

//Permet de montrer les secondes
void updateTime()
{
  nombre_seconde = nombre_seconde + 1;
  document.$dom_getElementById('interval').innerHtml = nombre_seconde.toString();
}



//cette fonction vérifie le contenu de l'ensemble des cases
//si oui la partie est terminée et affiche un message au joueur
verifier_si_on_a_gagner() {
  bool une_case_est_vide = false;
  // parcourir les lignes
    for(int i = 0; i<nombre_case_hauteur;i++){

      //parcourir les rangées
      for(int j = 0; j<nombre_case_largeur;j++){
        if(grille[i][j]['etat'] == 'vide')
      {

    une_case_est_vide = true;
    }
  }
}

//Si on a gagné s'il n'y a plus de case vide donc afficher un message pour dire qu'on a gagné
if(une_case_est_vide == false){
  CanvasElement canvas = document.query('#canvas');
  CanvasRenderingContext2D context = canvas.getContext('2d');
  context.fillStyle = 'red';
  context.font = "italic 200 80px Unknown Font, sans-serif";
  context.fillText("Vous gagnez !!!", 150, 150, 750);
}

}

//Cette fonctione permet de trouver la case cliquée et de prendre la bonne action
selectionner_case_cliquer(int x, int y){
  //detecter la case qui a été cliquer
  var case_cliquer_x = ((x/largeur_case)).toInt();
  var case_cliquer_y = (y/hauteur_case).toInt();

  //si la case est une bombe la partie sera terminé
  if(grille[case_cliquer_x][case_cliquer_y]['etat'] == 'bombe'){
    partie_terminer = true;
  }

  else{
    //afficher toutes les bombes
    detecter_nombre_bombes(grille[case_cliquer_x][case_cliquer_y]);
  }

}

//verification des cases adjacentes
detecter_nombre_bombes(Map cases_a_detecter){
  int nombre_bombes = 0;
  int ligne = cases_a_detecter['ligne'];
  int colonne = cases_a_detecter['colonne'];


  if(grille[ligne][colonne]['etat'] == 'vide'){
//-----------------------------------------------------------------//
    if(ligne > 0 ){
//-----------------------------------------------------------------//
      if(colonne > 0 ){

        if(grille[ligne-1][colonne-1]['etat'] == 'bombe'){
        nombre_bombes = nombre_bombes + 1;
        }

      }
//-----------------------------------------------------------------//
      if(grille[ligne-1][colonne]['etat'] == 'bombe'){
      nombre_bombes = nombre_bombes + 1;
      }
//-----------------------------------------------------------------//
      if(colonne + 1 < nombre_case_largeur){

        if(grille[ligne-1][colonne+1]['etat'] == 'bombe'){
        nombre_bombes = nombre_bombes + 1;
        }

      }
//-----------------------------------------------------------------//
    }

//Les cases de chaque côté
    if(colonne > 0 ){

      if(grille[ligne][colonne-1]['etat'] == 'bombe'){
      nombre_bombes = nombre_bombes + 1;
      }

    }
//-----------------------------------------------------------------//
    if(colonne + 1< nombre_case_largeur){

      if(grille[ligne][colonne+1]['etat'] == 'bombe'){
      nombre_bombes = nombre_bombes + 1;
      }

    }
//-----------------------------------------------------------------//


//Si on est pas en dehors de la grille une ligne plus un
    if(ligne + 1 < nombre_case_hauteur){
//-----------------------------------------------------------------//
      if(colonne - 1 > 0){

        if(grille[ligne+1][colonne-1]['etat'] == 'bombe'){
          nombre_bombes = nombre_bombes + 1;
        }
      }
//-----------------------------------------------------------------//
      if(grille[ligne+1][colonne]['etat'] == 'bombe'){
      nombre_bombes = nombre_bombes + 1;
      }
//-----------------------------------------------------------------//
      if(colonne + 1 < nombre_case_largeur){

        if(grille[ligne+1][colonne+1]['etat'] == 'bombe'){
          nombre_bombes = nombre_bombes + 1;
        }

      }
//-----------------------------------------------------------------//
    }



    //Affecter le nombre de bombes trouvés autour de cette case.
    grille[ligne][colonne]['etat'] = nombre_bombes.toString();

    //Si on a pas trouvé de bombe vérifier dans les 34 autres direction s'il y en a
    if(nombre_bombes==0)
    {
      if(ligne > 0 )
      {
        //Si c'est pas la premiere ligne vérifier la case d'en haut
        detecter_nombre_bombes(grille[ligne-1][colonne]);
      }

      //La case chaque côté
      //Si c'est pas la premiere ligne vérifier la ligne d'en haut
      if(colonne > 0 )
      {
        detecter_nombre_bombes(grille[ligne][colonne-1]);
      }

      if(colonne + 1< nombre_case_largeur)
      {
        detecter_nombre_bombes(grille[ligne][colonne+1]);
      }

      //Si on est pas en dehors de la grille vérifier la case d'en dessous.
      if(ligne + 1 < nombre_case_hauteur)
      {
        detecter_nombre_bombes(grille[ligne+1][colonne]);
      }
    }
  }
}

//Cette fonction permet de créer une grille en mémoire
List construire_grille(int ligne, int colonne, int nombre_bombes)
{
  List nouvelle_grille = new List();

  for(int i = 0; i<ligne;i++)
  {
    List liste_rangee = new List();

    //crééer les rangé
    for(int j=0;j<colonne;j++)
    {
      liste_rangee.add(creer_case(i, j));
    }

    //ajouter la rangée à la liste
    nouvelle_grille.add(liste_rangee);
  }

  nouvelle_grille = placer_bombe(nouvelle_grille, nombre_bombes);

  return nouvelle_grille;
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
List placer_bombe(List une_grille, int nombre_bombes)
{
  var rng = new Random();

  for(int i = 0; i<nombre_bombes;i++)
  {
    int ligne_aleatoire = rng.nextInt(nombre_case_hauteur);
    int colonne_aleatoire = rng.nextInt(nombre_case_largeur);

    //Vérifier s'il y a déjà une bombe sinon en place une
    if(une_grille[ligne_aleatoire][colonne_aleatoire]['etat'] == 'vide' )
    {
      une_grille[ligne_aleatoire][colonne_aleatoire]['etat'] = 'bombe';
    }
    else
    {
      //Il y a avait déjà une bombe décrémenter la variable pour pouvoir en placer une autre à un autre place
      i = i - 1;
    }

  }

  return une_grille;
}


//Cette fonction permet d'afficher toute la grille à chaque fois que quequ'un clique sur la grille
afficher_grille()
{

  CanvasElement canvas =    document.query('#canvas');
  CanvasRenderingContext2D context = canvas.getContext('2d');

  canvas.width = largeur_case * nombre_case_largeur;
  canvas.height = hauteur_case * nombre_case_hauteur;


  context.beginPath();

  context.lineWidth = 2;
  context.strokeStyle = '#46220A';
  context.stroke();

    // parcourir les lignes
   for(int i = 0; i<nombre_case_hauteur;i++)
   {
     //parcourir les rangées
      for(int j = 0; j<nombre_case_largeur;j++)
      {
        var position_x = i*largeur_case;
        var position_y = j*hauteur_case;

        if(grille[i][j]['etat'] == 'bombe') //possede une bombe
        {

          if(partie_terminer == true) //Si on doit afficher toutes les bombes car quelque a touché une bombe
          {
            context.fillStyle = '#c2660a';
            context.fillRect(position_x, position_y, largeur_case, hauteur_case);

            context.fillStyle='#2A1506';
            context.font = "200 20px/2 Unknown Font, sans-serif";
            context.fillText("B", i*largeur_case+10,  (j*hauteur_case)+hauteur_case-7, 450);
          }
          else //Afficher un carreau normal pour cahé la bombes
          {
            context.fillStyle = '#2A1506';
            context.fillRect(position_x, position_y, largeur_case, hauteur_case);
          }

        }
        else if( grille[i][j]['etat'] == 'vide') //pas encore cliquer ou détecter
        {
          context.fillStyle = '#2A1506';
          context.fillRect(position_x, position_y, largeur_case, hauteur_case);
        }
        else if( grille[i][j]['etat'] == '0') //Si on a détecté qu'il y avait aucune bombe
        {
          context.fillStyle = '#0E0702';
          context.fillRect(position_x, position_y, largeur_case, hauteur_case);
        }
        else //on a détecté une bombe ou plus écrire le nombre de bombes trouvés
        {
          context.fillStyle = '#0E0702';
          context.fillRect(position_x, position_y, largeur_case, hauteur_case);

          context.font = "200 24px/2 Unknown Font, sans-serif";
          context.fillStyle = '#666';

          context.fillText(grille[i][j]['etat'], i*largeur_case+10,  (j*hauteur_case)+hauteur_case-7, 450);
        }

        //un carré
        context.strokeRect(position_x, position_y, largeur_case, hauteur_case);
      }
   }

   context.fill();

   context.stroke();

   if(partie_terminer == true)//a cliquer sur une bombe
   {
     window.alert('Vous avez cliqué sur une bombe votre mission de déminage à échouée!');
     context.fillStyle = '#FFF';
     context.font = "600 60px sans-serif";
     context.fillText("Partie terminée !!!", 60, 150, 750);
   }

   context.closePath();

}
