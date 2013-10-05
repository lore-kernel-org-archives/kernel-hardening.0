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
	<87fvsgy7cn.fsf@xmission.com>
	<CALCETrVFNcGtsm3N50sZRDWmBOJ3VWn=BidAOV4Q+eDwYhJ+vw@mail.gmail.com>
Date: Fri, 04 Oct 2013 17:35:22 -0700
In-Reply-To: <CALCETrVFNcGtsm3N50sZRDWmBOJ3VWn=BidAOV4Q+eDwYhJ+vw@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 4 Oct 2013 15:59:51 -0700")
Message-ID: <871u40r1v9.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if file's opener may access task
To: Andy Lutomirski <luto@amacapital.net>
Cc: Djalal Harouni <tixxdz@opendz.org>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Andy Lutomirski <luto@amacapital.net> writes:

> On Fri, Oct 4, 2013 at 3:55 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Fri, Oct 4, 2013 at 12:41 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>>>> On Fri, Oct 04, 2013 at 12:32:09PM -0700, Andy Lutomirski wrote:
>>>>> On Fri, Oct 4, 2013 at 12:27 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>>
>>>>> > So sorry Andy, I don't follow what you are describing.
>>>>>
>>>>> And what parameters are you passing to security_ptrace_access_check?
>>>>> It's supposed to be f_cred, right?  Because you want to make sure
>>>>> that, if the opener had some low-privilege label, the target has
>>>>> execed and gotten a more secure label, and the reader has a
>>>>> high-privilege label, that the opener's label is checked against the
>>>>> target's new label.
>>>> The current's cred each time.
>>>
>>> Exactly.  Hence the NAK.
>>>
>>>>
>>>> Is there some mechanism to check what you describe?
>>>>
>>>
>>> No.  You could try to add one, but getting it to be compatible with
>>> YAMA might be really messy.
>>>
>>> Or you could see if destroying and recreating all the inodes on exec
>>> or some other revoke-like approach would work.
>>
>> This is a revoke like approach, and yes proc has a fully functional
>> revoke infrastructure.  Right now that revoke is based on the process
>> going away.  The problem challenge is that the process is morphing.
>>
>> The practical question is which runtime checks do we want to perform.
>>
>> If we can say in no uncertain terms that short of a suid exec that
>> no calls (such as setuid) can change the process permissions beyond
>> our ability to access the file, we can detect and exec and use that
>> as a signal.
>
> If you could ptrace a process before it calls setuid and you can't
> after it calls setuid, then this is stupid and doesn't matter -- once
> you've pwned a process, you retain your pwnership at least until exec.

That is a reasonable principle to work from.  Still I am seeing cases
where dumpable can change in principle if not in fact with a cred
change.

But yes exec does appear to be the event to focus on.

> So yes, except that it's not just suid exec.  It's any exec that any
> LSM would not do if no_new_privs were set.

>> Alternatively we may to look at a processes credentials and in all
>> cases where those change use that as a signal that the file must
>> be reopened.
>
> Hmm.  So why don't we just do a revoke whenever an exec that changes
> cred happens?  (This will have some false positives, like unsharing
> userns, I think, but we probably don't care.)

But because it is proc and because people do crazy things we have to
investigate and test before we merge something like that.  I believe
there was a patch not long ago that would fail an access if the openers
and and the accessors creds which blew up rather quickly.

But it is definitely worth looking at.

>> Right now the model that we do a full permission check at every system
>> call because the morphing process may cause problems.  If analysis can
>> be done to show that we can use a simpler check than a full permission
>> check that would be grand.
>>
>> The problem is not lack of techinical infrastructure (revoke).  The
>> problem is a question of which tests are sufficient.
>
> Can you point us at that infrastructure?  My limited grepping skills
> didn't spot it.

There are about 3 implementations in proc.  One for sysctl, one for the
generic files and one for the pid files.

For pid files it is a lazy implementation.  Look at get_proc_task
and pid_revalidate.

The code that handles proc generic files and the related code that
handles the removal of sysfs files is more like a classic revoke.

> I'd really like a solution where there are no read or write
> implementations in the entire kernel that check permissions.  Failing
> that, just getting it for procfs would be nice.  (uid_map, etc will
> probably need to be revoked on unshare for this to work.)

I am certainly in favor of open acting as a capability grant and
arranging things so permission checks are not needed later.

uid_map has the interesting case that it doesn't know what permissions
you need until after you have written the data.  Mapping just your one
uid doesn't require any of root privileges.  So to move that permission
check into open it would have to become a flag.  Allow to write
arbitrary uids, which we could test at write time.

But that is a weird case and let's concentrate on the common case of
proc files.

Eric
