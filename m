Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5654CE83.3000503@redhat.com>
References: <564EF64F.1060903@redhat.com>
	<CAGXu5jLK61OFfSXtEzisMkdt9CnVaa5Eiw6sUB0=w2DjzPjJ5A@mail.gmail.com>
	<5654CE83.3000503@redhat.com>
Date: Tue, 24 Nov 2015 13:43:58 -0800
Message-ID: <CAGXu5j+zRXuiTipU=6VVoxacsYWcjhaax4gVbGRXteLihXVdOQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] System call interface changes
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 24, 2015 at 12:54 PM, Florian Weimer <fweimer@redhat.com> wrote:
> On 11/24/2015 09:10 PM, Kees Cook wrote:
>
>> Ah, are you looking at this as an anti-ROP idea? What's the bug class
>> or exploitation method you're looking at addressing?
>
> The idea, as it has been presented to me, is to remove the ability to
> invoke execve (and a few other system calls) completely, to push
> attackers *towards* ROP as the only means for injecting code into a
> process (not all processes, obviously, but a large class of processes as
> feasible).
>
> As far as I know, this is intended as a post-exploitation mitigation
> (before policy-based mechanisms or containers kick in).  I don't know
> enough about real-world attack scenarios to tell if these changes would
> make a difference.
>
>>> This would have to be an opt-in feature, obviously, and applications
>>> would have to opt in explicitly via some ELF flag (similar to what we
>>> did for non-executable stacks).
>>
>> There have been a growing number of things that seem like they'd be
>> nice to control with ELF flags. Andy Lutomirski recently wanted to
>> make the x86-64 vsyscall presence be selectable on a per-process
>> basis. (I think it's easier to just turn it off entirely.)
>
> Yes, we have a backlog in this area.  For usability reasons, we also
> need ways to mark separated debuginfo files, and PIE binaries (which
> currently look like DSOs).
>
>> I always come back to "how can we measure this?" If you've got an
>> exploit method you're trying to kill, etc, then it should be easy to
>> evaluate its utility.
>
> The final paragraph in
>
>   <http://openwall.com/lists/oss-security/2015/11/18/12>
>
> has some more context.  I think you are definitely asking the right
> questions, and I desire a more empirical approach to security
> improvements.  But this is the position I'm in.

Cool. Well, we can certainly look at existing public exploits and
PoCs. That's what I've been trying to collect on the Kernel
Self-Protection Project wiki pages. There are plenty of things we
could add to that list from the ROP world. Maybe it'd be good to look
through various exploit lists to find stuff that use techniques that
are either missing from the wiki page or are better examples? Do you
(or someone else) have time to go on a research/collection exercise?
Even pulling from academic papers can be useful here.

I think having concrete examples really helps both demonstrate
specifically what we're fixing and convince people that these are real
issues worth solving.

-Kees


-- 
Kees Cook
Chrome OS & Brillo Security
