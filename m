Subject: Re: [PATCH v1 2/2]: Documentation/admin-guide: introduce
 perf-security.rst file
References: <0ac97cd0-4773-fff6-7d4e-74c4a1f076c4@linux.intel.com>
 <a44df303-d962-c1a4-4fe0-6bad887ebcdc@linux.intel.com>
 <20181119103337.GZ9761@hirez.programming.kicks-ass.net>
From: Alexey Budankov <alexey.budankov@linux.intel.com>
Message-ID: <acc29e9c-39ce-d255-66aa-1886a351476e@linux.intel.com>
Date: Tue, 27 Nov 2018 11:17:00 +0300
MIME-Version: 1.0
In-Reply-To: <20181119103337.GZ9761@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Andi Kleen <ak@linux.intel.com>, Jonatan Corbet <corbet@lwn.net>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On 19.11.2018 13:33, Peter Zijlstra wrote:
> On Mon, Nov 19, 2018 at 08:42:52AM +0300, Alexey Budankov wrote:
>>
>> Implement initial version of perf-security.rst documentation file 
>> initially covering security concerns related to PCL/Perf performance 
>> monitoring in multiuser environments.
> 
> Ditch the PCL thing. That's not a term used anywhere in the kernel.

Addressed. Please see v4.

> 
> Also:
> 
>> +PCL/Perf unprivileged users
>> +---------------------------
>> +
>> +PCL/Perf *scope* and *access* control for unprivileged processes is governed by
>> +perf_event_paranoid [2]_ setting:
>> +
>> +**-1**:
>> +     Impose no *scope* and *access* restrictions on using PCL performance
>> +     monitoring. Per-user per-cpu perf_event_mlock_kb [2]_ locking limit is
>> +     ignored when allocating memory buffers for storing performance data.
>> +     This is the least secure mode since allowed monitored *scope* is
>> +     maximized and no PCL specific limits are imposed on *resources*
>> +     allocated for performance monitoring.
>> +
>> +**>=0**:
>> +     *scope* includes per-process and system wide performance monitoring
>> +     but excludes raw tracepoints and ftrace function tracepoints monitoring.
>> +     CPU and system events happened when executing either in user or
>> +     in kernel space can be monitored and captured for later analysis.
>> +     Per-user per-cpu perf_event_mlock_kb locking limit is imposed but
>> +     ignored for unprivileged processes with CAP_IPC_LOCK [6]_ capability.
>> +
>> +**>=1**:
>> +     *scope* includes per-process performance monitoring only and excludes
>> +     system wide performance monitoring. CPU and system events happened when
>> +     executing either in user or in kernel space can be monitored and
>> +     captured for later analysis. Per-user per-cpu perf_event_mlock_kb
>> +     locking limit is imposed but ignored for unprivileged processes with
>> +     CAP_IPC_LOCK capability.
>> +
>> +**>=2**:
>> +     *scope* includes per-process performance monitoring only. CPU and system
>> +     events happened when executing in user space only can be monitored and
>> +     captured for later analysis. Per-user per-cpu perf_event_mlock_kb
>> +     locking limit is imposed but ignored for unprivileged processes with
>> +     CAP_IPC_LOCK capability.
>> +
>> +**>=3**:
>> +     Restrict *access* to PCL performance monitoring for unprivileged processes.
>> +     This is the default on Debian and Android [7]_ , [8]_ .
> 
> that ** crud is unreadable.
> 
> http://lkml.kernel.org/r/094556ca-ea87-9c4a-2115-600d2833fb2a@darmarit.de
> 

Addressed. Please see v4.

Thanks,
Alexey
