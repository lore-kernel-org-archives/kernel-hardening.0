Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <87fvsgy7cn.fsf@xmission.com>
References: <20131003201332.GA3500@dztty> <CALCETrUOMF8MU9xpkQKYub-95fh9DAVBgPBXpAmMdmsb74HcTg@mail.gmail.com>
 <20131004085911.GA2157@dztty> <CALCETrU5vBcqCbKAh=1wWPjt6js7A4R2xtnwc3Z1Z0FRMLP1SQ@mail.gmail.com>
 <20131004182353.GA2600@dztty> <CALCETrVs2Nd82dpURQxAVetK814bAm8TvnSyA4e=YeTWxTFsmA@mail.gmail.com>
 <20131004191113.GA3916@dztty> <CALCETrVMBh0nNgpOHOMrsOjHez7NnCNbY5nHxeQ3RToP4nKO+A@mail.gmail.com>
 <20131004192712.GA4334@dztty> <CALCETrUuMRMgJ1OV3-ZRQ5wwzSQsdf9tKY9iKesk1QJPtj6-qw@mail.gmail.com>
 <20131004194142.GA4524@dztty> <CALCETrXghsx-2rK8QqgtfMaJJhkwcYgRMnqGQfKw-T3O7jBTUA@mail.gmail.com>
 <87fvsgy7cn.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 4 Oct 2013 15:59:51 -0700
Message-ID: <CALCETrVFNcGtsm3N50sZRDWmBOJ3VWn=BidAOV4Q+eDwYhJ+vw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if file's
 opener may access task
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Djalal Harouni <tixxdz@opendz.org>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 4, 2013 at 3:55 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> On Fri, Oct 4, 2013 at 12:41 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>>> On Fri, Oct 04, 2013 at 12:32:09PM -0700, Andy Lutomirski wrote:
>>>> On Fri, Oct 4, 2013 at 12:27 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>
>>>> > So sorry Andy, I don't follow what you are describing.
>>>>
>>>> And what parameters are you passing to security_ptrace_access_check?
>>>> It's supposed to be f_cred, right?  Because you want to make sure
>>>> that, if the opener had some low-privilege label, the target has
>>>> execed and gotten a more secure label, and the reader has a
>>>> high-privilege label, that the opener's label is checked against the
>>>> target's new label.
>>> The current's cred each time.
>>
>> Exactly.  Hence the NAK.
>>
>>>
>>> Is there some mechanism to check what you describe?
>>>
>>
>> No.  You could try to add one, but getting it to be compatible with
>> YAMA might be really messy.
>>
>> Or you could see if destroying and recreating all the inodes on exec
>> or some other revoke-like approach would work.
>
> This is a revoke like approach, and yes proc has a fully functional
> revoke infrastructure.  Right now that revoke is based on the process
> going away.  The problem challenge is that the process is morphing.
>
> The practical question is which runtime checks do we want to perform.
>
> If we can say in no uncertain terms that short of a suid exec that
> no calls (such as setuid) can change the process permissions beyond
> our ability to access the file, we can detect and exec and use that
> as a signal.

If you could ptrace a process before it calls setuid and you can't
after it calls setuid, then this is stupid and doesn't matter -- once
you've pwned a process, you retain your pwnership at least until exec.

So yes, except that it's not just suid exec.  It's any exec that any
LSM would not do if no_new_privs were set.

>
> Alternatively we may to look at a processes credentials and in all
> cases where those change use that as a signal that the file must
> be reopened.

Hmm.  So why don't we just do a revoke whenever an exec that changes
cred happens?  (This will have some false positives, like unsharing
userns, I think, but we probably don't care.)

>
> Right now the model that we do a full permission check at every system
> call because the morphing process may cause problems.  If analysis can
> be done to show that we can use a simpler check than a full permission
> check that would be grand.
>
> The problem is not lack of techinical infrastructure (revoke).  The
> problem is a question of which tests are sufficient.

Can you point us at that infrastructure?  My limited grepping skills
didn't spot it.

I'd really like a solution where there are no read or write
implementations in the entire kernel that check permissions.  Failing
that, just getting it for procfs would be nice.  (uid_map, etc will
probably need to be revoked on unshare for this to work.)

--Andy
