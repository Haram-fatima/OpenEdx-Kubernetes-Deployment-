// Create OpenEdX database
db = db.getSiblingDB('openedx');

// Create collections for OpenEdX
db.createCollection("modulestore");
db.createCollection("course_structure");
db.createCollection("user_profiles");
db.createCollection("content_libraries");

// Create indexes for performance
db.modulestore.createIndex({ "course_id": 1, "revision": -1 });
db.modulestore.createIndex({ "org": 1, "course": 1, "run": 1 });
db.course_structure.createIndex({ "course_id": 1, "edited_on": -1 });
db.user_profiles.createIndex({ "user_id": 1 }, { unique: true });
db.content_libraries.createIndex({ "library_key": 1, "version": -1 });

// Create user with appropriate roles
db.createUser({
  user: "openedx_mongo_user",
  pwd: "${MONGODB_PASSWORD}",
  roles: [
    { role: "readWrite", db: "openedx" },
    { role: "readWrite", db: "cs_comment_service" },
    { role: "readWrite", db: "notifier" }
  ]
});

// Create backup user
db.createUser({
  user: "backup_user",
  pwd: "${BACKUP_PASSWORD}",
  roles: [
    { role: "backup", db: "admin" },
    { role: "read", db: "openedx" }
  ]
});
