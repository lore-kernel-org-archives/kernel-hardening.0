Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
	<m1pqchocok.fsf@fess.ebiederm.org> <20120312204416.GG10787@dztty>
	<m11uoxij9c.fsf@fess.ebiederm.org> <20120312224136.GH10787@dztty>
Date: Mon, 12 Mar 2012 16:10:28 -0700
In-Reply-To: <20120312224136.GH10787@dztty> (Djalal Harouni's message of "Mon,
	12 Mar 2012 23:41:36 +0100")
Message-ID: <m1boo1fmaj.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH 0/9] proc: protect /proc/<pid>/* files across execve
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

Djalal Harouni <tixxdz@opendz.org> writes:

> I'm not sure I follow you here, these proc files suffer from the same
> problems, can you please point what are these non-silly case ?

As I read 3.3-rc1 which I have handy I do not see problems.

>> What is needed is for safety is to guard against the race of exec
>> happening during a read or a write, so that we don't get access
> before and during. I say before since this is what we are tying to
> emulate.

>> to something we shouldn't have permissions to.
>> 
>> In general that means reference counting or locks.  All exec_id can
> Locks ? counting yes this perhaps can work as Alan suggested, but a simple
> check will catch all the things without any node list nor count inc/dec.

An exec_id check adds no value, to files like /proc/pid/environ.
mm_for_maps nicely does the necessary permission checks and avoids the
race.

>> > The previous discussion on kernel-hardening:
>> > (includes some variants described by Vasiliy and other problems which I'll
>> > try to discuss here)
>> > http://www.openwall.com/lists/kernel-hardening/2012/02/10/1
>> 
>> In your post on openwall I just see you arguing that the current
>> and deliberate semantics of the permission checks on the proc files are
>> wrong.  Because the permission checks happen at access time rather than
>> at open time.
> Yes if you are speaking about {maps,smaps...} then it should also be at
> open time and at each syscall (it depends on files) and for the
> /proc/pid/{maps,smaps,numa_maps} yes it is not safe to give non-privileged
> processes an fd to an objects attached to a privileged process.

Then the permission checks at access time are broken, and exec_id
nonsense won't make them better.

>> Well I am sorry.  The permission checks have happened at access time for
>> ages and that is deliberate.
> Yes (perhaps even before I use Linux :) ), but IMHO they are not perfect,
> if they were, then we'll not see all the /proc/<pid>/ problems.

We see problems because we lots of people play in the code and are not
careful.  It looks to me like you are trying to make the problem worse
by making the code more complicated and even harder to understand.

> The current patches protect /proc/pid/{maps,smaps,numa_maps} without breaking
> things, there are no checks at open which is not safe, but I did not add
> it since I was not sure and I don't want to break things (glibc
> FORITFY_SOURCE ...).
>
> My patches add the ptrace checks at open only for
> /proc/<pid>/{environ,pagemap,mem} which is safe, I did not include
> /proc/pid/{auxv,maps,smaps,...} so please if you have _real_ cases of
> problems just post them.

You are thrashing the code and making it more complicated for no
apparent reason.

>> If you expect /proc/ not to let you find out things about yourself
>> if you are a suid executable that just seems silly.
> Ah yes this one about suid/privileged, if you are still privileged then
> there is no harm, but if you drop your privileges IMHO that means that you
> do not want to do privileged operations, but that current == task in
> ptrace which is before the creds check will just allow you to do so.

Please show me how you can drop privileges to access yourself.

The current == task check is there because of extreme silliness in
the security modules and the fact that glibc breaks in entertaining
was if it can not access /proc/self/masp.  If you I read you right
you want to reintroduce that breaking for suid exectuables.  Frankly
that sounds like you a security bug in the making.

> Well, this is another subject.
>
>> So in short you seem to be arguing for changing the semantics of access
>> of every file under /proc/<pid> because there is cognitive dissonance
>> between your understanding of those files and what is implemented.  I
>> see no acknowledgement that you are arguing for a semantic change or
>> any arguments in favor of that change.  At best I see is an argument
>> that says you the files don't work the way you expect which is most
>> definitely not sufficient for a change.
> I really don't understant what you are trying to say/prove here, this is
> the same issue of the last /proc/<pid>/mem one that got fixed by Linus and
> Olge patches. These are dynamic files.

The /proc/<pid>/mem permission checks were implemented in a very stupid
way.  In that stupid way they used task->exec_id.  I don't see any
evidence that anyone touching any of the other proc files made that same
foolish set of choices.  So I see no evidence that the problem exists
outside of anywhere except /proc/<pid>/mem.

So very simply it looks to me like your entire patchset is very busily
trying to fix problems that don't exist.

Eric
