Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20131004191113.GA3916@dztty>
References: <20131003143653.GA32445@dztty> <CALCETrU_D7X+jPWseiyp3FJJnw5CHhLbGz73FVDaeBpRDA+-og@mail.gmail.com>
 <20131003192926.GB2390@dztty> <CALCETrVDqBAcdJDFihzTZ23SJBmP5jmHfqqXyTqre38t8xn7Tg@mail.gmail.com>
 <20131003201332.GA3500@dztty> <CALCETrUOMF8MU9xpkQKYub-95fh9DAVBgPBXpAmMdmsb74HcTg@mail.gmail.com>
 <20131004085911.GA2157@dztty> <CALCETrU5vBcqCbKAh=1wWPjt6js7A4R2xtnwc3Z1Z0FRMLP1SQ@mail.gmail.com>
 <20131004182353.GA2600@dztty> <CALCETrVs2Nd82dpURQxAVetK814bAm8TvnSyA4e=YeTWxTFsmA@mail.gmail.com>
 <20131004191113.GA3916@dztty>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 4 Oct 2013 12:16:26 -0700
Message-ID: <CALCETrVMBh0nNgpOHOMrsOjHez7NnCNbY5nHxeQ3RToP4nKO+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if file's
 opener may access task
To: Djalal Harouni <tixxdz@opendz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 4, 2013 at 12:11 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> On Fri, Oct 04, 2013 at 07:34:08PM +0100, Andy Lutomirski wrote:
>> On Fri, Oct 4, 2013 at 7:23 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> > On Fri, Oct 04, 2013 at 04:40:01PM +0100, Andy Lutomirski wrote:
>> >> On Fri, Oct 4, 2013 at 9:59 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> >> > On Thu, Oct 03, 2013 at 02:09:55PM -0700, Andy Lutomirski wrote:
> [...]
>> Sorry, I described the obviously broken scenario incorrectly.  Your
>> patch breaks (in the absence of things like selinux) if a exec
>> something setuid root.
>>
>> [...]
>>
>> >
>> > I did the check in the proc_same_open_cred() function:
>> >  return (uid_eq(fcred->uid, cred->uid) &&
>> >          gid_eq(fcred->gid, cred->gid) &&
>> >          cap_issubset(cred->cap_permitted, fcred->cap_permitted));
>>
>> Which has nothing to do with anything.  If that check fails, you're
>> just going on to a different, WRONG check/.
>>
>> >
>> > Check if this is the same uid/gid and the capabilities superset!
>> >
>> > But in the proc_allow_access() the capabilities superset is missing.
>> >
>> >
>> > So to fix it:
>> > 1) if proc_same_open_cred() detects that cred have changed between
>> > ->open() and ->read() then abort, return zero, the ->read(),write()...
>>
>> IMO yuck.
>>
>> >
>> >
>> > 2) Improve the proc_allow_access() check by:
>> >    if this is the same user namespace then check uid/gid of f_cred on
>> >    target cred task, and the capabilities superset:
>> >    cap_issubset(tcred->cap_permitted, fcred->cap_permitted));
>> >
>> >    If it fails let security_capable() or file_ns_capable() do its magic.
>> >
>>
>> NAK.  You need to actually call the LSM.  What if the reason to fail
>> the request isn't that the writer gained capabilities -- what if the
>> writer's selinux label changed?
> Sorry I can't follow you here! Can you be more explicit please?
>
> For me we are already doing this during ptrace_may_access() on each
> syscall, which will call LSM to inspect the privileges on each ->open(),
> ->write()... So LSM hooks are already called. If you want to have more
> LSM hooks, then perhaps that's another problem?

Can you show me where, in your code, LSMs are asked whether the
process calling read() is permitted to ptrace the process that the
proc file points at?

--Andy
