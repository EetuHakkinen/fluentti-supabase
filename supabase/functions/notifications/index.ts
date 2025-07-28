import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'npm:@supabase/supabase-js@2'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

enum NotificationConditions {
  EQ='EQ',
  LT='LT',
  GT='GT',
  GTN='GTN',
  LTN='LTN',
  LTE='LTE',
  GTE='GTE',
  NEQ='NEQ'
}

enum NotificationVariable {
  STREAK='STREAK',
  HOURS_FROM_LAST_EXERCISE='HOURS_FROM_LAST_EXERCISE',
  HOURS_FROM_LAST_NOTIFICATION='HOURS_FROM_LAST_NOTIFICATION',
  HOURS_FROM_LAST_NOTIFICATION_OPENED='HOURS_FROM_LAST_NOTIFICATION_OPENED',
  TIME_HOURS='TIME_HOURS'
}

const dateDiffInHours = (firstDate: Date, secondDate: Date) => {
  if (!firstDate || !secondDate) return null;
  return (
    Math.abs(firstDate.getTime() - secondDate.getTime()) / (60 * 60 * 1000)
  );
};

const timeFromNow = (date: Date) => dateDiffInHours(date, new Date());

const getLastExerciseForUser = (user: any) => {
  const lastExercise = user.v2_answers[0];

  if (!lastExercise || !lastExercise?.createdAt ) return null;

  return timeFromNow(new Date(lastExercise?.createdAt));
};

const getLastNotificationForUser = (user: any) => {
  const lastNotification = user.sentNotification[0];
  if (!lastNotification) return null;
  return timeFromNow(new Date(lastNotification.createdAt));
};

const getLastNotificationOpenedForUser = (user: any) => {
  const lastNotification = user.sentNotification.find(n => n.opened);
  if (!lastNotification?.opened) return null;
  return timeFromNow(new Date(lastNotification.createdAt));
};

const getStreakForUser = (user: any) => {
  const dateArray = user.v2_answers.map(ans => ans.createdAt);
  const streak = dateArray.reduce((p,day,i,arr) => {
    if ( arr[i+1]?.valueOf() == day.valueOf() ) return p;
    // Streak is valid if studying is maximum of 40h apart (144000000ms)
    if ( arr[i+1]?.valueOf() - day.valueOf() < 144000000 ) { 
      p[p.length - 1].push(arr[i+1]); 
    } else { 
      p.push([]) 
    }
    return p;
  },[]).sort((a,b) => a.length - b.length).pop();

  return streak;
}

const getTimeHours = () => {
  return new Date().getHours();
};

const checkConditions = (
  condition: notificationCondition,
  variables: Record<NotificationVariable, number | null>
) => {
  if (!condition.variable || !condition.value) return false;
  // This is a backup to prevent sending spam.
  const hoursFromLastNotification =
    variables[NotificationVariable.HOURS_FROM_LAST_NOTIFICATION];
  if (hoursFromLastNotification != null && hoursFromLastNotification < 5) {
    console.info(
      "Spam reduction blocked notification:",
      condition.notificationId
    );
    return false;
  }
  const variableValue = variables[condition.variable];
  switch (condition.condition) {
    case NotificationConditions.EQ:
      return variables[condition.variable] === condition.value;
    case NotificationConditions.GT:
      if (variableValue === null) return false;
      return variableValue > condition.value;
    case NotificationConditions.GTN:
      if (variableValue === null) return true;
      return variableValue > condition.value;
    case NotificationConditions.GTE:
      if (variableValue === null) return false;
      return variableValue >= condition.value;
    case NotificationConditions.LT:
      if (variableValue === null) return false;
      return variableValue < condition.value;
    case NotificationConditions.LTN:
      if (variableValue === null) return true;
      return variableValue < condition.value;
    case NotificationConditions.LTE:
      if (variableValue === null) return false;
      return variableValue <= condition.value;
    case NotificationConditions.NEQ:
      return variableValue !== condition.value;
    default:
      return false;
  }
};

const handleNotificationText = (
  param: string,
  variables: Record<NotificationVariable, number | null>
) => {
  const streakValue = variables[NotificationVariable.STREAK];
  return param.replaceAll(
    "/streak",
    streakValue !== null ? streakValue.toString() : ""
  );
};

Deno.serve(async (req) => {
  const { data : users } = await supabase
    .from('users')
    .select('id, expo_push_token, sentNotification(*), v2_answers(*)')
    .not('expo_push_token', 'is', null)
    .order("createdAt", { referencedTable: "sentNotification", ascending: false })
    .order("createdAt", { referencedTable: "v2_answers", ascending: false });

  const { data : notifications } = await supabase
    .from('notification')
    .select('*, notificationCondition(*)');

  const notificationsToSend = [];

  await users.map(async user => {
    const variables = {
      [NotificationVariable.HOURS_FROM_LAST_EXERCISE]:
        getLastExerciseForUser(user),
      [NotificationVariable.HOURS_FROM_LAST_NOTIFICATION]:
        getLastNotificationForUser(user),
      [NotificationVariable.HOURS_FROM_LAST_NOTIFICATION_OPENED]:
        getLastNotificationOpenedForUser(user),
      [NotificationVariable.TIME_HOURS]: getTimeHours(),
      [NotificationVariable.STREAK]: getStreakForUser(user),
    };
    console.log(variables);
    const notsToSend = notifications.filter((notification) => {
      const checkedConditions = notification.notificationCondition.filter(
        (condition) => checkConditions(condition, variables)
      );
      return (
        checkedConditions.length === notification.notificationCondition.length
      );
    });

    if (notsToSend.length > 0) {
      notificationsToSend.push({
        notification: notsToSend[0], user
      });
    }
  });

  console.log(notificationsToSend);

  const res = await fetch("https://exp.host/--/api/v2/push/send", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      //Authorization: `Bearer ${Deno.env.EXPO_ACCESS_TOKEN}`,
    },
    body: JSON.stringify(notificationsToSend.filter(nts => nts.user && nts.notification).map(nts => ({
      to: nts.user.expo_push_token, 
      sound: 'default', 
      body: nts.notification.title
    }))),
  }).then(res => res.json());
  console.log(res);

  await notificationsToSend.filter(nts => nts.user && nts.notification).map(async nts => {
    return await supabase.from('sentNotification').insert({usersId: nts.user.id, notificationId: nts.notification.id });
  })

  return new Response(JSON.stringify({status: 'ok', notificationsSent: notificationsToSend.length}), {
    headers: { 'Content-Type': 'application/json' },
  });
});
