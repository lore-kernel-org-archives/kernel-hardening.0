From: Alexey Budankov <alexey.budankov@linux.intel.com>
Subject: [PATCH v1 0/3] admin-guide: extend perf-security with resource
 control, data categories and privileged users
Message-ID: <9cfbf7a1-72dd-f9d0-8137-0f120fa74d21@linux.intel.com>
Date: Fri, 1 Feb 2019 10:23:24 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jonatan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jannh@google.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Andi Kleen <ak@linux.intel.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


The patch set extends the first version of perf-security.rst documentation
file [1], [2], [3] with the following topics:

1) perf_events/Perf resource limits and control management that describes
   RLIMIT_NOFILE and perf_event_mlock_kb settings for processes conducting
   performance monitoring;

2) categories of system and performance data that can be captured by
   perf_events/Perf with explicit designation of process sensitive data;

3) possible steps to create perf_event/Perf privileged users groups for 
   the current implementations of perf_events syscall API [4] and Perf tool;

---
Alexey Budankov (3):
  perf-security: document perf_events/Perf resource control
  perf-security: document collected perf_events/Perf data categories
  perf-security: document perf_events/Perf resource control

 Documentation/admin-guide/perf-security.rst | 111 +++++++++++++++++++-
 1 file changed, 109 insertions(+), 2 deletions(-)

---
[1] https://marc.info/?l=linux-kernel&m=153736008310781&w=2
[2] https://lkml.org/lkml/2018/5/21/156
[3] https://lkml.org/lkml/2018/11/27/604
[4] http://man7.org/linux/man-pages/man2/perf_event_open.2.html
