from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

friends = db.Table('friends',
    db.Column('friend_id', db.Integer, db.ForeignKey('user.id'), primary_key=True),
    db.Column('friended_id', db.Integer, db.ForeignKey('user.id'), primary_key=True)
)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)
    last_location = db.relationship('Location', backref='user', lazy=True, uselist=False)
    geofences = db.relationship('Geofence', backref='creator', lazy=True)
    posts = db.relationship('Post', backref='author', lazy=True)
    friends = db.relationship('User', secondary=friends,
                              primaryjoin=(friends.c.friend_id == id),
                              secondaryjoin=(friends.c.friended_id == id),
                              backref=db.backref('friended', lazy='dynamic'), lazy='dynamic')
    num_places = db.Column(db.Integer, default=0)
    num_posts = db.Column(db.Integer, default=0)
    num_friends = db.Column(db.Integer, default=0)

class Geofence(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    radius = db.Column(db.Float, nullable=False) 
    creator_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    posts = db.relationship('Post', backref='geofence', lazy=True)

    def to_geojson(self):
        return {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [self.longitude, self.latitude]
            },
                "properties": {
                "radius": self.radius,
            },
            
        }

class Post(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    photo_url = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime, nullable=False, default=db.func.current_timestamp())
    author_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    geofence_id = db.Column(db.Integer, db.ForeignKey('geofence.id'), nullable=False)

class Location(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), unique=True, nullable=False)

class FriendRequest(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    sender_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    receiver_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

    sender = db.relationship('User', foreign_keys=[sender_id], backref='sent_requests')
    receiver = db.relationship('User', foreign_keys=[receiver_id], backref='received_requests')

