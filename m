Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <20131003201332.GA3500@dztty>
	<CALCETrUOMF8MU9xpkQKYub-95fh9DAVBgPBXpAmMdmsb74HcTg@mail.gmail.com>
	<20131004085911.GA2157@dztty>
	<CALCETrU5vBcqCbKAh=1wWPjt6js7A4R2xtnwc3Z1Z0FRMLP1SQ@mail.gmail.com>
	<20131004182353.GA2600@dztty>
	<CALCETrVs2Nd82dpURQxAVetK814bAm8TvnSyA4e=YeTWxTFsmA@mail.gmail.com>
	<20131004191113.GA3916@dztty>
	<CALCETrVMBh0nNgpOHOMrsOjHez7NnCNbY5nHxeQ3RToP4nKO+A@mail.gmail.com>
	<20131004192712.GA4334@dztty>
	<CALCETrUuMRMgJ1OV3-ZRQ5wwzSQsdf9tKY9iKesk1QJPtj6-qw@mail.gmail.com>
	<20131004194142.GA4524@dztty>
	<CALCETrXghsx-2rK8QqgtfMaJJhkwcYgRMnqGQfKw-T3O7jBTUA@mail.gmail.com>
Date: Fri, 04 Oct 2013 15:55:04 -0700
In-Reply-To: <CALCETrXghsx-2rK8QqgtfMaJJhkwcYgRMnqGQfKw-T3O7jBTUA@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 4 Oct 2013 15:17:08 -0700")
Message-ID: <87fvsgy7cn.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if file's opener may access task
To: Andy Lutomirski <luto@amacapital.net>
Cc: Djalal Harouni <tixxdz@opendz.org>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Andy Lutomirski <luto@amacapital.net> writes:

> On Fri, Oct 4, 2013 at 12:41 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> On Fri, Oct 04, 2013 at 12:32:09PM -0700, Andy Lutomirski wrote:
>>> On Fri, Oct 4, 2013 at 12:27 PM, Djalal Harouni <tixxdz@opendz.org> wrote:

>>> > So sorry Andy, I don't follow what you are describing.
>>>
>>> And what parameters are you passing to security_ptrace_access_check?
>>> It's supposed to be f_cred, right?  Because you want to make sure
>>> that, if the opener had some low-privilege label, the target has
>>> execed and gotten a more secure label, and the reader has a
>>> high-privilege label, that the opener's label is checked against the
>>> target's new label.
>> The current's cred each time.
>
> Exactly.  Hence the NAK.
>
>>
>> Is there some mechanism to check what you describe?
>>
>
> No.  You could try to add one, but getting it to be compatible with
> YAMA might be really messy.
>
> Or you could see if destroying and recreating all the inodes on exec
> or some other revoke-like approach would work.

This is a revoke like approach, and yes proc has a fully functional
revoke infrastructure.  Right now that revoke is based on the process
going away.  The problem challenge is that the process is morphing.

The practical question is which runtime checks do we want to perform.

If we can say in no uncertain terms that short of a suid exec that
no calls (such as setuid) can change the process permissions beyond
our ability to access the file, we can detect and exec and use that
as a signal.

Alternatively we may to look at a processes credentials and in all
cases where those change use that as a signal that the file must
be reopened.

Right now the model that we do a full permission check at every system
call because the morphing process may cause problems.  If analysis can
be done to show that we can use a simpler check than a full permission
check that would be grand.

The problem is not lack of techinical infrastructure (revoke).  The
problem is a question of which tests are sufficient.

Eric
