MIME-Version: 1.0
In-Reply-To: <20170425222135.2859b1a8@lxorguk.ukuu.org.uk>
References: <20170425041512.13189-1-matt@nmatt.com> <20170425144746.0d8721a3@lxorguk.ukuu.org.uk>
 <CAG48ez0uYkAg65iBZ8cKLxzFyEK=Axt=NP7jnmQkFp4rN=0GzA@mail.gmail.com>
 <20170425203015.1ae62057@lxorguk.ukuu.org.uk> <CAG48ez2u8Op1ej9Z3z+PNaeEqh2f3LKnUqQku+g6asGc3K6q9g@mail.gmail.com>
 <20170425222135.2859b1a8@lxorguk.ukuu.org.uk>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Apr 2017 23:44:50 +0200
Message-ID: <CAG48ez31W30Qqmf5ZZ1_eVQC0uobBrva3_zgRdzejztFLzKoPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 0/2] security: tty: make TIOCSTI ioctl require CAP_SYS_ADMIN
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Matt Brown <matt@nmatt.com>, serge@hallyn.com, jmorris@namei.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jslaby@suse.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 25, 2017 at 11:21 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>> Really? By "pty", are you referring to the master? If so, as far as I know,
>> to go from the slave to the master, you need one of:
>>
>>  - ptrace access to a process that already has an FD to the master, via
>>    ptrace() or so (/proc/$pid/fd/$fd won't work)
>>  - for a BSD PTY (which AFAIK isn't used much anymore), access to
>>    /dev/ptyXX
>
> fstat() and then open *assuming* I have permissions.

open() what? As far as I know, for System-V PTYs, there is no path you can
open() that will give you the PTY master. Am I missing something?

>> > If I want to do the equvalent of the TIOCSTI attack then I fork a process
>> > and exit the parent. The child can now use ptrace to reprogram your shell
>> > to do whatever interesting things it likes (eg running child processes
>> > called "su" via a second pty/tty pair). Not exactly rocket science.
>>
>> Why would the child be able to ptrace the shell? AFAICS, in the most
>> relevant scenarios, the child can't ptrace the shell because the
>> shell has a different UID (in the case of e.g. su or sudo). In other
>
> If I am the attacker wanting to type something into your su when you go
> and su from my account, or where the user account is trojanned I do the
> following
>
> fork
> exit parent
> child ptraces the shell (same uid as it's not setuid)
>
> You type "su" return
> The modified shell opens a new pty/tty pair and runs su over it
> My ptrace hooks watch the pty/tty traffic until you go to the loo
> My ptrace hooks switch the console
> My ptrace hooks type lots of stuff and hack your machine while eating the
> output
>
> and you come back, do stuff and then exit
>
> And if you are in X it's even easier and I don't even need to care about
> sessions or anything. X has no mechanism to sanely fix the problem, but
> Wayland does.

I think the "When using a program like su or sudo" in the patch description
refers to the usecase where you go from a more privileged context (e.g. a
root shell) to a less privileged one (e.g. a shell as a service-specific
account used to run a daemon), not the other way around.

[However, I do think that it's a nice side effect of this patch that it will
prevent a malicious program from directly injecting something like an
SSH command into my shell in a sufficiently hardened environment
(with LSM restrictions that prevent the malicious program from opening
SSH keyfiles or executing another program that can do that). Although
you could argue that in such a case, the LSM should be taking care of
blocking TIOCSTI.]
