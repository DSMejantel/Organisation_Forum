CREATE TABLE inscription(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    creneau INTEGER,
    nombre INTEGER,
    entreprise TEXT,
    pole_id INTEGER,
    metiers TEXT,
    courriel TEXT,
    tel	TEXT,
    infos TEXT,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE intervenants(
    inscription_id INTEGER,
    nom TEXT NOT NULL
);

CREATE TABLE poles(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pole TEXT
);

CREATE TABLE creneaux(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    horaire TEXT,
    special INTEGER
);
CREATE TABLE creneau(
    inscription_id INTEGER,
    creneau_id INTEGER
);

CREATE TABLE repas(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    total INTEGER,
    resa INTEGER,
    reste INTEGER
);
CREATE TABLE reservation(
    inscription_id INTEGER,
    repas_nombre INTEGER
);

CREATE TABLE services(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    categorie TEXT
);
CREATE TABLE besoins(
    inscription_id INTEGER,
    categorie_id INTEGER
);

CREATE TABLE login_session (
    id TEXT PRIMARY KEY,
    username TEXT NOT NULL REFERENCES user_info(username),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_cas TEXT,
    token TEXT
);
CREATE TABLE user_info (
	username	TEXT PRIMARY KEY,
	password_hash	TEXT,
	nom	TEXT,
	prenom	TEXT,
	tel	TEXT,
	courriel	TEXT,
	groupe	INTEGER,
	connexion	TIMESTAMP DEFAULT Null,
	activation	TEXT DEFAULT Null,
	CAS TEXT
);

CREATE TABLE cas_service(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    serveur TEXT,
    etat INTEGER
    );
