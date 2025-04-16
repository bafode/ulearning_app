# Configuration du CI/CD GitHub pour le déploiement iOS et Android

Ce document explique comment configurer les secrets GitHub nécessaires pour permettre le déploiement automatique de l'application Beehive vers l'App Store et le Google Play Store.

## Secrets pour le déploiement iOS (App Store)

Pour que le workflow CI puisse signer et déployer l'application iOS vers l'App Store, vous devez configurer les secrets suivants dans les paramètres de votre dépôt GitHub:

### Secrets pour la signature iOS

1. `BUILD_CERTIFICATE_BASE64`: Le certificat de distribution iOS encodé en base64
2. `P12_PASSWORD`: Le mot de passe du certificat P12
3. `BUILD_PROVISION_PROFILE_BASE64`: Le profil de provisionnement encodé en base64
4. `KEYCHAIN_PASSWORD`: Un mot de passe pour le keychain temporaire (vous pouvez choisir n'importe quelle valeur)

### Secrets pour l'API App Store Connect

1. `APP_STORE_CONNECT_API_KEY_ID`: L'ID de la clé API App Store Connect
2. `APP_STORE_CONNECT_API_ISSUER_ID`: L'ID de l'émetteur de la clé API
3. `APP_STORE_CONNECT_API_KEY_CONTENT`: Le contenu de la clé API privée encodé en base64

## Secrets pour le déploiement Android (Google Play)

Pour le déploiement Android, vous avez besoin des secrets suivants:

1. `KEYSTORE_BASE64`: Le fichier keystore Android encodé en base64
2. `KEY_ALIAS`: L'alias de la clé dans le keystore
3. `KEY_PASSWORD`: Le mot de passe de la clé
4. `STORE_PASSWORD`: Le mot de passe du keystore
5. `SERVICE_ACCOUNT_JSON`: Le contenu du fichier JSON du compte de service Google Play

## Comment générer ces secrets

### Pour iOS:

#### Certificat et profil de provisionnement

1. Exportez votre certificat de distribution depuis Keychain Access:
   - Ouvrez Keychain Access
   - Trouvez votre certificat de distribution iOS
   - Cliquez droit et choisissez "Exporter"
   - Sauvegardez au format .p12 et définissez un mot de passe

2. Téléchargez votre profil de provisionnement depuis le portail développeur Apple

3. Encodez ces fichiers en base64:
   ```bash
   base64 -i Certificates.p12 | pbcopy  # Pour le certificat
   base64 -i profile.mobileprovision | pbcopy  # Pour le profil de provisionnement
   ```

#### Clé API App Store Connect

1. Générez une clé API dans App Store Connect:
   - Allez sur https://appstoreconnect.apple.com/
   - Accédez à "Users and Access" > "Keys"
   - Créez une nouvelle clé avec les permissions "App Manager"
   - Téléchargez le fichier .p8

2. Notez l'ID de la clé et l'ID de l'émetteur

3. Encodez le fichier .p8 en base64:
   ```bash
   base64 -i AuthKey_XXXXXXXX.p8 | pbcopy
   ```

### Pour Android:

#### Keystore

1. Si vous n'avez pas encore de keystore, créez-en un:
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Encodez le keystore en base64:
   ```bash
   base64 -i upload-keystore.jks | pbcopy
   ```

#### Compte de service Google Play

1. Créez un compte de service dans la Google Play Console:
   - Allez sur https://play.google.com/console/
   - Accédez à "Setup" > "API access"
   - Créez un compte de service ou utilisez-en un existant
   - Téléchargez le fichier JSON du compte de service

2. Copiez le contenu du fichier JSON pour le secret `SERVICE_ACCOUNT_JSON`

## Ajout des secrets à GitHub

1. Allez sur votre dépôt GitHub
2. Cliquez sur "Settings" > "Secrets and variables" > "Actions"
3. Cliquez sur "New repository secret"
4. Ajoutez chaque secret avec son nom et sa valeur

Une fois tous les secrets configurés, le workflow CI sera capable de signer et déployer automatiquement votre application vers l'App Store et le Google Play Store lorsque vous pousserez des modifications sur la branche `main`.
