Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120124115104.GA5743@albatros>
References: <20120123212115.GA29641@www.outflux.net>
	<20120124110332.GA4770@albatros>
	<CACVxJT95OjBkqh01AGVLVXDEw3YNaEcCNptgM9kbb47AG5C7zg@mail.gmail.com>
	<20120124115104.GA5743@albatros>
Date: Tue, 31 Jan 2012 11:22:42 -0800
Message-ID: <CAGXu5jJMRRXFKi9XH9BBupxYYjq0SoxUxrmyYiB2H8h0QbN=UA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v3] sysctl: control functionality of /proc/pid/mem
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>, Dan Ballard <dan@mindstab.net>, Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 24, 2012 at 3:51 AM, Vasiliy Kulikov <segoon@openwall.com> wrot=
e:
> On Tue, Jan 24, 2012 at 13:12 +0200, Alexey Dobriyan wrote:
>> On 1/24/12, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> >> + =A0 =A0 =A0 =A0 =A0.procname =A0 =A0 =A0 =3D "proc_pid_mem",
>> >> + =A0 =A0 =A0 =A0 =A0.data =A0 =A0 =A0 =A0 =A0 =3D &sysctl_proc_pid_m=
em,
>> >> + =A0 =A0 =A0 =A0 =A0.maxlen =A0 =A0 =A0 =A0 =3D sizeof(int),
>> >> + =A0 =A0 =A0 =A0 =A0.mode =A0 =A0 =A0 =A0 =A0 =3D 0644,
>> >> + =A0 =A0 =A0 =A0 =A0.proc_handler =A0 =3D proc_dointvec_minmax,
>> >> + =A0 =A0 =A0 =A0 =A0.extra1 =A0 =A0 =A0 =A0 =3D &zero,
>> >> + =A0 =A0 =A0 =A0 =A0.extra2 =A0 =A0 =A0 =A0 =3D &two,
>> >> + =A0},
>>
>> >E.g. moving all such stuff to some sysctl group, not bloating
>> > kernel.*.
>>
>> Ehh.
>> How bloat is measured in this case?
>
> Do we want to add such sort of sysctls "from time to time" when we
> consider one or another feature as deprecated? =A0If yes, I'd group them
> somehow, e.g. by introducing subdirectory inside of kernel.
>
> Btw, kernel sysctl dir contains all sort of stuff which goes to "kernel"
> as if it is "etc". =A0It already contains ftrace, perf, printk, scheduler=
,
> ipc. =A0IMHO plain kernel hierarchy is not profitable in the long term.

Yeah, after reconsidering this, this sysctl is not the right approach.

-Kees

--=20
Kees Cook
ChromeOS Security
