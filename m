MIME-Version: 1.0
References: <CADvTj4qE8xKiEC8L5+XNypsTiSbFaBjf+t4ZpDVnVt9RqdcpSQ@mail.gmail.com>
In-Reply-To: <CADvTj4qE8xKiEC8L5+XNypsTiSbFaBjf+t4ZpDVnVt9RqdcpSQ@mail.gmail.com>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Sat, 22 Dec 2018 03:09:12 -0500
Message-ID: <CAFUG7CcueM1JmY5N2Fug0e8XSYFpqw=+4Gm4LuaR0Jn8ZzqzUQ@mail.gmail.com>
Subject: Re: grsecurity updated source code
Content-Type: text/plain; charset="UTF-8"
To: James Hilliard <james.hilliard1@gmail.com>
Cc: kernel-hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Seeing how it's been a few days, a few commits into the 4.4 tree from
upstream, and no statement from the grsec folks in response to this
drop on this list anyway, it may be prudent to have a warning label on
this patch considering it is (at least sourced from work) intended to
enhance the security posture of a system:
1 - keeping these up to date is not for the faint of heart, and
realistically even people doing that for their own education still use
the official work in production (or base off of it). For example,
rebasing the tip commit from this repo into 4.4.169 should provide for
some interesting reading into the Linux codebase in everything from
memory management to the KVM hypervisor, and some interesting choices
for the reader at the end of it all. Getting it wrong may not be
apparent at compile time, and wrong may not even be a crash but an
unsafe condition affecting filesystem or memory/execution-flow
protections. The effort of going through that process of figuring out
"how it works" and "how to keep it working" is incredibly valuable
when it produces understanding of the intent and implementation, but
in terms of executable binary images, it does not produce safe/stable
results suited for production use without some practice.
2 - without a trusted entity blessing the sha256sum of that commit's
contents, it may be unsafe to use without full review, _especially_ in
security-sensitive implementations. Searching for basic backdoors in
that amount of code is already a problem (try something that leaves
write holes into EFI/memory/ME/etc when wrapped with the first
analysis), finding changes to compiler plugins which could weaken
their functionality, compromise, or destabilize the system would
require someone trusted, with verified access to the real deal (on
this kernel version no less), willing to do the work, etc.
2a - even the act of compiling this should be performed in a sandboxed
environment until its known to not cause harm during that process. Its
still code execution.

See #2 for why few people are able to confirm/deny if this patch "is
real," but it is at least sourced from the real deal. The GPL seems to
have worked to give the public a snapshot view of work at least
derived from the grsec folks' significant efforts over the last year
and a half. This is an opportunity to learn and improve the public
ecosystem, not a security solution for anyone actually responsible for
their/client/etc security unless they _really_ know what they're doing
when working with the codebase.
Nobody from Open Source Security Inc (i think that's the grsec authors
official designation) asked me to write this, i actually do not have
direct communication with them at all, and i have no idea how they
will view these warnings. Considering their work, i assume they would
also suggest everyone practice safe exec...

-Boris

On Tue, Dec 18, 2018 at 9:09 AM James Hilliard
<james.hilliard1@gmail.com> wrote:
>
> I've obtained and uploaded a recent grsecurity kernel here:
> https://github.com/jameshilliard/linux-grsec/
>
> From my understanding this is the stable patch.
>
> Source code was obtained from a vendor via GPL request.
>
> James
