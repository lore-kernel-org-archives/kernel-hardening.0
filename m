Subject: [PATCH v3 1/4] perf-security: document perf_events/Perf resource
 control
From: Alexey Budankov <alexey.budankov@linux.intel.com>
References: <784bbe0d-56c1-bd63-1879-b7db988e40c0@linux.intel.com>
Message-ID: <28e7f514-e9eb-ae8e-76cf-cd4a6913b99c@linux.intel.com>
Date: Mon, 11 Feb 2019 16:42:58 +0300
MIME-Version: 1.0
In-Reply-To: <784bbe0d-56c1-bd63-1879-b7db988e40c0@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jonatan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


Extend perf-security.rst file with perf_events/Perf resource control
section describing RLIMIT_NOFILE and perf_event_mlock_kb settings for
performance monitoring user processes.

Signed-off-by: Alexey Budankov <alexey.budankov@linux.intel.com>
---
Changes in v3:
- added two more paragraphs on open fds and memory allocation
- applied comments and corrected typos

Changes in v2:
- applied comments on v1

---
 Documentation/admin-guide/perf-security.rst | 42 +++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/Documentation/admin-guide/perf-security.rst b/Documentation/admin-guide/perf-security.rst
index f73ebfe9bfe2..bac599e3c55f 100644
--- a/Documentation/admin-guide/perf-security.rst
+++ b/Documentation/admin-guide/perf-security.rst
@@ -84,6 +84,46 @@ governed by perf_event_paranoid [2]_ setting:
      locking limit is imposed but ignored for unprivileged processes with
      CAP_IPC_LOCK capability.
 
+perf_events/Perf resource control
+---------------------------------
+
+Open file descriptors
++++++++++++++++++++++
+
+The perf_events system call API [2]_ allocates file descriptors for every configured
+PMU event. Open file descriptors are a per-process accountable resource governed
+by the RLIMIT_NOFILE [11]_ limit (ulimit -n), which is usually derived from the login
+shell process. When configuring Perf collection for a long list of events on a
+large server system, this limit can be easily hit preventing required monitoring
+configuration. RLIMIT_NOFILE limit can be increased on per-user basis modifying
+content of the limits.conf file [12]_ . Ordinarily, a Perf sampling session
+(perf record) requires an amount of open perf_event file descriptors that is not
+less than the number of monitored events multiplied by the number of monitored CPUs.
+
+Memory allocation
++++++++++++++++++
+
+The amount of memory available to user processes for capturing performance monitoring
+data is governed by the perf_event_mlock_kb [2]_ setting. This perf_event specific
+resource setting defines overall per-cpu limits of memory allowed for mapping
+by the user processes to execute performance monitoring. The setting essentially
+extends the RLIMIT_MEMLOCK [11]_ limit, but only for memory regions mapped specifically
+for capturing monitored performance events and related data.
+
+For example, if a machine has eight cores and perf_event_mlock_kb limit is set
+to 516 KiB, then a user process is provided with 516 KiB * 8 = 4128 KiB of memory
+above the RLIMIT_MEMLOCK limit (ulimit -l) for perf_event mmap buffers. In particular,
+this means that, if the user wants to start two or more performance monitoring
+processes, the user is required to manually distribute the available 4128 KiB between the
+monitoring processes, for example, using the --mmap-pages Perf record mode option.
+Otherwise, the first started performance monitoring process allocates all available
+4128 KiB and the other processes will fail to proceed due to the lack of memory.
+
+RLIMIT_MEMLOCK and perf_event_mlock_kb resource constraints are ignored for
+processes with the CAP_IPC_LOCK capability. Thus, perf_events/Perf privileged users
+can be provided with memory above the constraints for perf_events/Perf performance
+monitoring purpose by providing the Perf executable with CAP_IPC_LOCK capability.
+
 Bibliography
 ------------
 
@@ -94,4 +134,6 @@ Bibliography
 .. [5] `<https://www.kernel.org/doc/html/latest/security/credentials.html>`_
 .. [6] `<http://man7.org/linux/man-pages/man7/capabilities.7.html>`_
 .. [7] `<http://man7.org/linux/man-pages/man2/ptrace.2.html>`_
+.. [11] `<http://man7.org/linux/man-pages/man2/getrlimit.2.html>`_
+.. [12] `<http://man7.org/linux/man-pages/man5/limits.conf.5.html>`_
 
