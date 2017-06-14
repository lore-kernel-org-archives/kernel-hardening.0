References: <20170608034349.31876-1-matt@nmatt.com>
 <20170608034349.31876-2-matt@nmatt.com>
 <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com>
 <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com>
 <20170613212704.GA16726@openwall.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <8e0e54ed-7532-8698-04db-2f804bc1ce90@nmatt.com>
Date: Wed, 14 Jun 2017 12:24:50 -0400
MIME-Version: 1.0
In-Reply-To: <20170613212704.GA16726@openwall.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution
 as a stackable LSM
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 6/13/17 5:27 PM, Solar Designer wrote:
> Matt,
> 
> I removed most CC's like before, as I don't want my voice on this to be
> too loud.
> 

I really appreciate your feedback and feel like it will only go to
making TPE better in the end.

> On Thu, Jun 08, 2017 at 11:50:32PM -0400, Matt Brown wrote:
>> On 06/08/2017 10:38 PM, Kees Cook wrote:
>>> On Wed, Jun 7, 2017 at 8:43 PM, Matt Brown <matt@nmatt.com> wrote:
>>>> *  Issues:
>>>>   *  Can be bypassed by interpreted languages such as python. You can run
>>>>      malicious code by doing: python -c 'evil code'
>>>
>>> What's the recommendation for people interested in using TPE but
>>> having interpreters installed?
>>
>> If you don't need a given interpreter installed, uninstall it. While
>> this is common sense system hardening it especially would make a
>> difference under the TPE threat model.
>>
>> I don't have a knock down answer for this. Interpreters are a hard
>> problem for TPE.
> 
> Interpreters are only a tip of the iceberg.
> 
> With TPE, every program invocation becomes similar to a SUID/SGID one as
> it relates to TPE's newly introduced security barrier.  However, the
> dynamic linker and libc have no idea of this, and will happily grant
> arbitrary code execution in context of those programs via LD_PRELOAD and
> such.  Even if this is somehow dealt with (how would you do that in the
> kernel alone? filter typical env var names? it quickly becomes way too
> hackish and blacklistish, thus imperfect), then there's still:
> 

FYI Mimi Zohar has posted this LSM that aims to restrict interpreters:
http://kernsec.org/pipermail/linux-security-module-archive/2017-June/001758.html

That conversation is relevant here and I am thinking about merging some
of those concepts into TPE.

> I think many, and maybe most, binaries on a system will contain buffer
> overflows and such that also allow for arbitrary code execution.  Those
> programs were not written as carefully as SUID/SGID ones are supposed to
> be.  They don't treat their input and environment as untrusted.
> 

Sure but there are other protections that can be put in place to
mitigate memory corruption exploits. e.g.:
https://wiki.gentoo.org/wiki/Hardened/Toolchain

Even if these buffer overflows do exist, TPE still raises the bar for
the attacker to execute on their objective.

> Closer to the topic of interpreters, there's also this old trick:
> 
> $ strace -e execve /lib/ld-linux.so.2 /bin/uname -ms
> execve("/lib/ld-linux.so.2", ["/lib/ld-linux.so.2", "/bin/uname", "-ms"], [/* 28 vars */]) = 0
> Linux i686
> +++ exited with 0 +++
> 

This is blocked with the current patch because I'm checking the mmap LSM
hook for any untrusted files being mmap'ed with the exec bit set.

Dmesg log from TPE after testing the strace trick above:
TPE: Denied mmap of /vuln/ls Reason: file in world-writable directory
and not in trusted group

> As you can see, the only execve(2) is of the dynamic linker.  Will /lib
> or/and /lib64 be among trusted paths in a typical setup?  Well, maybe
> not, although not including them will break ldd(1) on the more security
> conscious distros, where it uses a similar trick of invoking the dynamic
> linker explicitly (rather than the historical unsafe way of invoking the
> binary being ldd'ed with some env vars set to tell its dynamic linker to
> do the magic rather than proceed to execute the program).
> 
> But this last one is relatively minor.  The real big issue is that TPE
> is either inherently fairly easily bypassable (and should be documented
> as such) via many of the installed programs (by far not just explicit
> interpreters, but also any programs containing "weird machines", which
> is probably most non-trivial programs out there, and some trivial ones),
> or it relies on all programs in the trusted paths being written as if
> they were SUID/SGID (unrealistic for non-trivial systems).

I suppose I can make my documentation more clear that I don't believe
TPE is a replacement for a mandatory access control system. I believe
that the "selling point" of TPE is that it has a zero/low setup effort
that makes it viable to a certain category of user that will never put
in the effort to setup SELinux, RBAC, SMACK, or AppArmor.

I do believe with the conversation that is going on about Mimi Zohar's
Shebang LSM that we can use that work to plug up some of the current
holes in TPE

Matt
