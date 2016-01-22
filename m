Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAP145piccauJvW6JrVzxm1xM3_5xtMk_Fa+uwFx-84+dKCS0WQ@mail.gmail.com>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<1453502345-30416-3-git-send-email-keescook@chromium.org>
	<CAP145piccauJvW6JrVzxm1xM3_5xtMk_Fa+uwFx-84+dKCS0WQ@mail.gmail.com>
Date: Fri, 22 Jan 2016 14:50:48 -0800
Message-ID: <CAGXu5j+dS3nEc-9HhxBxQO0gWC-bakWxfJHzmfsVb7_AK_8+Jw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 2/2] sysctl: allow CLONE_NEWUSER to be disabled
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 22, 2016 at 2:47 PM, Robert =C5=9Awi=C4=99cki <robert@swiecki.n=
et> wrote:
> Seems that Debian and some older Ubuntu versions are already using
>
> $ sysctl -a | grep usern
> kernel.unprivileged_userns_clone =3D 0
>
> Shall we be consistent wit it?

Oh! I didn't see that on systems I checked. On which version did you find t=
hat?

I'd kind of like to keep the _restrict name, as that follows kptr_ and dmes=
g_...

-Kees

>
> 2016-01-22 23:39 GMT+01:00 Kees Cook <keescook@chromium.org>:
>> There continues to be many CONFIG_USER_NS related security exposures.
>> For admins running distro kernels with CONFIG_USER_NS, there is no way
>> to disable CLONE_NEWUSER. As many systems do not need CLONE_NEWUSER,
>> this provides a way for sysadmins to disable the feature.
>>
>> This is inspired by a similar restriction in Grsecurity, but adds
>> a sysctl.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  Documentation/sysctl/kernel.txt | 17 +++++++++++++++++
>>  kernel/sysctl.c                 | 14 ++++++++++++++
>>  kernel/user_namespace.c         |  7 +++++++
>>  3 files changed, 38 insertions(+)
>>
>> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kern=
el.txt
>> index bbfc5e339a3d..e9e8a4f949f5 100644
>> --- a/Documentation/sysctl/kernel.txt
>> +++ b/Documentation/sysctl/kernel.txt
>> @@ -85,6 +85,7 @@ show up in /proc/sys/kernel:
>>  - tainted
>>  - threads-max
>>  - unknown_nmi_panic
>> +- userns_restrict
>>  - watchdog
>>  - watchdog_thresh
>>  - version
>> @@ -933,6 +934,22 @@ example.  If a system hangs up, try pressing the NM=
I switch.
>>
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> +userns_restrict:
>> +
>> +This toggle indicates whether CLONE_NEWUSER is available. As CLONE_NEWU=
SER
>> +has many unexpected side-effects and security exposures, this allows th=
e
>> +sysadmin to disable the feature without needing to rebuild the kernel.
>> +
>> +When userns_restrict is set to (0), the default, there are no restricti=
ons.
>> +
>> +When userns_restrict is set to (1), CLONE_NEWUSER is only available to
>> +processes that have CAP_SYS_ADMIN, CAP_SETUID, and CAP_SETGID.
>> +
>> +When userns_restrict is set to (2), CLONE_NEWUSER is not available at a=
ll,
>> +and the value is locked to "2" for the duration of the boot.
>> +
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>>  watchdog:
>>
>>  This parameter can be used to disable or enable the soft lockup detecto=
r
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index fc8899dd636d..ceb8b107fe28 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -112,6 +112,9 @@ extern int sysctl_nr_open_min, sysctl_nr_open_max;
>>  #ifndef CONFIG_MMU
>>  extern int sysctl_nr_trim_pages;
>>  #endif
>> +#ifdef CONFIG_USER_NS
>> +extern int sysctl_userns_restrict;
>> +#endif
>>
>>  /* Constants used for minimum and  maximum */
>>  #ifdef CONFIG_LOCKUP_DETECTOR
>> @@ -812,6 +815,17 @@ static struct ctl_table kern_table[] =3D {
>>                 .extra2         =3D &two,
>>         },
>>  #endif
>> +#ifdef CONFIG_USER_NS
>> +       {
>> +               .procname       =3D "userns_restrict",
>> +               .data           =3D &sysctl_userns_restrict,
>> +               .maxlen         =3D sizeof(int),
>> +               .mode           =3D 0644,
>> +               .proc_handler   =3D proc_dointvec_minmax_cap_sysadmin,
>> +               .extra1         =3D &zero,
>> +               .extra2         =3D &two,
>> +       },
>> +#endif
>>         {
>>                 .procname       =3D "ngroups_max",
>>                 .data           =3D &ngroups_max,
>> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
>> index 9bafc211930c..38395f9625ff 100644
>> --- a/kernel/user_namespace.c
>> +++ b/kernel/user_namespace.c
>> @@ -25,6 +25,7 @@
>>
>>  static struct kmem_cache *user_ns_cachep __read_mostly;
>>  static DEFINE_MUTEX(userns_state_mutex);
>> +int sysctl_userns_restrict __read_mostly;
>>
>>  static bool new_idmap_permitted(const struct file *file,
>>                                 struct user_namespace *ns, int cap_setid=
,
>> @@ -84,6 +85,12 @@ int create_user_ns(struct cred *new)
>>             !kgid_has_mapping(parent_ns, group))
>>                 return -EPERM;
>>
>> +       if (sysctl_userns_restrict =3D=3D 2 ||
>> +           (sysctl_userns_restrict =3D=3D 1 && (!capable(CAP_SYS_ADMIN)=
 ||
>> +                                            !capable(CAP_SETUID) ||
>> +                                            !capable(CAP_SETGID))))
>> +               return -EPERM;
>> +
>>         ns =3D kmem_cache_zalloc(user_ns_cachep, GFP_KERNEL);
>>         if (!ns)
>>                 return -ENOMEM;
>> --
>> 2.6.3
>>
>
>
>
> --
> Robert =C5=9Awi=C4=99cki



--=20
Kees Cook
Chrome OS & Brillo Security
