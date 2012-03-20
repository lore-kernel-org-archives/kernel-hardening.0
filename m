Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.LFD.2.02.1203201758220.2542@ionos>
References: <20120319231253.GA20893@www.outflux.net>
	<20120320133141.GC2918@peqn>
	<alpine.LFD.2.02.1203201758220.2542@ionos>
Date: Tue, 20 Mar 2012 10:11:02 -0700
Message-ID: <CAGXu5jKVx41+NSEWsw0YF74z5_heSQ6GOmkuDi1DXNPcO4sjTQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] futex: do not leak robust list to unprivileged process
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, linux-kernel@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net, mingo@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 20, 2012 at 10:02 AM, Thomas Gleixner <tglx@linutronix.de> wrot=
e:
> On Tue, 20 Mar 2012, Serge Hallyn wrote:
>
>> Quoting Kees Cook (keescook@chromium.org):
>> > It was possible to extract the robust list head address from a setuid
>> > process if it had used set_robust_list(), allowing an ASLR info leak. =
This
>> > changes the permission checks to be the same as those used for similar
>> > info that comes out of /proc.
>> >
>> > Running a setuid program that uses robust futexes would have had:
>> > =A0 cred->euid !=3D pcred->euid
>> > =A0 cred->euid =3D=3D pcred->uid
>> > so the old permissions check would allow it. I'm not aware of any setu=
id
>> > programs that use robust futexes, so this is just a preventative measu=
re.
>> >
>> > (This patch is based on changes from grsecurity.)
>> >
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> I like the change. =A0Much cleaner. =A0I'm not 100% sure though that
>> there are no legitimate cases of robust futexes use which would now
>> be forbidden. =A0(Explicitly cc:ing Ingo)
>
> get_robust_list is not necessary for robust futexes. There is no
> reference to get_robust_list in glibc.
>
> I really wonder why we have this syscall at all.

The documentation I found yesterday while looking at this was:
http://linux.die.net/man/2/get_robust_list

Which says "The system call is only available for debugging purposes
and is not needed for normal operations. Both system calls are not
available to application programs as functions; they can be called
using the syscall(3) function."

Dropping the syscall entirely would certainly make it secure. ;)

-Kees

--=20
Kees Cook
ChromeOS Security
