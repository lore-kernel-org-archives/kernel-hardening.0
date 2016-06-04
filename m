Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
References: <20160111151958.GQ28542@decadent.org.uk> <20160111152355.GS28542@decadent.org.uk>
 <CAGXu5jLT+GR8DEOYLaY4KgZJP=9HEX+w+=mz5fomAMTBr_2Zow@mail.gmail.com>
In-Reply-To: <CAGXu5jLT+GR8DEOYLaY4KgZJP=9HEX+w+=mz5fomAMTBr_2Zow@mail.gmail.com>
From: Jeffrey Vander Stoep <jeffv@google.com>
Date: Sat, 04 Jun 2016 20:49:32 +0000
Message-ID: <CABXk95BE3wpgq-Y08G+Z3ZJbxJwgiuVvtQGaV4n-tD6GKNiFKg@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a114d4fbc8137d2053479fab1
Subject: Re: [kernel-hardening] [PATCH 2/2] security,perf: Allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

--001a114d4fbc8137d2053479fab1
Content-Type: text/plain; charset=UTF-8

Acked-by: Jeff Vander Stoep <jeffv@google.com>

In addition to Debian, this patch has been merged into AOSP and is a
requirement for Android:
https://android-review.googlesource.com/#/q/topic:CONFIG_SECURITY_PERF_EVENTS_RESTRICT

On Wed, Apr 13, 2016 at 9:12 AM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Jan 11, 2016 at 7:23 AM, Ben Hutchings <ben@decadent.org.uk>
wrote:
>> When kernel.perf_event_open is set to 3 (or greater), disallow all
>> access to performance events by users without CAP_SYS_ADMIN.
>> Add a Kconfig symbol CONFIG_SECURITY_PERF_EVENTS_RESTRICT that
>> makes this value the default.
>>
>> This is based on a similar feature in grsecurity
>> (CONFIG_GRKERNSEC_PERF_HARDEN).  This version doesn't include making
>> the variable read-only.  It also allows enabling further restriction
>> at run-time regardless of whether the default is changed.
>>
>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>
> Whoops, I entirely missed this email! Just found it now.
>
> Ben, can you resend this with Perf maintainers in CC? This seems
> sensible enough to me.
>
> -Kees
>
>> ---
>> I made a similar change to Debian's kernel packages in August,
>> including the more restrictive default, and no-one has complained yet.
>>
>> Ben.
>>
>>  Documentation/sysctl/kernel.txt | 4 +++-
>>  include/linux/perf_event.h      | 5 +++++
>>  kernel/events/core.c            | 8 ++++++++
>>  security/Kconfig                | 9 +++++++++
>>  4 files changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/sysctl/kernel.txt
b/Documentation/sysctl/kernel.txt
>> index 88a2c8e..76e2ca8 100644
>> --- a/Documentation/sysctl/kernel.txt
>> +++ b/Documentation/sysctl/kernel.txt
>> @@ -629,12 +629,14 @@ allowed to execute.
>>  perf_event_paranoid:
>>
>>  Controls use of the performance events system by unprivileged
>> -users (without CAP_SYS_ADMIN).  The default value is 1.
>> +users (without CAP_SYS_ADMIN).  The default value is 3 if
>> +CONFIG_SECURITY_PERF_EVENTS_RESTRICT is set, or 1 otherwise.
>>
>>   -1: Allow use of (almost) all events by all users
>>  >=0: Disallow raw tracepoint access by users without CAP_IOC_LOCK
>>  >=1: Disallow CPU event access by users without CAP_SYS_ADMIN
>>  >=2: Disallow kernel profiling by users without CAP_SYS_ADMIN
>> +>=3: Disallow all event access by users without CAP_SYS_ADMIN
>>
>>  ==============================================================
>>
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index f9828a4..aa72940 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -989,6 +989,11 @@ extern int perf_cpu_time_max_percent_handler(struct
ctl_table *table, int write,
>>                 loff_t *ppos);
>>
>>
>> +static inline bool perf_paranoid_any(void)
>> +{
>> +       return sysctl_perf_event_paranoid > 2;
>> +}
>> +
>>  static inline bool perf_paranoid_tracepoint_raw(void)
>>  {
>>         return sysctl_perf_event_paranoid > -1;
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index cfc227c..85bc810 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -175,8 +175,13 @@ static struct srcu_struct pmus_srcu;
>>   *   0 - disallow raw tracepoint access for unpriv
>>   *   1 - disallow cpu events for unpriv
>>   *   2 - disallow kernel profiling for unpriv
>> + *   3 - disallow all unpriv perf event use
>>   */
>> +#ifdef CONFIG_SECURITY_PERF_EVENTS_RESTRICT
>> +int sysctl_perf_event_paranoid __read_mostly = 3;
>> +#else
>>  int sysctl_perf_event_paranoid __read_mostly = 1;
>> +#endif
>>
>>  /* Minimum for 512 kiB + 1 user control page */
>>  int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024);
/* 'free' kiB per user */
>> @@ -8265,6 +8270,9 @@ SYSCALL_DEFINE5(perf_event_open,
>>         if (flags & ~PERF_FLAG_ALL)
>>                 return -EINVAL;
>>
>> +       if (perf_paranoid_any() && !capable(CAP_SYS_ADMIN))
>> +               return -EACCES;
>> +
>>         err = perf_copy_attr(attr_uptr, &attr);
>>         if (err)
>>                 return err;
>> diff --git a/security/Kconfig b/security/Kconfig
>> index e452378..30a2603 100644
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -18,6 +18,15 @@ config SECURITY_DMESG_RESTRICT
>>
>>           If you are unsure how to answer this question, answer N.
>>
>> +config SECURITY_PERF_EVENTS_RESTRICT
>> +       bool "Restrict unprivileged use of performance events"
>> +       depends on PERF_EVENTS
>> +       help
>> +         If you say Y here, the kernel.perf_event_paranoid sysctl
>> +         will be set to 3 by default, and no unprivileged use of the
>> +         perf_event_open syscall will be permitted unless it is
>> +         changed.
>> +
>>  config SECURITY
>>         bool "Enable different security models"
>>         depends on SYSFS
>
>
>
> --
> Kees Cook
> Chrome OS & Brillo Security

--001a114d4fbc8137d2053479fab1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Acked-by: Jeff Vander Stoep &lt;<a href=3D"mailto:jeffv@go=
ogle.com">jeffv@google.com</a>&gt;<br><br>In addition to Debian, this patch=
 has been merged into AOSP and is a requirement for Android:=C2=A0<a href=
=3D"https://android-review.googlesource.com/#/q/topic:CONFIG_SECURITY_PERF_=
EVENTS_RESTRICT">https://android-review.googlesource.com/#/q/topic:CONFIG_S=
ECURITY_PERF_EVENTS_RESTRICT</a><br><div><br></div><div>On Wed, Apr 13, 201=
6 at 9:12 AM, Kees Cook &lt;<a href=3D"mailto:keescook@chromium.org" target=
=3D"_blank">keescook@chromium.org</a>&gt; wrote:<br>
&gt; On Mon, Jan 11, 2016 at 7:23 AM, Ben Hutchings &lt;<a href=3D"mailto:b=
en@decadent.org.uk" target=3D"_blank">ben@decadent.org.uk</a>&gt; wrote:<br=
>
&gt;&gt; When kernel.perf_event_open is set to 3 (or greater), disallow all=
<br>
&gt;&gt; access to performance events by users without CAP_SYS_ADMIN.<br>
&gt;&gt; Add a Kconfig symbol CONFIG_SECURITY_PERF_EVENTS_RESTRICT that<br>
&gt;&gt; makes this value the default.<br>
&gt;&gt;<br>
&gt;&gt; This is based on a similar feature in grsecurity<br>
&gt;&gt; (CONFIG_GRKERNSEC_PERF_HARDEN).=C2=A0 This version doesn&#39;t inc=
lude making<br>
&gt;&gt; the variable read-only.=C2=A0 It also allows enabling further rest=
riction<br>
&gt;&gt; at run-time regardless of whether the default is changed.<br>
&gt;&gt;<br>
&gt;&gt; Signed-off-by: Ben Hutchings &lt;<a href=3D"mailto:ben@decadent.or=
g.uk" target=3D"_blank">ben@decadent.org.uk</a>&gt;<br>
&gt;<br>
&gt; Whoops, I entirely missed this email! Just found it now.<br>
&gt;<br>
&gt; Ben, can you resend this with Perf maintainers in CC? This seems<br>
&gt; sensible enough to me.<br>
&gt;<br>
&gt; -Kees<br>
&gt;<br>
&gt;&gt; ---<br>
&gt;&gt; I made a similar change to Debian&#39;s kernel packages in August,=
<br>
&gt;&gt; including the more restrictive default, and no-one has complained =
yet.<br>
&gt;&gt;<br>
&gt;&gt; Ben.<br>
&gt;&gt;<br>
&gt;&gt;=C2=A0 Documentation/sysctl/kernel.txt | 4 +++-<br>
&gt;&gt;=C2=A0 include/linux/perf_event.h=C2=A0 =C2=A0 =C2=A0 | 5 +++++<br>
&gt;&gt;=C2=A0 kernel/events/core.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | 8 ++++++++<br>
&gt;&gt;=C2=A0 security/Kconfig=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 | 9 +++++++++<br>
&gt;&gt;=C2=A0 4 files changed, 25 insertions(+), 1 deletion(-)<br>
&gt;&gt;<br>
&gt;&gt; diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysct=
l/kernel.txt<br>
&gt;&gt; index 88a2c8e..76e2ca8 100644<br>
&gt;&gt; --- a/Documentation/sysctl/kernel.txt<br>
&gt;&gt; +++ b/Documentation/sysctl/kernel.txt<br>
&gt;&gt; @@ -629,12 +629,14 @@ allowed to execute.<br>
&gt;&gt;=C2=A0 perf_event_paranoid:<br>
&gt;&gt;<br>
&gt;&gt;=C2=A0 Controls use of the performance events system by unprivilege=
d<br>
&gt;&gt; -users (without CAP_SYS_ADMIN).=C2=A0 The default value is 1.<br>
&gt;&gt; +users (without CAP_SYS_ADMIN).=C2=A0 The default value is 3 if<br=
>
&gt;&gt; +CONFIG_SECURITY_PERF_EVENTS_RESTRICT is set, or 1 otherwise.<br>
&gt;&gt;<br>
&gt;&gt;=C2=A0 =C2=A0-1: Allow use of (almost) all events by all users<br>
&gt;&gt;=C2=A0 &gt;=3D0: Disallow raw tracepoint access by users without CA=
P_IOC_LOCK<br>
&gt;&gt;=C2=A0 &gt;=3D1: Disallow CPU event access by users without CAP_SYS=
_ADMIN<br>
&gt;&gt;=C2=A0 &gt;=3D2: Disallow kernel profiling by users without CAP_SYS=
_ADMIN<br>
&gt;&gt; +&gt;=3D3: Disallow all event access by users without CAP_SYS_ADMI=
N<br>
&gt;&gt;<br>
&gt;&gt;=C2=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt;&gt;<br>
&gt;&gt; diff --git a/include/linux/perf_event.h b/include/linux/perf_event=
.h<br>
&gt;&gt; index f9828a4..aa72940 100644<br>
&gt;&gt; --- a/include/linux/perf_event.h<br>
&gt;&gt; +++ b/include/linux/perf_event.h<br>
&gt;&gt; @@ -989,6 +989,11 @@ extern int perf_cpu_time_max_percent_handler(=
struct ctl_table *table, int write,<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0loff_=
t *ppos);<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; +static inline bool perf_paranoid_any(void)<br>
&gt;&gt; +{<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0return sysctl_perf_event_paranoid &gt;=
 2;<br>
&gt;&gt; +}<br>
&gt;&gt; +<br>
&gt;&gt;=C2=A0 static inline bool perf_paranoid_tracepoint_raw(void)<br>
&gt;&gt;=C2=A0 {<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return sysctl_perf_event_paranoid=
 &gt; -1;<br>
&gt;&gt; diff --git a/kernel/events/core.c b/kernel/events/core.c<br>
&gt;&gt; index cfc227c..85bc810 100644<br>
&gt;&gt; --- a/kernel/events/core.c<br>
&gt;&gt; +++ b/kernel/events/core.c<br>
&gt;&gt; @@ -175,8 +175,13 @@ static struct srcu_struct pmus_srcu;<br>
&gt;&gt;=C2=A0 =C2=A0*=C2=A0 =C2=A00 - disallow raw tracepoint access for u=
npriv<br>
&gt;&gt;=C2=A0 =C2=A0*=C2=A0 =C2=A01 - disallow cpu events for unpriv<br>
&gt;&gt;=C2=A0 =C2=A0*=C2=A0 =C2=A02 - disallow kernel profiling for unpriv=
<br>
&gt;&gt; + *=C2=A0 =C2=A03 - disallow all unpriv perf event use<br>
&gt;&gt;=C2=A0 =C2=A0*/<br>
&gt;&gt; +#ifdef CONFIG_SECURITY_PERF_EVENTS_RESTRICT<br>
&gt;&gt; +int sysctl_perf_event_paranoid __read_mostly =3D 3;<br>
&gt;&gt; +#else<br>
&gt;&gt;=C2=A0 int sysctl_perf_event_paranoid __read_mostly =3D 1;<br>
&gt;&gt; +#endif<br>
&gt;&gt;<br>
&gt;&gt;=C2=A0 /* Minimum for 512 kiB + 1 user control page */<br>
&gt;&gt;=C2=A0 int sysctl_perf_event_mlock __read_mostly =3D 512 + (PAGE_SI=
ZE / 1024); /* &#39;free&#39; kiB per user */<br>
&gt;&gt; @@ -8265,6 +8270,9 @@ SYSCALL_DEFINE5(perf_event_open,<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (flags &amp; ~PERF_FLAG_ALL)<b=
r>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retur=
n -EINVAL;<br>
&gt;&gt;<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (perf_paranoid_any() &amp;&amp; !ca=
pable(CAP_SYS_ADMIN))<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EA=
CCES;<br>
&gt;&gt; +<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D perf_copy_attr(attr_uptr,=
 &amp;attr);<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retur=
n err;<br>
&gt;&gt; diff --git a/security/Kconfig b/security/Kconfig<br>
&gt;&gt; index e452378..30a2603 100644<br>
&gt;&gt; --- a/security/Kconfig<br>
&gt;&gt; +++ b/security/Kconfig<br>
&gt;&gt; @@ -18,6 +18,15 @@ config SECURITY_DMESG_RESTRICT<br>
&gt;&gt;<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0If you are unsure how to a=
nswer this question, answer N.<br>
&gt;&gt;<br>
&gt;&gt; +config SECURITY_PERF_EVENTS_RESTRICT<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0bool &quot;Restrict unprivileged use o=
f performance events&quot;<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0depends on PERF_EVENTS<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0help<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0If you say Y here, the kernel.p=
erf_event_paranoid sysctl<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0will be set to 3 by default, an=
d no unprivileged use of the<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0perf_event_open syscall will be=
 permitted unless it is<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0changed.<br>
&gt;&gt; +<br>
&gt;&gt;=C2=A0 config SECURITY<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool &quot;Enable different secur=
ity models&quot;<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0depends on SYSFS<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; Kees Cook<br>
&gt; Chrome OS &amp; Brillo Security<br>
<br>
</div></div>

--001a114d4fbc8137d2053479fab1--
