Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<1453502345-30416-2-git-send-email-keescook@chromium.org>
	<87oacdyos0.fsf@x220.int.ebiederm.org>
	<20160123222540.GA9740@pc.thejh.net>
Date: Sat, 23 Jan 2016 19:20:17 -0600
In-Reply-To: <20160123222540.GA9740@pc.thejh.net> (Jann Horn's message of
	"Sat, 23 Jan 2016 23:25:40 +0100")
Message-ID: <87mvrvwz72.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] sysctl: expand use of proc_dointvec_minmax_sysadmin
To: Jann Horn <jann@thejh.net>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Jann Horn <jann@thejh.net> writes:

> On Fri, Jan 22, 2016 at 09:10:07PM -0600, Eric W. Biederman wrote:
>> Kees Cook <keescook@chromium.org> writes:
>> 
>> > Several sysctls expect a state where the highest value (in extra2) is
>> > locked once set for that boot. Yama does this, and kptr_restrict should
>> > be doing it. This extracts Yama's logic and adds it to the existing
>> > proc_dointvec_minmax_sysadmin, taking care to avoid the simple boolean
>> > states (which do not get locked). Since Yama wants to be checking a
>> > different capability, we build wrappers for both cases (CAP_SYS_ADMIN
>> > and CAP_SYS_PTRACE).
>> 
>> Sigh this sysctl appears susceptible to known attacks.
>> 
>> In my quick skim I believe this sysctl implementation that checks
>> capabilities is susceptible to attacks where the already open file
>> descriptor is set as stdout on a setuid root application.
>> 
>> Can we come up with an interface that isn't exploitable by an
>> application that will act as a setuid cat?
>
> Adding the struct file * to the parameters of all proc_handler
> functions would work, right? (Or just filp->f_cred? That would be
> less generic.)
>
> A quick grep says that's just about 160 functions that'll need to
> be changed. :/

Yep.  That is about the size of it.  file * used to be passed to the
sysctl methods but it was removed several years ago because no one was
using it.

Eric
