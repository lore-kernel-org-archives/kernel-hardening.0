Subject: Re: [PATCH v4 1/2] Documentation/admin-guide: introduce
 perf-security.rst file
From: Alexey Budankov <alexey.budankov@linux.intel.com>
References: <feac7efa-df6f-cca1-e321-28d220bf0411@linux.intel.com>
 <b1a4fa08-482d-0fcc-c798-efb9a9894a47@linux.intel.com>
 <20181127111148.75746f02@lwn.net>
 <5e1e9c08-dff5-956d-4c2b-8ee090c387c3@linux.intel.com>
Message-ID: <e7fd5492-f48e-7696-f894-a3ab60479ac5@linux.intel.com>
Date: Mon, 3 Dec 2018 12:42:09 +0300
MIME-Version: 1.0
In-Reply-To: <5e1e9c08-dff5-956d-4c2b-8ee090c387c3@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Peter,

On 27.11.2018 22:13, Alexey Budankov wrote:
> On 27.11.2018 21:11, Jonathan Corbet wrote:
>> On Tue, 27 Nov 2018 11:15:37 +0300
>> Alexey Budankov <alexey.budankov@linux.intel.com> wrote:
>>
>>> +To perform security checks, the Linux implementation splits processes into two
>>> +categories [6]_ : a) privileged processes (whose effective user ID is 0, referred
>>> +to as superuser or root), and b) unprivileged processes (whose effective UID is
>>> +nonzero). Privileged processes bypass all kernel security permission checks so
>>> +perf_events performance monitoring is fully available to privileged processes
>>> +without access, scope and resource restrictions.
>>> +
>>> +Unprivileged processes are subject to a full security permission check based on
>>> +the process's credentials [5]_ (usually: effective UID, effective GID, and
>>> +supplementary group list).
>>> +
>>> +Linux divides the privileges traditionally associated with superuser into
>>> +distinct units, known as capabilities [6]_ , which can be independently enabled
>>> +and disabled on per-thread basis for processes and files of unprivileged users.
>>> +
>>> +Unprivileged processes with enabled CAP_SYS_ADMIN capability are treated as
>>> +privileged processes with respect to perf_events performance monitoring and
>>> +bypass *scope* permissions checks in the kernel.
>>> +
>>> +Unprivileged processes using perf_events system call API is also subject for
>>> +PTRACE_MODE_READ_REALCREDS ptrace access mode check [7]_ , whose outcome
>>> +determines whether monitoring is permitted. So unprivileged processes provided
>>> +with CAP_SYS_PTRACE capability are effectively permitted to pass the check.
>>
>> It's good to have more information here.  I could certainly quibble
>> further with things - a process with CAP_SYS_ADMIN is not "unprivileged"!
>> - but I don't want to stand in the way of this any further.  I *would*
>> still like to see an ack from the perf world, though.
> 
> Thanks for meaningful comments! Looking forward to ack from perf world.

May I ask you to review v4 of the patches? 
Your comments on v1 have been addressed in there.

Thanks,
Alexey

> 
>>
>> With regard to Kees's comment on merging the two patches; I would probably
>> add the new document to index.rst in the same patch, but it doesn't matter
>> that much.  Not worth redoing the patch just for that.
> 
> Thanks,
> Alexey
> 
>>
>> jon
>>
> 
