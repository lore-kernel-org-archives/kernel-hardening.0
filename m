Date: Wed, 6 Feb 2019 16:58:58 -0700
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v1 1/3] perf-security: document perf_events/Perf
 resource control
Message-ID: <20190206165858.19fdaf58@lwn.net>
In-Reply-To: <bfd0e4bb-a4a5-e65d-e8e2-d2c9d03f3160@linux.intel.com>
References: <9cfbf7a1-72dd-f9d0-8137-0f120fa74d21@linux.intel.com>
	<bfd0e4bb-a4a5-e65d-e8e2-d2c9d03f3160@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
To: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Jann Horn <jannh@google.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Andi Kleen <ak@linux.intel.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 1 Feb 2019 10:29:11 +0300
Alexey Budankov <alexey.budankov@linux.intel.com> wrote:

> Extend perf-security.rst file with perf_events/Perf resource control
> section describing RLIMIT_NOFILE and perf_event_mlock_kb settings for
> performance monitoring user processes.
> 
> Signed-off-by: Alexey Budankov <alexey.budankov@linux.intel.com>

Overall these patches seem reasonable, though I have some nits to pick.
I'm happy to apply them but wouldn't mind an ack from the perf camp.

Alexey, could you wrap your paragraphs at 72-75 columns?

> ---
>  Documentation/admin-guide/perf-security.rst | 36 +++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/Documentation/admin-guide/perf-security.rst b/Documentation/admin-guide/perf-security.rst
> index f73ebfe9bfe2..ff6832191577 100644
> --- a/Documentation/admin-guide/perf-security.rst
> +++ b/Documentation/admin-guide/perf-security.rst
> @@ -84,6 +84,40 @@ governed by perf_event_paranoid [2]_ setting:
>       locking limit is imposed but ignored for unprivileged processes with
>       CAP_IPC_LOCK capability.
>  
> +perf_events/Perf resource control
> +---------------------------------
> +
> +perf_events system call API [2]_ allocates file descriptors for every configured

*The* perf_events system call API

> +PMU event. Open file descriptors are a per-process accountable *resource* governed
> +by RLIMIT_NOFILE [11]_ limit (ulimit -n), which is usually derived from the login

by *the* RLIMIT_NOFILE

> +shell process. When configuring Perf collection for a long list of events on a
> +large server system, this limit can be easily hit preventing required monitoring
> +configuration. RLIMIT_NOFILE limit can be increased on per-user basis modifying
> +content of limits.conf file [12]_ on some systems. Ordinary Perf sampling session

of *the* limits.conf file

Ordinarily, a Perf

> +(perf record) requires an amount of open perf_event file descriptors that is not
> +less than a number of monitored events multiplied by a number of monitored CPUs.
> +
> +An amount of memory available to user processes for capturing performance monitoring
> +data is governed by perf_event_mlock_kb [2]_ setting. This perf_event specific

by *the* perf_event_mlock_kb

> +*resource* setting defines overall per-cpu limits of memory allowed for mapping

Why the *emphasis* here?

> +by the user processes to execute performance monitoring. The setting essentially
> +extends RLIMIT_MEMLOCK [11]_ limit but only for memory regions mapped specially

extends *the* RMLIMIT_MEMLOCK limit *,* but only

> +for capturing monitored performance events and related data.
> +
> +For example, if a machine has eight cores and perf_event_mlock_kb limit is set
> +to 516 KiB then a user process is provided with 516 KiB * 8 = 4128 KiB of memory

Kib, then

> +above RLIMIT_MEMLOCK limit (ulimit -l) for perf_event mmap buffers. In particular

above *the* RLIMIT_MEMLOCK

particular,

> +this means that if the user wants to start two or more performance monitoring

that, if

> +processes, it is required to manually distribute available 4128 KiB between the

s/it is/they are/

> +monitoring processes, for example, using --mmap-pages Perf record mode option.

using *the* --mmap-pages option

> +Otherwise, the first started performance monitoring process allocates all available
> +4128 KiB and the other processes will fail to proceed due to the lack of memory.
> +
> +RLIMIT_MEMLOCK and perf_event_mlock_kb *resource* constraints are ignored for
> +processes with CAP_IPC_LOCK capability. Thus, perf_events/Perf privileged users

with *the* CAP_IPC_LOCK

> +can be provided with memory above the constraints for perf_events/Perf performance
> +monitoring purpose by providing the Perf executable with CAP_IPC_LOCK capability.
> +
>  Bibliography
>  ------------
>  
> @@ -94,4 +128,6 @@ Bibliography
>  .. [5] `<https://www.kernel.org/doc/html/latest/security/credentials.html>`_
>  .. [6] `<http://man7.org/linux/man-pages/man7/capabilities.7.html>`_
>  .. [7] `<http://man7.org/linux/man-pages/man2/ptrace.2.html>`_
> +.. [11] `<http://man7.org/linux/man-pages/man2/getrlimit.2.html>`_
> +.. [12] `<http://man7.org/linux/man-pages/man5/limits.conf.5.html>`_

Thanks,

jon
