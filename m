Date: Sun, 10 Feb 2019 23:34:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 1/4] perf-security: document perf_events/Perf resource
 control
In-Reply-To: <a108c800-d6c1-fac1-b73b-e390e579e6ef@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1902102300210.8784@nanos.tec.linutronix.de>
References: <fd896eec-7833-f23a-ad2f-95005dca5fff@linux.intel.com> <a108c800-d6c1-fac1-b73b-e390e579e6ef@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Jonatan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 7 Feb 2019, Alexey Budankov wrote:

General note: Please stay in the 80 char limit for all of the text.

> +The perf_events system call API [2]_ allocates file descriptors for every configured
> +PMU event. Open file descriptors are a per-process accountable resource governed
> +by the RLIMIT_NOFILE [11]_ limit (ulimit -n), which is usually derived from the login
> +shell process. When configuring Perf collection for a long list of events on a
> +large server system, this limit can be easily hit preventing required monitoring
> +configuration.

I'd move this sentence into a different paragraph and keep those related to
RLIMIT_NOFILE together.

> ... RLIMIT_NOFILE limit can be increased on per-user basis modifying
> +content of the limits.conf file [12]_ on some systems.

On some systems?

> Ordinarily, a Perf sampling session
> +(perf record) requires an amount of open perf_event file descriptors that is not
> +less than a number of monitored events multiplied by a number of monitored CPUs.

  s/a number of/the number of/

The ordinary use case is:

    perf CMD pile-of-events PROCESS

which does not specify the monitored CPUs at all. Then the number of file
descriptors is NR_EVENTS * NR_ONLINE_CPUS.

> +An amount of memory available to user processes for capturing performance monitoring

The amount ...

> +data is governed by the perf_event_mlock_kb [2]_ setting. This perf_event specific
> +resource setting defines overall per-cpu limits of memory allowed for mapping
> +by the user processes to execute performance monitoring. The setting essentially
> +extends the RLIMIT_MEMLOCK [11]_ limit, but only for memory regions mapped specially

s/specially/specifically/

> +for capturing monitored performance events and related data.
> +
> +For example, if a machine has eight cores and perf_event_mlock_kb limit is set
> +to 516 KiB, then a user process is provided with 516 KiB * 8 = 4128 KiB of memory
> +above the RLIMIT_MEMLOCK limit (ulimit -l) for perf_event mmap buffers. In particular,
> +this means that, if the user wants to start two or more performance monitoring
> +processes, the user is required to manually distribute available 4128 KiB between the

distribute the available

> +monitoring processes, for example, using the --mmap-pages Perf record mode option.
> +Otherwise, the first started performance monitoring process allocates all available
> +4128 KiB and the other processes will fail to proceed due to the lack of memory.
> +
> +RLIMIT_MEMLOCK and perf_event_mlock_kb resource costraints are ignored for

constraints.

> +processes with the CAP_IPC_LOCK capability. Thus, perf_events/Perf privileged users

what means perf_events/Perf ?

> +can be provided with memory above the constraints for perf_events/Perf performance
> +monitoring purpose by providing the Perf executable with CAP_IPC_LOCK capability.

Thanks,

	tglx
