from Flask import event
# event_listeners.py
from models import Place, Post, User, db, friends
from sqlalchemy import event


def increment_count(mapper, connection, target):
    if isinstance(target, Place):
        user = db.session.query(User).get(target.creator_id)
        user.num_places += 1
    elif isinstance(target, Post):
        user = db.session.query(User).get(target.author_id)
        user.num_posts += 1
    db.session.commit()

def decrement_count(mapper, connection, target):
    if isinstance(target, Place):
        user = db.session.query(User).get(target.creator_id)
        user.num_places -= 1
    elif isinstance(target, Post):
        user = db.session.query(User).get(target.author_id)
        user.num_posts -= 1
    db.session.commit()

# Register event listeners
event.listen(Place, 'after_insert', increment_count)
event.listen(Place, 'after_delete', decrement_count)
event.listen(Post, 'after_insert', increment_count)
event.listen(Post, 'after_delete', decrement_count)

@event.listens_for(friends, 'after_insert')
def increment_friends(mapper, connection, target):
    db.session.query(User).filter_by(id=target.friend_id).update({'num_friends': User.num_friends + 1})
    db.session.query(User).filter_by(id=target.friended_id).update({'num_friends': User.num_friends + 1})
    db.session.commit()

@event.listens_for(friends, 'after_delete')
def decrement_friends(mapper, connection, target):
    db.session.query(User).filter_by(id=target.friend_id).update({'num_friends': User.num_friends - 1})
    db.session.query(User).filter_by(id=target.friended_id).update({'num_friends': User.num_friends - 1})
    db.session.commit()
