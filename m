From: Alexey Budankov <alexey.budankov@linux.intel.com>
Subject: [PATCH v2 0/3] admin-guide: extend perf-security with resource
 control, data categories and privileged users
Message-ID: <fd896eec-7833-f23a-ad2f-95005dca5fff@linux.intel.com>
Date: Thu, 7 Feb 2019 16:23:22 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jonatan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
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
Alexey Budankov (4):
  perf-security: document perf_events/Perf resource control
  perf-security: document collected perf_events/Perf data categories
  perf-security: elaborate on perf_events/Perf privileged users
  perf-security: wrap paragraphs on 72 columns

 Documentation/admin-guide/perf-security.rst | 247 +++++++++++++++-----
 1 file changed, 187 insertions(+), 60 deletions(-)

---
Changes in v2:
- addressed comments for v1
- added fourth patch implementing 72 columns paragraph width

---
[1] https://marc.info/?l=linux-kernel&m=153736008310781&w=2
[2] https://lkml.org/lkml/2018/5/21/156
[3] https://lkml.org/lkml/2018/11/27/604
[4] http://man7.org/linux/man-pages/man2/perf_event_open.2.html
