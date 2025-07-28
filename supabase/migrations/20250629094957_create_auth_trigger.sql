create trigger create_public_user_after_auth
after insert on auth.users
for each row
execute function create_public_user();