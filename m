References: <20170425041512.13189-1-matt@nmatt.com>
 <20170425144746.0d8721a3@lxorguk.ukuu.org.uk>
 <CAG48ez0uYkAg65iBZ8cKLxzFyEK=Axt=NP7jnmQkFp4rN=0GzA@mail.gmail.com>
 <20170425203015.1ae62057@lxorguk.ukuu.org.uk>
 <CAG48ez2u8Op1ej9Z3z+PNaeEqh2f3LKnUqQku+g6asGc3K6q9g@mail.gmail.com>
 <20170425222135.2859b1a8@lxorguk.ukuu.org.uk>
 <CAG48ez31W30Qqmf5ZZ1_eVQC0uobBrva3_zgRdzejztFLzKoPg@mail.gmail.com>
 <20170426134732.7579ebdd@lxorguk.ukuu.org.uk>
From: Matt Brown <matt@nmatt.com>
Message-ID: <07bec2b1-c945-fc6e-0238-28acb21b5cfb@nmatt.com>
Date: Wed, 26 Apr 2017 10:21:36 -0400
MIME-Version: 1.0
In-Reply-To: <20170426134732.7579ebdd@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 0/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Jann Horn <jannh@google.com>
Cc: serge@hallyn.com, jmorris@namei.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jslaby@suse.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 04/26/2017 08:47 AM, One Thousand Gnomes wrote:
>> open() what? As far as I know, for System-V PTYs, there is no path you can
>> open() that will give you the PTY master. Am I missing something?
>
> Sorry brain fade - no.
>>
>>>>> If I want to do the equvalent of the TIOCSTI attack then I fork a process
>>>>> and exit the parent. The child can now use ptrace to reprogram your shell
>>>>> to do whatever interesting things it likes (eg running child processes
>>>>> called "su" via a second pty/tty pair). Not exactly rocket science.
>>>>
>>>> Why would the child be able to ptrace the shell? AFAICS, in the most
>>>> relevant scenarios, the child can't ptrace the shell because the
>>>> shell has a different UID (in the case of e.g. su or sudo). In other
>>>
>>> If I am the attacker wanting to type something into your su when you go
>>> and su from my account, or where the user account is trojanned I do the
>>> following
>>>
>>> fork
>>> exit parent
>>> child ptraces the shell (same uid as it's not setuid)
>>>
>>> You type "su" return
>>> The modified shell opens a new pty/tty pair and runs su over it
>>> My ptrace hooks watch the pty/tty traffic until you go to the loo
>>> My ptrace hooks switch the console
>>> My ptrace hooks type lots of stuff and hack your machine while eating the
>>> output
>>>
>>> and you come back, do stuff and then exit
>>>
>>> And if you are in X it's even easier and I don't even need to care about
>>> sessions or anything. X has no mechanism to sanely fix the problem, but
>>> Wayland does.
>>
>> I think the "When using a program like su or sudo" in the patch description
>> refers to the usecase where you go from a more privileged context (e.g. a
>> root shell) to a less privileged one (e.g. a shell as a service-specific
>> account used to run a daemon), not the other way around.
>
> Which is the sudo case and why sudo uses a separate pty/tty pair as it's
> not just TIOCSTI that's an issue but there are a load of ioctls that do
> things like cause signals to the process or are just annoying -
> vhangup(), changing the speed etc
>
> (And for console changing the keymap - which is a nasty one)
>

Are any of these annoyances potential security issues? I would be happy
to add patches or modify this one to include extra hardening measures.

>> [However, I do think that it's a nice side effect of this patch that it will
>> prevent a malicious program from directly injecting something like an
>> SSH command into my shell in a sufficiently hardened environment
>> (with LSM restrictions that prevent the malicious program from opening
>> SSH keyfiles or executing another program that can do that). Although
>> you could argue that in such a case, the LSM should be taking care of
>> blocking TIOCSTI.]
>
> I would submit that creating a new pty/tty pair is the proper answer for
> that case however. Making the tty calls respect namespaces is however
> still a no-brainer IMHO.
>
> Alan
>
