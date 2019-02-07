Date: Wed, 6 Feb 2019 17:01:51 -0700
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v1 3/3] perf-security: document perf_events/Perf
 resource control
Message-ID: <20190206170151.00c92333@lwn.net>
In-Reply-To: <5ac4b7aa-b640-d8a4-1926-cf612fada974@linux.intel.com>
References: <9cfbf7a1-72dd-f9d0-8137-0f120fa74d21@linux.intel.com>
	<5ac4b7aa-b640-d8a4-1926-cf612fada974@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
To: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Jann Horn <jannh@google.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Andi Kleen <ak@linux.intel.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 1 Feb 2019 10:30:58 +0300
Alexey Budankov <alexey.budankov@linux.intel.com> wrote:

> Elaborate on possible perf_event/Perf privileged users groups
> and document steps about creating such groups.
> 
> Signed-off-by: Alexey Budankov <alexey.budankov@linux.intel.com>
> ---
>  Documentation/admin-guide/perf-security.rst | 43 +++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/Documentation/admin-guide/perf-security.rst b/Documentation/admin-guide/perf-security.rst
> index 7da7fa459718..fe90f8952be9 100644
> --- a/Documentation/admin-guide/perf-security.rst
> +++ b/Documentation/admin-guide/perf-security.rst
> @@ -73,6 +73,48 @@ enable capturing of additional data required for later performance analysis of
>  monitored processes or a system. For example, CAP_SYSLOG capability permits
>  reading kernel space memory addresses from /proc/kallsyms file.
>  
> +perf_events/Perf privileged users
> +---------------------------------
> +
> +Mechanisms of capabilities, privileged capability-dumb files [6]_ and file system
> +ACLs [10]_ can be used to create a dedicated group of perf_events/Perf privileged
> +users who are permitted to execute performance monitoring without *scope* limits.
> +The following steps can be taken to create such a group of privileged Perf users.
> +
> +1. Create perf_users group of privileged Perf users, assign perf_users group to
> +   Perf tool executable and limit *access* to the executable for other users in
> +   the system:
> +
> +::
> +
> +   # groupadd perf_users
> +   # ls -alhF
> +   -rwxr-xr-x  2 root root  11M Oct 19 15:12 perf
> +   # chgrp perf_users perf
> +   # ls -alhF
> +   -rwxr-xr-x  2 root perf_users  11M Oct 19 15:12 perf
> +   # chmod o-rwx perf
> +   # ls -alhF
> +   -rwxr-x---  2 root perf_users  11M Oct 19 15:12 perf

Since we're giving basic sysadmin info here, we should probably say
explicitly that this will block access to the perf binary to anybody who
is not in the perf_users group.

> +2. Assign required capabilities to the Perf tool executable file and enable

Assign *the* required

> +   members of perf_users group with performance monitoring privileges [6]_ :
> +
> +::
> +
> +   # setcap "cap_sys_admin,cap_sys_ptrace,cap_syslog=ep" perf
> +   # setcap -v "cap_sys_admin,cap_sys_ptrace,cap_syslog=ep" perf
> +   perf: OK
> +   # getcap perf
> +   perf = cap_sys_ptrace,cap_sys_admin,cap_syslog+ep
> +
> +As a result, members of perf_users group are capable of conducting performance
> +monitoring by using functionality of the configured Perf tool executable that,
> +when executes, passes perf_events subsystem *scope* checks.
> +
> +This specific *access* control management is only available to superuser or root

Why the *emphasis* here?  We prefer to minimize this kind of markup
whenever possible.

Thanks,

jon
