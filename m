Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20131003122959.GA3619@dztty>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
 <524B7999.60806@amacapital.net> <20131002143759.GA2966@dztty>
 <CALCETrUcg4o5QeGMP1rRAzJSfjwS=qD3DsDWV3=fPJQOA3xkKw@mail.gmail.com>
 <CAGXu5j+APTTSKh_xvgpzV3wNYseQxafbKqQ3NyvUe50aGOOBGg@mail.gmail.com>
 <20131002182206.GB2485@dztty> <CAGXu5jL3iReSCfRRXGaKp4dikh5f3BR55NbVEXHrTscTSDgeZA@mail.gmail.com>
 <20131002184844.GB3393@dztty> <20131003061244.GC25345@gmail.com> <20131003122959.GA3619@dztty>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 3 Oct 2013 16:15:43 +0100
Message-ID: <CALCETrV2tdHAkLs=FQexnEkdSeXjLD51bKe9B67amnMYnVj1sQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2 0/9] procfs: protect /proc/<pid>/* files with file->f_cred
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 3, 2013 at 1:29 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> On Thu, Oct 03, 2013 at 08:12:44AM +0200, Ingo Molnar wrote:
>>
>> * Djalal Harouni <tixxdz@opendz.org> wrote:
>>
>> > > Regardless, glibc uses /proc/self/maps, which would be fine here, right?
>> >
>> > I did not touch /proc/self/maps and others, but I'm planning to fix them
>> > if this solution is accepted.
>> >
>> > I'll do the same thing as in /proc/*/stat for maps, let it be 0444, and
>> > try to delay the check to ->read(). So during ->read() perform
>> > ptrace_may_access() on currenct's cred and process_allow_access() on
>> > file's opener cred. This should work.
>>
>> Aren't read() time checks fundamentally unrobust? We generally don't do
>> locking on read()s, so such checks - in the general case - are pretty
>> racy.
> For procfs yes, read() time checks are unrobust, the general agreement on
> procfs is checks should be performed during each syscall.
>
> For the locking on read()/write() IMHO there should be locking by design
> for /proc/pid/* entries. Here we are speaking about content that varies,
> data attached to other processes, so there is already some locking
> mechanism, and for sensitive stuff, we must hold the cred mutex. This
> is the standard from the old days of procfs.
>
>
> And yes some of them are racy, but we can improve it, delay the checks.
>
> From old Linux git history, before the initial git repository build, I
> found that some important checks were done right after gathering the info.
>
>
>> Now procfs might be special, as by its nature of a pseudofilesystem it's
>> far more atomic than other filesystems, but still IMHO it's a lot more
>
>
>> robust security design wise to revoke access to objects you should not
>> have a reference to when a security boundary is crossed, than letting
>> stuff leak through and sprinking all the potential cases that may leak
>> information with permission checks ...
> I agree, but those access should also be checked at the beginning, IOW
> during ->open(). revoke will not help if revoke is not involved at all,
> the task /proc entries may still be valide (no execve).
>
> Currently security boundary is crossed for example arbitrary /proc/*/stack
> (and others).
> 1) The target task does not do an execve (no revoke).
> 2) current task will open these files and *want* and *will* pass the fd to a
> more privileged process to pass the ptrace check which is done only during
> ->read().

What does this?  Or are you saying that this is a bad thing?

(And *please* don't write software that *depends* on different
processes having different read()/write() permissions on the *same*
struct file.  I've already found multiple privilege escalations based
on that, and I'm pretty sure I can find some more.)

>
>
>> It's also probably faster: security boundary crossings are relatively rare
>> slowpaths, while read()s are much more common...
> Hmm, These two are related? can't get rid of permission checks
> especially on this pseudofilesystem!
>
>
>> So please first get consensus on this fundamental design question before
>> spreading your solution to more areas.
> Of course, I did clean the patchset to prove that it will work, and I
> only implemented full protection for /proc/*/{stack,syscall,stat} other
> files will wait.
>
> But Ingo you can't ignore the fact that:
> /proc/*/{stack,syscall} are 0444 mode
> /proc/*/{stack,syscall} do not have ptrace_may_access() during open()
> /proc/*/{stack,syscall} have the ptrace_may_access() during read()

I think everyone agrees that this is broken.  We don't agree on the
fix check.  (Also, as described in my other email, your approach may
be really hard to get right.)

--Andy
