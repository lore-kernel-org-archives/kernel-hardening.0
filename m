Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<1453502345-30416-2-git-send-email-keescook@chromium.org>
	<87oacdyos0.fsf@x220.int.ebiederm.org>
	<20160123222540.GA9740@pc.thejh.net>
	<87mvrvwz72.fsf@x220.int.ebiederm.org>
	<20160124014342.GW17997@ZenIV.linux.org.uk>
	<20160124015643.GA6601@pc.thejh.net>
	<87wpqzv7jy.fsf@x220.int.ebiederm.org>
	<20160124063229.GA21717@pc.thejh.net>
Date: Sun, 24 Jan 2016 00:44:52 -0600
In-Reply-To: <20160124063229.GA21717@pc.thejh.net> (Jann Horn's message of
	"Sun, 24 Jan 2016 07:32:29 +0100")
Message-ID: <871t97v5ln.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] sysctl: expand use of proc_dointvec_minmax_sysadmin
To: Jann Horn <jann@thejh.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Jann Horn <jann@thejh.net> writes:

> On Sun, Jan 24, 2016 at 12:02:41AM -0600, Eric W. Biederman wrote:
>> Jann Horn <jann@thejh.net> writes:
>> 
>> > On Sun, Jan 24, 2016 at 01:43:42AM +0000, Al Viro wrote:
>> >> On Sat, Jan 23, 2016 at 07:20:17PM -0600, Eric W. Biederman wrote:
>> >> 
>> >> > Yep.  That is about the size of it.  file * used to be passed to the
>> >> > sysctl methods but it was removed several years ago because no one was
>> >> > using it.
>> >> 
>> >> Generally cred would be better...
>> >
>> >> Alternatively we could eat one more
>> >> pointer in task_struct and stash a reference to that sucker there, rather
>> >> than adding an explicit argument (again, with cred instead of file).
>> >> Not sure...
>> >
>> > I think it makes sense to do this the same way as the rest of the VFS code
>> > here (which passes the creds down through an argument).
>> >
>> > And adding the arguments everywhere doesn't really mean more work - either
>> > way, someone should probably go through all of those sysctl handlers and
>> > fix them up to use the file creds.
>> 
>> Not all of them need it.  It might be worth figuring out the necessary
>> rigamarole to hook into sysctl_perm the way the networking code does and
>> have that require the capability at open time.
>> 
>> The advantage is that open time is when it is actually appropraite to
>> check permissions.  I could be wrong but I doubt there is enough madness
>> with the handful of sysctl users that call capable to require the checks
>> to happen on write and not on open.
>
> That would work - if all sysctls know whether a capability will be needed
> for writing later on and don't decide it based on the written data. Is that
> always true?

That is certainly the common case to  stick a pointer to static data in
struct sysctl_table.

> Looking through some of the sysctl handlers, I found proc_do_uts_string and
> pid_ns_ctl_handler, which operate on a namespace looked up through current
> at write time. I think that's buggy and ought to be done using the file
> opener creds and on the file opener's namespaces, but where can those be
> stored?

Interesting point.  I had not though about it from that angle.  From all
other angles it has just been something that would be nice to fix but
I hadn't seen the need.   We have all of the infrastructure needed to
register sysctls per namespace and the networking stack uses it.  That
would not be hard to use for uts, pid and ipc namespaces as well.  That
would remove any race.

Eric
