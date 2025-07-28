create extension if not exists "pgjwt" with schema "extensions";


create type "public"."ExerciseType" as enum ('WORD', 'WRITE', 'SENTENCE', 'LISTEN', 'SPEAK');

create type "public"."LessonLevel" as enum ('EASY', 'MEDIUM', 'ADVANCED', 'NONE');

create type "public"."NotificationConditions" as enum ('EQ', 'LT', 'GT', 'LTE', 'GTE', 'NEQ', 'GTN', 'LTN');

create type "public"."NotificationVariable" as enum ('STREAK', 'HOURS_FROM_LAST_EXERCISE', 'HOURS_FROM_LAST_NOTIFICATION', 'HOURS_FROM_LAST_NOTIFICATION_OPENED', 'TIME_HOURS');

create type "public"."SectionType" as enum ('EXERCISE', 'RECALL');

create sequence "public"."ai_log_id_seq";

create sequence "public"."analytics_id_seq";

create sequence "public"."answers_id_seq";

create sequence "public"."app_version_id_seq";

create sequence "public"."blog_id_seq";

create sequence "public"."challenge_id_seq";

create sequence "public"."dictionary_id_seq";

create sequence "public"."exercise_id_seq";

create sequence "public"."feedback_id_seq";

create sequence "public"."file_id_seq";

create sequence "public"."gpt_id_seq";

create sequence "public"."grammar_id_seq";

create sequence "public"."lessons_id_seq";

create sequence "public"."mistakes_id_seq";

create sequence "public"."notificationCondition_id_seq";

create sequence "public"."notification_id_seq";

create sequence "public"."section_complete_id_seq";

create sequence "public"."section_id_seq";

create sequence "public"."sentNotification_id_seq";

create sequence "public"."sentence_id_seq";

create sequence "public"."users_id_seq";

create sequence "public"."v2_answers_id_seq";

create sequence "public"."v2_lessons_id_seq";

create sequence "public"."vocabulary_id_seq";

create sequence "public"."word_id_seq";

create table "public"."_prisma_migrations" (
    "id" character varying(36) not null,
    "checksum" character varying(64) not null,
    "finished_at" timestamp with time zone,
    "migration_name" character varying(255) not null,
    "logs" text,
    "rolled_back_at" timestamp with time zone,
    "started_at" timestamp with time zone not null default now(),
    "applied_steps_count" integer not null default 0
);


create table "public"."ai_log" (
    "id" integer not null default nextval('ai_log_id_seq'::regclass),
    "command" text,
    "content" text,
    "lesson_id" integer,
    "created_at" timestamp without time zone default now()
);


create table "public"."analytics" (
    "id" integer not null default nextval('analytics_id_seq'::regclass),
    "date" date,
    "page" text,
    "user_id" integer,
    "views" integer
);


create table "public"."answers" (
    "id" integer not null default nextval('answers_id_seq'::regclass),
    "correct" boolean,
    "user_id" integer not null,
    "vocabulary_id" integer not null,
    "created_at" timestamp without time zone not null default now(),
    "status" integer default 1,
    "recall" timestamp without time zone,
    "updated_at" timestamp without time zone default now(),
    "createdat" character varying(50)
);


create table "public"."app_version" (
    "id" integer not null default nextval('app_version_id_seq'::regclass),
    "ios_version" text,
    "android_version" text,
    "created_at" timestamp without time zone default now()
);


alter table "public"."app_version" enable row level security;

create table "public"."blog" (
    "id" integer not null default nextval('blog_id_seq'::regclass),
    "uid" text,
    "name" text,
    "content" text,
    "public" boolean default false,
    "createdAt" timestamp without time zone default now(),
    "upadtedAt" timestamp without time zone default now(),
    "image" text,
    "updatedAt" timestamp without time zone default now(),
    "keywords" text,
    "description" text
);


create table "public"."challenge" (
    "id" integer not null default nextval('challenge_id_seq'::regclass),
    "name" text,
    "code" text,
    "user_id" integer
);


create table "public"."dictionary" (
    "id" integer not null default nextval('dictionary_id_seq'::regclass),
    "title" text,
    "lang" text,
    "sections" json,
    "url" text
);


create table "public"."exercise" (
    "id" integer not null default nextval('exercise_id_seq'::regclass),
    "type" "ExerciseType" not null,
    "section_id" integer not null,
    "sentence_id" integer,
    "word_id" integer,
    "order" integer not null,
    "createdAt" timestamp(3) without time zone not null default CURRENT_TIMESTAMP
);


alter table "public"."exercise" enable row level security;

create table "public"."feedback" (
    "id" integer not null default nextval('feedback_id_seq'::regclass),
    "user" integer,
    "lesson" integer,
    "vocabulary" integer,
    "feedback" text,
    "checked" boolean,
    "createdAt" timestamp without time zone default now(),
    "exerciseId" integer,
    "sectionId" integer
);


create table "public"."file" (
    "id" integer not null default nextval('file_id_seq'::regclass),
    "type" text not null,
    "filename" text not null,
    "size" integer not null,
    "customUpload" boolean not null default false,
    "createdAt" timestamp(3) without time zone not null default CURRENT_TIMESTAMP
);


alter table "public"."file" enable row level security;

create table "public"."gpt" (
    "id" integer not null default nextval('gpt_id_seq'::regclass),
    "user_id" integer,
    "text" text,
    "feedback" text,
    "usage" json,
    "createdat" timestamp without time zone default CURRENT_TIMESTAMP,
    "type" text,
    "vocabulary_id" integer
);


create table "public"."grammar" (
    "id" integer not null default nextval('grammar_id_seq'::regclass),
    "name" text,
    "content" text,
    "lesson_id" integer
);


create table "public"."lessons" (
    "id" integer not null default nextval('lessons_id_seq'::regclass),
    "name" character varying(50),
    "description" text,
    "level" text,
    "order" integer,
    "user_id" integer,
    "image" text,
    "grammar" boolean
);


create table "public"."mistakes" (
    "id" integer not null default nextval('mistakes_id_seq'::regclass),
    "user_id" integer,
    "vocabulary_id" integer,
    "answer" text,
    "createdAt" timestamp without time zone default now(),
    "type" text,
    "checked" boolean default false
);


create table "public"."notification" (
    "id" integer not null default nextval('notification_id_seq'::regclass),
    "title" text,
    "text" text,
    "linkTo" text,
    "public" boolean not null default false,
    "createdAt" timestamp(3) without time zone not null default CURRENT_TIMESTAMP,
    "iconId" integer,
    "imageId" integer
);


create table "public"."notificationCondition" (
    "id" integer not null default nextval('"notificationCondition_id_seq"'::regclass),
    "variable" "NotificationVariable",
    "condition" "NotificationConditions",
    "value" integer,
    "notificationId" integer not null,
    "createdAt" timestamp(3) without time zone not null default CURRENT_TIMESTAMP
);


create table "public"."section" (
    "id" integer not null default nextval('section_id_seq'::regclass),
    "order" integer not null,
    "lesson_id" integer not null,
    "type" "SectionType" not null default 'EXERCISE'::"SectionType"
);


alter table "public"."section" enable row level security;

create table "public"."section_complete" (
    "id" integer not null default nextval('section_complete_id_seq'::regclass),
    "usersId" integer,
    "createdAt" timestamp(3) without time zone not null default CURRENT_TIMESTAMP,
    "sectionId" integer not null,
    "supabaseUser" uuid
);


alter table "public"."section_complete" enable row level security;

create table "public"."sentNotification" (
    "id" integer not null default nextval('"sentNotification_id_seq"'::regclass),
    "usersId" integer not null,
    "notificationId" integer not null,
    "createdAt" timestamp(3) without time zone not null default CURRENT_TIMESTAMP,
    "opened" timestamp(3) without time zone
);


create table "public"."sentence" (
    "id" integer not null default nextval('sentence_id_seq'::regclass),
    "sentence" text not null,
    "translation" text not null,
    "word_id" integer not null,
    "audioId" integer,
    "imageId" integer
);


alter table "public"."sentence" enable row level security;

create table "public"."users" (
    "id" integer not null default nextval('users_id_seq'::regclass),
    "name" character varying(100),
    "email" character varying(100),
    "password" character varying(100),
    "admin" boolean default false,
    "daily_target" integer not null default 50,
    "notification_subscription" json,
    "learning_rate" real not null default 6,
    "level" text default ''::text,
    "speaking" boolean not null default true,
    "campaign" text,
    "marketing" boolean default true,
    "grammar_learning_rate" real,
    "createdat" timestamp without time zone default now(),
    "stripeCustomer" text,
    "subValid" timestamp without time zone,
    "googlesub" text,
    "streak" integer default 0,
    "affiliateCoupon" text,
    "challenge" text,
    "subStatus" text,
    "supabase_id" uuid,
    "expo_push_token" text
);


alter table "public"."users" enable row level security;

create table "public"."v2_answers" (
    "id" integer not null default nextval('v2_answers_id_seq'::regclass),
    "correct" boolean not null,
    "answer" text,
    "createdAt" timestamp(3) without time zone not null default CURRENT_TIMESTAMP,
    "sectionId" integer not null,
    "exerciseId" integer not null,
    "usersId" integer,
    "supabaseUser" uuid
);


alter table "public"."v2_answers" enable row level security;

create table "public"."v2_lessons" (
    "id" integer not null default nextval('v2_lessons_id_seq'::regclass),
    "name" text,
    "description" text,
    "level" "LessonLevel",
    "order" integer not null,
    "imageId" integer
);


alter table "public"."v2_lessons" enable row level security;

create table "public"."vocabulary" (
    "id" integer not null default nextval('vocabulary_id_seq'::regclass),
    "word" text,
    "translation" text,
    "example" text,
    "example_translation" text,
    "image" text,
    "lesson_id" integer,
    "audio" text,
    "sources" text,
    "example_audio" text,
    "alternatives" jsonb default '[]'::json,
    "explanation" text
);


create table "public"."word" (
    "id" integer not null default nextval('word_id_seq'::regclass),
    "word" text not null,
    "translation" text not null,
    "lesson_id" integer not null,
    "audioId" integer,
    "imageId" integer
);


alter table "public"."word" enable row level security;

alter sequence "public"."ai_log_id_seq" owned by "public"."ai_log"."id";

alter sequence "public"."analytics_id_seq" owned by "public"."analytics"."id";

alter sequence "public"."answers_id_seq" owned by "public"."answers"."id";

alter sequence "public"."app_version_id_seq" owned by "public"."app_version"."id";

alter sequence "public"."blog_id_seq" owned by "public"."blog"."id";

alter sequence "public"."challenge_id_seq" owned by "public"."challenge"."id";

alter sequence "public"."dictionary_id_seq" owned by "public"."dictionary"."id";

alter sequence "public"."exercise_id_seq" owned by "public"."exercise"."id";

alter sequence "public"."feedback_id_seq" owned by "public"."feedback"."id";

alter sequence "public"."file_id_seq" owned by "public"."file"."id";

alter sequence "public"."gpt_id_seq" owned by "public"."gpt"."id";

alter sequence "public"."grammar_id_seq" owned by "public"."grammar"."id";

alter sequence "public"."lessons_id_seq" owned by "public"."lessons"."id";

alter sequence "public"."mistakes_id_seq" owned by "public"."mistakes"."id";

alter sequence "public"."notificationCondition_id_seq" owned by "public"."notificationCondition"."id";

alter sequence "public"."notification_id_seq" owned by "public"."notification"."id";

alter sequence "public"."section_complete_id_seq" owned by "public"."section_complete"."id";

alter sequence "public"."section_id_seq" owned by "public"."section"."id";

alter sequence "public"."sentNotification_id_seq" owned by "public"."sentNotification"."id";

alter sequence "public"."sentence_id_seq" owned by "public"."sentence"."id";

alter sequence "public"."users_id_seq" owned by "public"."users"."id";

alter sequence "public"."v2_answers_id_seq" owned by "public"."v2_answers"."id";

alter sequence "public"."v2_lessons_id_seq" owned by "public"."v2_lessons"."id";

alter sequence "public"."vocabulary_id_seq" owned by "public"."vocabulary"."id";

alter sequence "public"."word_id_seq" owned by "public"."word"."id";

CREATE UNIQUE INDEX _prisma_migrations_pkey ON public._prisma_migrations USING btree (id);

CREATE UNIQUE INDEX ai_log_pkey ON public.ai_log USING btree (id);

CREATE UNIQUE INDEX answers_pkey ON public.answers USING btree (id);

CREATE UNIQUE INDEX app_version_pkey ON public.app_version USING btree (id);

CREATE UNIQUE INDEX blog_pkey ON public.blog USING btree (id);

CREATE UNIQUE INDEX blog_uid_key ON public.blog USING btree (uid);

CREATE UNIQUE INDEX challenge_pkey ON public.challenge USING btree (id);

CREATE UNIQUE INDEX dictionary_pkey ON public.dictionary USING btree (id);

CREATE UNIQUE INDEX exercise_pkey ON public.exercise USING btree (id);

CREATE UNIQUE INDEX feedback_pkey ON public.feedback USING btree (id);

CREATE UNIQUE INDEX file_filename_key ON public.file USING btree (filename);

CREATE UNIQUE INDEX file_pkey ON public.file USING btree (id);

CREATE UNIQUE INDEX grammar_pkey ON public.grammar USING btree (id);

CREATE UNIQUE INDEX grammarcheck_pkey ON public.gpt USING btree (id);

CREATE INDEX idx_dictionary_lang_title ON public.dictionary USING btree (lang, title);

CREATE INDEX idx_dictionary_title ON public.dictionary USING btree (title);

CREATE INDEX idx_dictionary_url ON public.dictionary USING btree (url);

CREATE UNIQUE INDEX lessons_pkey ON public.lessons USING btree (id);

CREATE UNIQUE INDEX mistakes_pkey ON public.mistakes USING btree (id);

CREATE UNIQUE INDEX "notificationCondition_pkey" ON public."notificationCondition" USING btree (id);

CREATE UNIQUE INDEX notification_pkey ON public.notification USING btree (id);

CREATE UNIQUE INDEX section_complete_pkey ON public.section_complete USING btree (id);

CREATE UNIQUE INDEX section_pkey ON public.section USING btree (id);

CREATE UNIQUE INDEX "sentNotification_pkey" ON public."sentNotification" USING btree (id);

CREATE UNIQUE INDEX sentence_pkey ON public.sentence USING btree (id);

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

CREATE INDEX users_supabase_id ON public.users USING btree (supabase_id);

CREATE UNIQUE INDEX v2_answers_pkey ON public.v2_answers USING btree (id);

CREATE UNIQUE INDEX v2_lessons_pkey ON public.v2_lessons USING btree (id);

CREATE UNIQUE INDEX vocabulary_pkey ON public.vocabulary USING btree (id);

CREATE UNIQUE INDEX word_pkey ON public.word USING btree (id);

alter table "public"."_prisma_migrations" add constraint "_prisma_migrations_pkey" PRIMARY KEY using index "_prisma_migrations_pkey";

alter table "public"."ai_log" add constraint "ai_log_pkey" PRIMARY KEY using index "ai_log_pkey";

alter table "public"."answers" add constraint "answers_pkey" PRIMARY KEY using index "answers_pkey";

alter table "public"."app_version" add constraint "app_version_pkey" PRIMARY KEY using index "app_version_pkey";

alter table "public"."blog" add constraint "blog_pkey" PRIMARY KEY using index "blog_pkey";

alter table "public"."challenge" add constraint "challenge_pkey" PRIMARY KEY using index "challenge_pkey";

alter table "public"."dictionary" add constraint "dictionary_pkey" PRIMARY KEY using index "dictionary_pkey";

alter table "public"."exercise" add constraint "exercise_pkey" PRIMARY KEY using index "exercise_pkey";

alter table "public"."feedback" add constraint "feedback_pkey" PRIMARY KEY using index "feedback_pkey";

alter table "public"."file" add constraint "file_pkey" PRIMARY KEY using index "file_pkey";

alter table "public"."gpt" add constraint "grammarcheck_pkey" PRIMARY KEY using index "grammarcheck_pkey";

alter table "public"."grammar" add constraint "grammar_pkey" PRIMARY KEY using index "grammar_pkey";

alter table "public"."lessons" add constraint "lessons_pkey" PRIMARY KEY using index "lessons_pkey";

alter table "public"."mistakes" add constraint "mistakes_pkey" PRIMARY KEY using index "mistakes_pkey";

alter table "public"."notification" add constraint "notification_pkey" PRIMARY KEY using index "notification_pkey";

alter table "public"."notificationCondition" add constraint "notificationCondition_pkey" PRIMARY KEY using index "notificationCondition_pkey";

alter table "public"."section" add constraint "section_pkey" PRIMARY KEY using index "section_pkey";

alter table "public"."section_complete" add constraint "section_complete_pkey" PRIMARY KEY using index "section_complete_pkey";

alter table "public"."sentNotification" add constraint "sentNotification_pkey" PRIMARY KEY using index "sentNotification_pkey";

alter table "public"."sentence" add constraint "sentence_pkey" PRIMARY KEY using index "sentence_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."v2_answers" add constraint "v2_answers_pkey" PRIMARY KEY using index "v2_answers_pkey";

alter table "public"."v2_lessons" add constraint "v2_lessons_pkey" PRIMARY KEY using index "v2_lessons_pkey";

alter table "public"."vocabulary" add constraint "vocabulary_pkey" PRIMARY KEY using index "vocabulary_pkey";

alter table "public"."word" add constraint "word_pkey" PRIMARY KEY using index "word_pkey";

alter table "public"."ai_log" add constraint "ai_log_lesson_id_fkey" FOREIGN KEY (lesson_id) REFERENCES lessons(id) not valid;

alter table "public"."ai_log" validate constraint "ai_log_lesson_id_fkey";

alter table "public"."analytics" add constraint "analytics_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."analytics" validate constraint "analytics_user_id_fkey";

alter table "public"."answers" add constraint "answers_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."answers" validate constraint "answers_user_id_fkey";

alter table "public"."answers" add constraint "answers_vocabulary_id_fkey" FOREIGN KEY (vocabulary_id) REFERENCES vocabulary(id) ON DELETE CASCADE not valid;

alter table "public"."answers" validate constraint "answers_vocabulary_id_fkey";

alter table "public"."blog" add constraint "blog_uid_key" UNIQUE using index "blog_uid_key";

alter table "public"."challenge" add constraint "challenge_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL not valid;

alter table "public"."challenge" validate constraint "challenge_user_id_fkey";

alter table "public"."exercise" add constraint "exercise_section_id_fkey" FOREIGN KEY (section_id) REFERENCES section(id) ON DELETE CASCADE not valid;

alter table "public"."exercise" validate constraint "exercise_section_id_fkey";

alter table "public"."exercise" add constraint "exercise_sentence_id_fkey" FOREIGN KEY (sentence_id) REFERENCES sentence(id) ON DELETE CASCADE not valid;

alter table "public"."exercise" validate constraint "exercise_sentence_id_fkey";

alter table "public"."exercise" add constraint "exercise_word_id_fkey" FOREIGN KEY (word_id) REFERENCES word(id) ON DELETE CASCADE not valid;

alter table "public"."exercise" validate constraint "exercise_word_id_fkey";

alter table "public"."feedback" add constraint "feedback_exerciseId_fkey" FOREIGN KEY ("exerciseId") REFERENCES exercise(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."feedback" validate constraint "feedback_exerciseId_fkey";

alter table "public"."feedback" add constraint "feedback_lesson_fkey" FOREIGN KEY (lesson) REFERENCES lessons(id) not valid;

alter table "public"."feedback" validate constraint "feedback_lesson_fkey";

alter table "public"."feedback" add constraint "feedback_sectionId_fkey" FOREIGN KEY ("sectionId") REFERENCES section(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."feedback" validate constraint "feedback_sectionId_fkey";

alter table "public"."feedback" add constraint "feedback_user_fkey" FOREIGN KEY ("user") REFERENCES users(id) not valid;

alter table "public"."feedback" validate constraint "feedback_user_fkey";

alter table "public"."feedback" add constraint "feedback_vocabulary_fkey" FOREIGN KEY (vocabulary) REFERENCES vocabulary(id) not valid;

alter table "public"."feedback" validate constraint "feedback_vocabulary_fkey";

alter table "public"."gpt" add constraint "gpt_vocabulary_id_fkey" FOREIGN KEY (vocabulary_id) REFERENCES vocabulary(id) not valid;

alter table "public"."gpt" validate constraint "gpt_vocabulary_id_fkey";

alter table "public"."gpt" add constraint "grammarcheck_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."gpt" validate constraint "grammarcheck_user_id_fkey";

alter table "public"."grammar" add constraint "grammar_lesson_id_fkey" FOREIGN KEY (lesson_id) REFERENCES lessons(id) not valid;

alter table "public"."grammar" validate constraint "grammar_lesson_id_fkey";

alter table "public"."lessons" add constraint "lessons_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."lessons" validate constraint "lessons_user_id_fkey";

alter table "public"."mistakes" add constraint "mistakes_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."mistakes" validate constraint "mistakes_user_id_fkey";

alter table "public"."mistakes" add constraint "mistakes_vocabulary_id_fkey" FOREIGN KEY (vocabulary_id) REFERENCES vocabulary(id) ON DELETE CASCADE not valid;

alter table "public"."mistakes" validate constraint "mistakes_vocabulary_id_fkey";

alter table "public"."notification" add constraint "notification_iconId_fkey" FOREIGN KEY ("iconId") REFERENCES file(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."notification" validate constraint "notification_iconId_fkey";

alter table "public"."notification" add constraint "notification_imageId_fkey" FOREIGN KEY ("imageId") REFERENCES file(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."notification" validate constraint "notification_imageId_fkey";

alter table "public"."notificationCondition" add constraint "notificationCondition_notificationId_fkey" FOREIGN KEY ("notificationId") REFERENCES notification(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."notificationCondition" validate constraint "notificationCondition_notificationId_fkey";

alter table "public"."section" add constraint "section_lesson_id_fkey" FOREIGN KEY (lesson_id) REFERENCES v2_lessons(id) ON DELETE CASCADE not valid;

alter table "public"."section" validate constraint "section_lesson_id_fkey";

alter table "public"."section_complete" add constraint "section_complete_sectionId_fkey" FOREIGN KEY ("sectionId") REFERENCES section(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."section_complete" validate constraint "section_complete_sectionId_fkey";

alter table "public"."section_complete" add constraint "section_complete_supabaseUser_fkey" FOREIGN KEY ("supabaseUser") REFERENCES auth.users(id) not valid;

alter table "public"."section_complete" validate constraint "section_complete_supabaseUser_fkey";

alter table "public"."section_complete" add constraint "section_complete_usersId_fkey" FOREIGN KEY ("usersId") REFERENCES users(id) ON UPDATE CASCADE not valid;

alter table "public"."section_complete" validate constraint "section_complete_usersId_fkey";

alter table "public"."sentNotification" add constraint "sentNotification_notificationId_fkey" FOREIGN KEY ("notificationId") REFERENCES notification(id) ON UPDATE CASCADE not valid;

alter table "public"."sentNotification" validate constraint "sentNotification_notificationId_fkey";

alter table "public"."sentNotification" add constraint "sentNotification_usersId_fkey" FOREIGN KEY ("usersId") REFERENCES users(id) ON UPDATE CASCADE not valid;

alter table "public"."sentNotification" validate constraint "sentNotification_usersId_fkey";

alter table "public"."sentence" add constraint "sentence_audioId_fkey" FOREIGN KEY ("audioId") REFERENCES file(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."sentence" validate constraint "sentence_audioId_fkey";

alter table "public"."sentence" add constraint "sentence_imageId_fkey" FOREIGN KEY ("imageId") REFERENCES file(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."sentence" validate constraint "sentence_imageId_fkey";

alter table "public"."sentence" add constraint "sentence_word_id_fkey" FOREIGN KEY (word_id) REFERENCES word(id) ON DELETE CASCADE not valid;

alter table "public"."sentence" validate constraint "sentence_word_id_fkey";

alter table "public"."users" add constraint "users_email_key" UNIQUE using index "users_email_key";

alter table "public"."users" add constraint "users_supabase_id_fkey" FOREIGN KEY (supabase_id) REFERENCES auth.users(id) not valid;

alter table "public"."users" validate constraint "users_supabase_id_fkey";

alter table "public"."v2_answers" add constraint "v2_answers_exerciseId_fkey" FOREIGN KEY ("exerciseId") REFERENCES exercise(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."v2_answers" validate constraint "v2_answers_exerciseId_fkey";

alter table "public"."v2_answers" add constraint "v2_answers_sectionId_fkey" FOREIGN KEY ("sectionId") REFERENCES section(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."v2_answers" validate constraint "v2_answers_sectionId_fkey";

alter table "public"."v2_answers" add constraint "v2_answers_supabaseUser_fkey" FOREIGN KEY ("supabaseUser") REFERENCES auth.users(id) not valid;

alter table "public"."v2_answers" validate constraint "v2_answers_supabaseUser_fkey";

alter table "public"."v2_answers" add constraint "v2_answers_usersId_fkey" FOREIGN KEY ("usersId") REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."v2_answers" validate constraint "v2_answers_usersId_fkey";

alter table "public"."v2_lessons" add constraint "v2_lessons_imageId_fkey" FOREIGN KEY ("imageId") REFERENCES file(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."v2_lessons" validate constraint "v2_lessons_imageId_fkey";

alter table "public"."vocabulary" add constraint "fk_vocabulary_lessons" FOREIGN KEY (lesson_id) REFERENCES lessons(id) not valid;

alter table "public"."vocabulary" validate constraint "fk_vocabulary_lessons";

alter table "public"."word" add constraint "word_audioId_fkey" FOREIGN KEY ("audioId") REFERENCES file(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."word" validate constraint "word_audioId_fkey";

alter table "public"."word" add constraint "word_imageId_fkey" FOREIGN KEY ("imageId") REFERENCES file(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."word" validate constraint "word_imageId_fkey";

alter table "public"."word" add constraint "word_lesson_id_fkey" FOREIGN KEY (lesson_id) REFERENCES v2_lessons(id) ON DELETE CASCADE not valid;

alter table "public"."word" validate constraint "word_lesson_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_public_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  insert into public.users(supabase_id, email)
  values (new.id, new.email);
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.mark_section_complete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
    -- Check if the user has answered 5 or more questions in the section
    IF (
        SELECT COUNT(*) FROM v2_answers
        WHERE "supabaseUser" = NEW."supabaseUser" AND "sectionId" = NEW."sectionId"
    ) >= (
      SELECT CASE WHEN COUNT(*) > 0 THEN COUNT(*) ELSE 8 END FROM exercise
      WHERE "section_id" = NEW."sectionId"
    )
    THEN
        -- Only insert if not already completed
        IF NOT EXISTS (
            SELECT 1 FROM section_complete
            WHERE "supabaseUser" = NEW."supabaseUser" AND "sectionId" = NEW."sectionId"
        ) THEN
            INSERT INTO section_complete ("supabaseUser", "sectionId")
            VALUES (NEW."supabaseUser", NEW."sectionId");
        END IF;
    END IF;
    RETURN NULL; -- For AFTER INSERT triggers, return value is ignored.
END;$function$
;

create or replace view "public"."recall_exercises" as  SELECT a."supabaseUser",
    e.id,
    e.type,
    e.section_id,
    e.sentence_id,
    e.word_id,
    e."order",
    e."createdAt"
   FROM (v2_answers a
     LEFT JOIN exercise e ON ((e.id = a."exerciseId")))
  GROUP BY a."supabaseUser", e.id
  ORDER BY (sum(
        CASE
            WHEN a.correct THEN 1
            ELSE '-1'::integer
        END));


CREATE OR REPLACE FUNCTION public.subscription_valid()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$BEGIN
    RETURN TRUE;
END;$function$
;

grant select on table "public"."app_version" to "authenticated";

grant select on table "public"."exercise" to "authenticated";

grant select on table "public"."file" to "authenticated";

grant select on table "public"."section" to "authenticated";

grant insert on table "public"."section_complete" to "authenticated";

grant select on table "public"."section_complete" to "authenticated";

grant select on table "public"."sentence" to "authenticated";

grant select on table "public"."users" to "authenticated";

grant insert on table "public"."v2_answers" to "authenticated";

grant select on table "public"."v2_answers" to "authenticated";

grant select on table "public"."v2_lessons" to "authenticated";

grant select on table "public"."word" to "authenticated";

create policy "Enable read access for all users"
on "public"."app_version"
as permissive
for select
to authenticated
using (true);


create policy "Enable select for authenticated users only"
on "public"."exercise"
as permissive
for select
to authenticated
using (true);


create policy "Enable select for authenticated users only"
on "public"."file"
as permissive
for select
to authenticated
using (true);


create policy "Enable select for authenticated users only"
on "public"."section"
as permissive
for select
to authenticated
using (true);


create policy "Allow select own completions"
on "public"."section_complete"
as permissive
for select
to authenticated
using ((auth.uid() = "supabaseUser"));


create policy "Enable insert for user itself only"
on "public"."section_complete"
as permissive
for insert
to authenticated
with check ((auth.uid() = "supabaseUser"));


create policy "Enable select for authenticated users only"
on "public"."sentence"
as permissive
for select
to authenticated
using (true);


create policy "Enable select for user own data"
on "public"."users"
as permissive
for select
to authenticated
using ((auth.uid() = supabase_id));


create policy "Enable update for users based on uuid"
on "public"."users"
as permissive
for update
to authenticated
using ((auth.uid() = supabase_id));


create policy "Enable insert for authenticated users only"
on "public"."v2_answers"
as permissive
for insert
to authenticated
with check ((auth.uid() = "supabaseUser"));


create policy "Select own answers"
on "public"."v2_answers"
as permissive
for select
to public
using ((auth.uid() = "supabaseUser"));


create policy "Enable select for public lessons authenticated users only"
on "public"."v2_lessons"
as permissive
for select
to authenticated
using ((level <> 'NONE'::"LessonLevel"));


create policy "Enable select for authenticated users only"
on "public"."word"
as permissive
for select
to authenticated
using (true);


CREATE TRIGGER mark_section_completion_trigger AFTER INSERT ON public.v2_answers FOR EACH ROW EXECUTE FUNCTION mark_section_complete();


