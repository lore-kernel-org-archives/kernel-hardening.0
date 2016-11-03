Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161103182441.GA29904@laptop.thejh.net>
References: <1478187038-19954-2-git-send-email-wluikil@gmail.com> <20161103182441.GA29904@laptop.thejh.net>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 3 Nov 2016 14:34:16 -0600
Message-ID: <CAGXu5jJ9d+hiHdS_Ge6H+Jxz3py-RNAEx626M9L2doSZ608LDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [2/2] procfs/tasks: add a simple per-task procfs hidepid= field
To: Jann Horn <jann@thejh.net>
Cc: Lafcadio Wluiki <wluikil@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 3, 2016 at 12:24 PM, Jann Horn <jann@thejh.net> wrote:
> On Thu, Nov 03, 2016 at 09:30:38AM -0600, Lafcadio Wluiki wrote:
>> This adds a new per-task hidepid= flag that is honored by procfs when
>> presenting /proc to the user, in addition to the existing hidepid= mount
>> option. So far, hidepid= was exclusively a per-pidns setting. Locking
>> down a set of processes so that they cannot see other user's processes
>> without affecting the rest of the system thus currently requires
>> creation of a private PID namespace, with all the complexity it brings,
>> including maintaining a stub init process as PID 1 and losing the
>> ability to see processes of the same user on the rest of the system.
> [...]
>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index 89d5be4..c0a1d3e 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -2270,6 +2270,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>>       case PR_GET_FP_MODE:
>>               error = GET_FP_MODE(me);
>>               break;
>> +     case PR_SET_HIDEPID:
>> +             if (arg2 < HIDEPID_OFF || arg2 > HIDEPID_INVISIBLE)
>> +                     return -EINVAL;
>> +             if (arg2 < me->hide_pid)
>> +                     return -EPERM;
>> +             me->hide_pid = arg2;
>> +             break;
>
> Should we test for ns_capable(CAP_SYS_ADMIN)||no_new_privs here?
> I think it wouldn't hurt, and I'd like to avoid adding new ways in which
> the execution of setuid programs can be influenced. OTOH, people already
> use hidepid now, and it's not an issue... I'm not sure. Opinions?

Hrrm, I'm really on the fence. I don't feel like having things in
/proc go invisible for a setuid would be bad, but I wouldn't be
surprised to eat my words. :) On the other hand, I can't think of a
place where this requirement would create a problem.

e.g. init launching a web server as root could set nnp and this, and
it would still be able to switch down to www-data, etc. If someone has
www-data in their /etc/sudoers file, I already fear for their sanity.
;)

-Kees

-- 
Kees Cook
Nexus Security
