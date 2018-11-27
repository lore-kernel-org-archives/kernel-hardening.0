Subject: Re: [PATCH v2 1/2] Documentation/admin-guide: introduce
 perf-security.rst file
References: <259a9cd2-5c56-4f8d-57c4-cabaeaa774bc@linux.intel.com>
 <4d95341d-d1f4-fc48-f173-a6fedfc70d33@linux.intel.com>
 <20181125124732.6c1807de@lwn.net>
 <02dbd6dc-86b5-2307-4122-b716c51b9eaa@linux.intel.com>
 <20181126132833.5302688b@lwn.net>
From: Alexey Budankov <alexey.budankov@linux.intel.com>
Message-ID: <3a07906e-83c0-e7ae-7249-84deafdd52e0@linux.intel.com>
Date: Tue, 27 Nov 2018 09:55:35 +0300
MIME-Version: 1.0
In-Reply-To: <20181126132833.5302688b@lwn.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Andi Kleen <ak@linux.intel.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 26.11.2018 23:28, Jonathan Corbet wrote:
> On Mon, 26 Nov 2018 11:57:21 +0300
> Alexey Budankov <alexey.budankov@linux.intel.com> wrote:
> 
>>>> +For the purpose of performing security checks Linux implementation splits
>>>> +processes into two categories [6]_ : a) privileged processes (whose effective
>>>> +user ID is 0, referred to as superuser or root), and b) unprivileged processes
>>>> +(whose effective UID is nonzero).  
>>>
>>> Is that really what's going on here?  If I understand things correctly,
>>> it's looking for CAP_SYS_PTRACE rather than a specific UID; am I missing
>>> something here?  
>>
>> You are right regarding CAP_SYS_PTRACE but this capability is not the only 
>> one which is used by perf_events for security checks, so the capabilities 
>> clarification is kept aside of these patches, because patches initial intention 
>> is to clarify security specifics of sysctl_perf_even_paranoid settings.
>>
>> I agree that the document can be extended with details clarifying capabilities 
>> used by perf_events for security checks.
> 
> I don't really like the idea of adding a document that we know doesn't
> really describe how the security decision is made.  Even a one-line
> parenthetical saying that things are more complicated and giving a pointer
> to a place to look for details would help, IMO.

Well, makes sense. It is possible to have something similar to this:

...

For the purpose of performing security checks the Linux implementation splits
processes into two categories [6]_ : a) privileged processes (whose effective
user ID is 0, referred to as superuser or root), and b) unprivileged processes
(whose effective UID is nonzero).

Privileged processes bypass all kernel security permission checks so perf_events
performance monitoring is fully available to privileged processes without
access, scope and resource restrictions.

Unprivileged processes are subject to full security permission check based on 
the process's credentials [5]_ (usually: effective UID, effective GID, and 
supplementary group list).

Linux divides the privileges traditionally associated with superuser into
distinct units, known as capabilities [6]_, which can be independently enabled
and disabled on per-thread basis for processes and files of unprivileged users.

Unprivileged processes with enabled CAP_SYS_ADMIN capability are treated as 
privileged processes with respect to perf_events performance monitoring and
bypass *scope* permissions checks in the kernel.

Unprivileged processes using perf_events system call API is also subject for
PTRACE_MODE_READ_REALCREDS ptrace access mode check [7]_ , whose outcome determines
whether monitoring is permitted. So unprivileged process provided with
CAP_SYS_PTRACE capability are effectively permitted to pass the check.

Other capabilities being granted to unprivileged processes can effectively
enable capturing of additional data required for later performance analysis of
monitored processes or system. For example CAP_SYSLOG capability permits
reading kernel space memory addresses from /proc/kallsyms file.

...

Thanks,
Alexey

> 
> Either way, I can merge this, but I'd like to have an ack from the perf
> folks first.
> 
> Thanks,
> 
> jon
> 
