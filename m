Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120406132330.457a05cf.akpm@linux-foundation.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-9-git-send-email-wad@chromium.org>
	<20120406132330.457a05cf.akpm@linux-foundation.org>
Date: Fri, 6 Apr 2012 13:44:43 -0700
Message-ID: <CAGXu5jJVDLzCOyCo-q6+pF-_3v4Ws8jBzYXwac419uv2QQS0mA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v17 08/15] seccomp: add system call filtering using BPF
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, jmorris@namei.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 6, 2012 at 1:23 PM, Andrew Morton <akpm@linux-foundation.org> w=
rote:
> On Thu, 29 Mar 2012 15:01:53 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> [This patch depends on luto@mit.edu's no_new_privs patch:
>> =A0 =A0https://lkml.org/lkml/2012/1/30/264
>> =A0included in this series for ease of consumption.
>> ]
>>
>> This patch adds support for seccomp mode 2. =A0Mode 2 introduces the
>> ability for unprivileged processes to install system call filtering
>> policy expressed in terms of a Berkeley Packet Filter (BPF) program.
>> This program will be evaluated in the kernel for each system call
>> the task makes and computes a result based on data in the format
>> of struct seccomp_data.
>> ...
>> +static void seccomp_filter_log_failure(int syscall)
>> +{
>> + =A0 =A0 int compat =3D 0;
>> +#ifdef CONFIG_COMPAT
>> + =A0 =A0 compat =3D is_compat_task();
>> +#endif
>
> hm, I'm surprised that we don't have a zero-returning implementation of
> is_compat_task() when CONFIG_COMPAT=3Dn. =A0Seems silly. =A0Blames Arnd.

There is, but this chunk of the patch is removed later on in the
series. We could just drop seccomp_filter_log_failure and it's single
call entirely and depend on the later enhancement to add the logging
that is desired.

>> +static long seccomp_attach_filter(struct sock_fprog *fprog)
>> +{
>> + =A0 =A0 struct seccomp_filter *filter;
>> + =A0 =A0 unsigned long fp_size =3D fprog->len * sizeof(struct sock_filt=
er);
>> + =A0 =A0 unsigned long total_insns =3D fprog->len;
>> + =A0 =A0 long ret;
>> +
>> + =A0 =A0 if (fprog->len =3D=3D 0 || fprog->len > BPF_MAXINSNS)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> +
>> + =A0 =A0 for (filter =3D current->seccomp.filter; filter; filter =3D fi=
lter->prev)
>> + =A0 =A0 =A0 =A0 =A0 =A0 total_insns +=3D filter->len + 4; =A0/* includ=
e a 4 instr penalty */
>
> So tasks don't share filters? =A0We copy them by value at fork? =A0Do we =
do
> this at vfork() too?

The filter chain is shared (and refcounted).

>> + =A0 =A0 if (total_insns > MAX_INSNS_PER_PATH)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Installing a seccomp filter requires that the task have
>> + =A0 =A0 =A0* CAP_SYS_ADMIN in its namespace or be running with no_new_=
privs.
>> + =A0 =A0 =A0* This avoids scenarios where unprivileged tasks can affect=
 the
>> + =A0 =A0 =A0* behavior of privileged children.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (!current->no_new_privs &&
>> + =A0 =A0 =A0 =A0 security_capable_noaudit(current_cred(), current_user_=
ns(),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CAP=
_SYS_ADMIN) !=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EACCES;
>> +
>> + =A0 =A0 /* Allocate a new seccomp_filter */
>> + =A0 =A0 filter =3D kzalloc(sizeof(struct seccomp_filter) + fp_size, GF=
P_KERNEL);
>
> I think this gives userspace an easy way of causing page allocation
> failure warnings, by permitting large kmalloc() attempts. =A0Add
> __GFP_NOWARN?

This is likely mitigated by the MAX_INSNS_PER_PATH check above, but,
yeah, there's no harm in adding __GFP_NOWARN.

>> +/* put_seccomp_filter - decrements the ref count of tsk->seccomp.filter=
 */
>> +void put_seccomp_filter(struct task_struct *tsk)
>> +{
>> + =A0 =A0 struct seccomp_filter *orig =3D tsk->seccomp.filter;
>> + =A0 =A0 /* Clean up single-reference branches iteratively. */
>> + =A0 =A0 while (orig && atomic_dec_and_test(&orig->usage)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct seccomp_filter *freeme =3D orig;
>> + =A0 =A0 =A0 =A0 =A0 =A0 orig =3D orig->prev;
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(freeme);
>> + =A0 =A0 }
>> +}
>
> So if one of the filters in the list has an elevated refcount, we bail
> out on the remainder of the list. =A0Seems odd.

This so that every filter in the list doesn't need to have their
refcount raised. As long as the counting up matching the counting
down, it's fine. This allows for process trees branching the filter
list at different times still being safe. IIUC, this code was based on
how namespace refcounting is handled. I spent some time proving to
myself that it was correctly refcounted a while back. More eyes is
better, of course. :)

-Kees

--=20
Kees Cook
ChromeOS Security
