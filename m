MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <a3c71579-4238-0967-b61d-522859f740aa@digikod.net>
References: <20170328234650.19695-1-mic@digikod.net> <20170328234650.19695-7-mic@digikod.net>
 <CAGXu5jJ36E8L9=sh62vPy+0t84Bx4n4Y9eiYZU+DtUZom1vpCQ@mail.gmail.com> <a3c71579-4238-0967-b61d-522859f740aa@digikod.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Apr 2017 16:48:16 -0700
Message-ID: <CAGXu5jJnsHXvvuqfb3Rcw7HvubUEPoNQUmUVuRoc4_hqPpg4WQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH net-next v6 06/11] seccomp,landlock: Handle Landlock
 events per process hierarchy
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Matthew Garrett <mjg59@srcf.ucam.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 18, 2017 at 4:24 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>=
 wrote:
> On 19/04/2017 00:53, Kees Cook wrote:
>> On Tue, Mar 28, 2017 at 4:46 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.n=
et> wrote:
>>> +#ifdef CONFIG_SECCOMP_FILTER
>>
>> Isn't CONFIG_SECCOMP_FILTER already required for landlock?
>
> Yes it is, but Landlock could only/also be used through cgroups in the
> future. :)

Hm, okay. I still feel like the configs could be more sensible. :)

>>> @@ -1405,7 +1409,13 @@ static void copy_seccomp(struct task_struct *p)
>>>
>>>         /* Ref-count the new filter user, and assign it. */
>>>         get_seccomp_filter(current);
>>> -       p->seccomp =3D current->seccomp;
>>> +       p->seccomp.mode =3D current->seccomp.mode;
>>> +       p->seccomp.filter =3D current->seccomp.filter;
>>> +#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_SECURITY_LANDLOCK=
)
>>> +       p->seccomp.landlock_events =3D current->seccomp.landlock_events=
;
>>> +       if (p->seccomp.landlock_events)
>>> +               atomic_inc(&p->seccomp.landlock_events->usage);
>>> +#endif /* CONFIG_SECCOMP_FILTER && CONFIG_SECURITY_LANDLOCK */
>>
>> Hrm. So, this needs config cleanup as above. Also, I'm going to need
>> some help understanding the usage tracking on landlock_events (which
>> should use a get/put rather than open-coding the _inc). I don't see
>> why individual assignments are needed here. The only thing that
>> matters is the usage bump. I would have expected no changes at all in
>> this code, actually. The filter and the events share the same usage
>> don't they?
>
> Right, I can move the struct landlock_event into the struct
> seccomp_filter. This should make the code cleaner.

No, that wasn't my point. I meant that since landlock_events is
already in ->seccomp, it's already copied by p->seccomp =3D
current->seccomp. The only thing you need is a
get_seccomp_landlock(current) call before the copy:

get_seccomp_filter(current);
get_seccomp_landlock(current);
p->seccomp =3D current->seccomp;

done! :)

And get_seccomp_landlock() can do a check for landlock_events existing, etc=
 etc.

>>> +       if (!new_events) {
>>> +               /*
>>> +                * If there is no Landlock events used by the current t=
ask,
>>> +                * then create a new one.
>>> +                */
>>> +               new_events =3D new_landlock_events();
>>> +               if (IS_ERR(new_events))
>>> +                       goto put_rule;
>>
>> Shouldn't bpf_prog_put() get called in the face of a rule failure too?
>> Why separate exit paths?
>
> You're right but put_landlock_rule() call bpf_prog_put() by itself.

Ah! Missed that, thanks!

>>> +       } else if (atomic_read(&current_events->usage) > 1) {
>>> +               /*
>>> +                * If the current task is not the sole user of its Land=
lock
>>> +                * events, then duplicate them.
>>> +                */
>>> +               size_t i;
>>> +
>>> +               new_events =3D new_landlock_events();
>>> +               if (IS_ERR(new_events))
>>> +                       goto put_rule;
>>> +               for (i =3D 0; i < ARRAY_SIZE(new_events->rules); i++) {
>>> +                       new_events->rules[i] =3D
>>> +                               lockless_dereference(current_events->ru=
les[i]);
>>> +                       if (new_events->rules[i])
>>> +                               atomic_inc(&new_events->rules[i]->usage=
);
>>
>> I was going to ask: isn't the top-level usage counter sufficient to
>> track rule lifetime? But I think I see how things are tracked now:
>> each task_struct points to an array of rule list pointers. These
>> tables are duplicated when additions are made (which means each table
>> needs to be refcounted for the processes using it), and when a new
>> table is created, all the refcounters on the rules are bumped (to
>> track each table that references the rule), and when a new rule is
>> added, it's just prepended to the list for the new table to point at.
>
> That's right.

Okay, excellent. This should end up in a comment somewhere so when I
forget I can go read it again. ;)

>> Does this mean that rules are processed in reverse?
>
> Yes, the rules are processed from the newest to the oldest, as
> seccomp-bpf does with filters.

Cool. If not already mentioned, that should end up in the docs somewhere.

>>> +       if (copy_from_user(&bpf_fd, user_bpf_fd, sizeof(bpf_fd)))
>>> +               return -EFAULT;
>>
>> I think this can just be get_user()?
>
> Yes, I didn't know about that.

No worries. It's nice for small things. :)

>>> +       prog =3D bpf_prog_get(bpf_fd);
>>> +       if (IS_ERR(prog))
>>> +               return PTR_ERR(prog);
>>> +
>>> +       /*
>>> +        * We don't need to lock anything for the current process hiera=
rchy,
>>> +        * everything is guarded by the atomic counters.
>>> +        */
>>> +       new_events =3D landlock_append_prog(current->seccomp.landlock_e=
vents,
>>> +                       prog);
>>> +       /* @prog is managed/freed by landlock_append_prog() */
>>
>> Does kmemcheck notice this "leak"? (i.e. is further annotation needed?)
>
> I didn't enable kmemcheck, I will take a look at it.

Yeah, I'd turn on at least these while you're testing:

CONFIG_PROVE_LOCKING=3Dy
CONFIG_DEBUG_ATOMIC_SLEEP=3Dy
CONFIG_DEBUG_KMEMLEAK=3Dy

I'm sure people will suggest more, too. :)

-Kees

--=20
Kees Cook
Pixel Security
