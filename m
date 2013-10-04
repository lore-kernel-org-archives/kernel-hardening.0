Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20131004085911.GA2157@dztty>
References: <1380659178-28605-3-git-send-email-tixxdz@opendz.org>
 <524B78A2.40007@amacapital.net> <20131002145506.GA2669@dztty>
 <CALCETrW=6nnU0uQBqbFyJY8Fj+CHoGbOnGJ-aOB+3GwtV0f1bw@mail.gmail.com>
 <20131003143653.GA32445@dztty> <CALCETrU_D7X+jPWseiyp3FJJnw5CHhLbGz73FVDaeBpRDA+-og@mail.gmail.com>
 <20131003192926.GB2390@dztty> <CALCETrVDqBAcdJDFihzTZ23SJBmP5jmHfqqXyTqre38t8xn7Tg@mail.gmail.com>
 <20131003201332.GA3500@dztty> <CALCETrUOMF8MU9xpkQKYub-95fh9DAVBgPBXpAmMdmsb74HcTg@mail.gmail.com>
 <20131004085911.GA2157@dztty>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 4 Oct 2013 16:40:01 +0100
Message-ID: <CALCETrU5vBcqCbKAh=1wWPjt6js7A4R2xtnwc3Z1Z0FRMLP1SQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if file's
 opener may access task
To: Djalal Harouni <tixxdz@opendz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 4, 2013 at 9:59 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> On Thu, Oct 03, 2013 at 02:09:55PM -0700, Andy Lutomirski wrote:
>> On Thu, Oct 3, 2013 at 1:13 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> > On Thu, Oct 03, 2013 at 12:37:49PM -0700, Andy Lutomirski wrote:
>> >> On Thu, Oct 3, 2013 at 12:29 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> >> > On Thu, Oct 03, 2013 at 04:12:37PM +0100, Andy Lutomirski wrote:
>> >> >> On Thu, Oct 3, 2013 at 3:36 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> >> > Yes, I already did this, not only setuid, capabilities also are handled
>> >> > See the whole patch, please!
>> >> >
>> >> >
>> >> > Yes, and speaking about LSMs I've mentioned in my patches and doc, that
>> >> > the proposed function proc_allow_access() should be used after
>> >> > ptrace_may_access(). proc_allow_access() is not a replacement for
>> >> > ptrace_may_access(), it should be used *after* it.
>> >> >
>> >> > So cap_ptrace_access_check() is called, and before the file->f_cred
>> >> > checks. The LSM veto is already there.
>> >>
>> >> It's possible that I've misunderstood your patches, but I really don't
>> >> see where you're calling into LSMs to give them a chance to veto
>> >> access by *f_cred*.
>> > Ahh ok, I see, but why you want absolutly to put *f_cred* in this ?
>> >
>> > That's not its job, LSM veto is handled during read() correctly before
>> > proc_allow_access() and f_cred check. And if you want to do it correctly
>> > then f_cred should be handled during its time, during ->open().
>> > The correct way to handle it: ptrace_may_access() during ->open() and
>> > each syscall for sensitive files.
>> >
>> > Why add and speak about all this complexity where the correct check is
>> > just add ptrace_may_access() during ->open() ? using *f_cred* in this
>> > context and bring it here is not a valid argument IMO.
>>
>> I don't want to put f_cred into this.  I'd rather the patches just
>> check everything at open() time.  Doing that will require some form of
>> revocation, I think.
>>
>> Your current patches use f_cred, and they seem to do it wrong.  So
> The current patches block and protect the current attacks correctly,
> without overhead.
>
> Example:
> proc_uid_map_write()
>  -> map_write()
>    -> file_ns_capable()
>       -> security_capable(file->f_cred, ns, cap)
>
> file_ns_capable() added in commit 935d8aabd4331 by Linus
> Add file_ns_capable() helper function for open-time capability checking
>
> That also goes for commit 6708075f104c3c9b0 by Eric,
> userns: Don't let unprivileged users trick privileged users into setting
> the id_map
>
> The proc_allow_access() function that I've proposed has the same logic
> of file_ns_capable(), We can even put file_ns_capable() inside
> proc_allow_access(). We'll add support of security_capable_noaudit()
> inside file_ns_capable() and proc_allow_access() will be much more
> better.
>
> file_ns_capable() checks where a capability was there,
> proc_allow_access() checks where they have same uid + if capability was
> there.
>
>> please either fix it, stop using f_cred, or explain why it it's okay
>> despite not invoking LSM in the expected way.
> I've already explained it.
>
> LSM is handled by ptrace_may_access() which should be called during
> ->open() to handle f_cred, and during ->read() to handle current's cred.

This is getting tiresome.  This patch (2/9) has my NAK.  The other
patches depend on it, so I will not ack them.  (The maintainers may or
may not care about my NAK -- that's their business.)

Your code is *wrong* for even the simple case of /proc/*/syscall.  Consider:

Start with two processes, a and b, both normal tasks started by an
unprivileged user.  Process a opens /proc/<b's pid>/syscall.  All
checks pass.  Process b execs a setcap'd binary.  So b's uid and gid
do not change.

Then process a redirects stdin to that existing /proc/<b's pid>/stack
fd.  Here's the bug in your patch: process a can *still* read that fd.
 Why?  Because *you're not checking that a's capabilities are a
superset of b's*.  That code lives in the LSM infrastructure.  You
need to call it if you want to keep the general approach you're
trying.  You can't fix this just by checking for CAP_PTRACE, because
then you'll break SELinux.

This is messy, and it's why I think that you'd be better off doing
this by revoking the fd on exec instead.

--Andy
