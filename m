Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 4 Oct 2013 09:59:11 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20131004085911.GA2157@dztty>
References: <1380659178-28605-3-git-send-email-tixxdz@opendz.org>
 <524B78A2.40007@amacapital.net>
 <20131002145506.GA2669@dztty>
 <CALCETrW=6nnU0uQBqbFyJY8Fj+CHoGbOnGJ-aOB+3GwtV0f1bw@mail.gmail.com>
 <20131003143653.GA32445@dztty>
 <CALCETrU_D7X+jPWseiyp3FJJnw5CHhLbGz73FVDaeBpRDA+-og@mail.gmail.com>
 <20131003192926.GB2390@dztty>
 <CALCETrVDqBAcdJDFihzTZ23SJBmP5jmHfqqXyTqre38t8xn7Tg@mail.gmail.com>
 <20131003201332.GA3500@dztty>
 <CALCETrUOMF8MU9xpkQKYub-95fh9DAVBgPBXpAmMdmsb74HcTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUOMF8MU9xpkQKYub-95fh9DAVBgPBXpAmMdmsb74HcTg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if
 file's opener may access task
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 03, 2013 at 02:09:55PM -0700, Andy Lutomirski wrote:
> On Thu, Oct 3, 2013 at 1:13 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > On Thu, Oct 03, 2013 at 12:37:49PM -0700, Andy Lutomirski wrote:
> >> On Thu, Oct 3, 2013 at 12:29 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> > On Thu, Oct 03, 2013 at 04:12:37PM +0100, Andy Lutomirski wrote:
> >> >> On Thu, Oct 3, 2013 at 3:36 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> > Yes, I already did this, not only setuid, capabilities also are handled
> >> > See the whole patch, please!
> >> >
> >> >
> >> > Yes, and speaking about LSMs I've mentioned in my patches and doc, that
> >> > the proposed function proc_allow_access() should be used after
> >> > ptrace_may_access(). proc_allow_access() is not a replacement for
> >> > ptrace_may_access(), it should be used *after* it.
> >> >
> >> > So cap_ptrace_access_check() is called, and before the file->f_cred
> >> > checks. The LSM veto is already there.
> >>
> >> It's possible that I've misunderstood your patches, but I really don't
> >> see where you're calling into LSMs to give them a chance to veto
> >> access by *f_cred*.
> > Ahh ok, I see, but why you want absolutly to put *f_cred* in this ?
> >
> > That's not its job, LSM veto is handled during read() correctly before
> > proc_allow_access() and f_cred check. And if you want to do it correctly
> > then f_cred should be handled during its time, during ->open().
> > The correct way to handle it: ptrace_may_access() during ->open() and
> > each syscall for sensitive files.
> >
> > Why add and speak about all this complexity where the correct check is
> > just add ptrace_may_access() during ->open() ? using *f_cred* in this
> > context and bring it here is not a valid argument IMO.
> 
> I don't want to put f_cred into this.  I'd rather the patches just
> check everything at open() time.  Doing that will require some form of
> revocation, I think.
> 
> Your current patches use f_cred, and they seem to do it wrong.  So
The current patches block and protect the current attacks correctly,
without overhead.

Example:
proc_uid_map_write()
 -> map_write()
   -> file_ns_capable()
      -> security_capable(file->f_cred, ns, cap)

file_ns_capable() added in commit 935d8aabd4331 by Linus
Add file_ns_capable() helper function for open-time capability checking

That also goes for commit 6708075f104c3c9b0 by Eric,
userns: Don't let unprivileged users trick privileged users into setting
the id_map

The proc_allow_access() function that I've proposed has the same logic
of file_ns_capable(), We can even put file_ns_capable() inside
proc_allow_access(). We'll add support of security_capable_noaudit()
inside file_ns_capable() and proc_allow_access() will be much more
better.

file_ns_capable() checks where a capability was there,
proc_allow_access() checks where they have same uid + if capability was
there.

> please either fix it, stop using f_cred, or explain why it it's okay
> despite not invoking LSM in the expected way.
I've already explained it.

LSM is handled by ptrace_may_access() which should be called during
->open() to handle f_cred, and during ->read() to handle current's cred.

proc_allow_access() can't be called during ->open(), there is not reason
for that.

Now if you have read the patch correctly, perhaps you have noticed again
that's is already done!
[PATCH v2 8/9] procfs: improve permission checks on /proc/*/stack
[PATCH v2 9/9] procfs: improve permission checks on /proc/*/syscall

Both of these are sensitive files, it's like you are ptracing the
target! so did you check that for these two files I've added their
corresponding ->open(), stack_open() and syscall_open() that will
perform the ptrace_may_access() check and handle f_cred during open()
correctly.

So already there ;-)


Now you want to argue about /proc/*/stat, go ahead:

1) A vital sensitive file
2) any checks on ->open() will break userspace
3) *without* LSM support, there is no a ptrace_may_access() check during
   ->open() => will break userspace:  top, ps ....
   So we don't even go to LSM
4) /proc/*/stat is not like /proc/*/{syscall,stack}

5) If you want to do it, good luck make sure that you don't break "ps",
"top", but what you are saying thus not make sense at all! since that
LSM check depend on ptrace_may_access(), and the kernel without LSM
don't do it.

6) This is another problem, again not to f_cred after ->open()
   Your problem: is why ptrace_may_access() not called during ->open() ?
   to have that LSM check on cred == f_cred

   Answer: already done for sensitive files: stack,syscall


Before I forget:
1) cap_ptrace_access_check() as shown in the previous email, is already
emulated!

2) If LSM is there, then it will do correctly its security_capable()
check on f_cred as with the new function file_ns_capable()


Feel free to respond to these argument!

> --Andy

-- 
Djalal Harouni
http://opendz.org
