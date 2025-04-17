# 🐝 Beehive - Réseau Social Étudiant

Beehive est une application mobile Flutter moderne et dynamique, pensée pour connecter les étudiants dans un réseau social dédié à la collaboration, au partage et à la communication.


### 📱 Aperçu mobile

<p align="center">
  <img src="assets/screenshots/screen1.png" alt="Login" width="20%" />
  <img src="assets/screenshots/screen2.png" alt="Registration" width="20%" />
  <img src="assets/screenshots/screen3.jpg" alt="Home" width="20%" />
  <img src="assets/screenshots/screen4.jpg" alt="Home Zoom Drawer" width="20%" />
  <img src="assets/screenshots/screen5.jpg" alt="Select Post Type" width="20%" />
   <img src="assets/screenshots/screen6.jpg" alt="App Post Screen" width="20%" />
  <img src="assets/screenshots/screen7.jpg" alt="Message" width="20%" />
  <img src="assets/screenshots/screen8.jpg" alt="Profile" width="20%" />
</p>

---


## 🔗 Lien de démonstration

👉 [Beehive MobileApp - Beehive](https://play.google.com/store/apps/details?id=fr.beehiveapp.beehive)

---

## ✨ Fonctionnalités principales

- 👥 Inscription & Connexion via Firebase (email + providers tiers : Google, Apple, Facebook)
- 🧠 Gestion des états avec **Riverpod** et **GetX**
- 📨 Notifications push via **Firebase Cloud Messaging**
- 💬 Publication, commentaires et likes
- 🎥 Appels vidéo et audio intégrés via **Agora**
- 🌐 Requêtes HTTP optimisées avec **Retrofit** + **Dio**
- 🔐 Authentification sécurisée avec gestion de session et JWT
- 📱 Design responsive et animations fluides
- 🗂️ Architecture clean, scalable et modulaire

---

## 🧰 Technologies utilisées

| Outil             | Usage                                 |
|-------------------|----------------------------------------|
| Flutter           | Framework principal mobile             |
| Riverpod          | Gestion d’état réactive (statique)     |
| GetX              | Navigation et logique de gestion d’état|
| Firebase Auth     | Authentification et fournisseurs tiers |
| Firebase FCM      | Notifications push                     |
| Firebase Firestore| Base de données temps réel             |
| Dio + Retrofit    | Client HTTP performant                 |
| Agora             | Appels vidéo/audio temps réel          |
| Cloudinary        | Upload et gestion d'images             |

---

## 🚀 Lancement du projet

### 📦 Prérequis

- Flutter SDK (3.0 ou supérieur recommandé)
- Compte Firebase + configuration Android/iOS
- Clé Agora + configuration Cloudinary

### ⚙️ Installation

```bash
# Cloner le projet
git clone https://github.com/tonprofil/beehive-app.git
cd beehive-app

# Installer les dépendances
flutter pub get
```

<table align="center"> <tr> <td align="center"> <a href="https://bafodecamara.fr/"> <img src="https://res.cloudinary.com/dbi0fzoml/image/upload/w_200,c_fill,ar_1:1,g_auto,r_max/v1743583032/ChatGPT_Image_Apr_1_2025_10_15_42_PM_vezcye.png" width="100" height="100" style="border-radius: 50%;" alt="Bafode Camara" /> <br /> <sub><b>Bafode Camara</b></sub> </a> <br /> 💼 Développeur FullStack<br /> 🎓 Étudiant en Master informatique<br /> 🌍 Paris, France </td> </tr> </table>
