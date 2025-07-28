alter table "public"."notification" enable row level security;

alter table "public"."notificationCondition" enable row level security;

alter table "public"."sentNotification" enable row level security;

CREATE UNIQUE INDEX users_supabase_id_key ON public.users USING btree (supabase_id);

alter table "public"."users" add constraint "users_supabase_id_key" UNIQUE using index "users_supabase_id_key";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_public_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$begin
  insert into public.users(supabase_id, email)
  values (new.id, new.email);
  return new;
end;$function$
;


