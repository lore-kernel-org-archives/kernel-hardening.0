From: Alexey Budankov <alexey.budankov@linux.intel.com>
Subject: [PATCH v2 0/2] Documentation/admin-guide: introduce perf-security.rst
 file and extend perf_event_paranoid documentation
Message-ID: <259a9cd2-5c56-4f8d-57c4-cabaeaa774bc@linux.intel.com>
Date: Wed, 21 Nov 2018 11:57:12 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Andi Kleen <ak@linux.intel.com>, Jonatan Corbet <corbet@lwn.net>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


To facilitate informed decision making by system administrators [1]
to permit and manage access to Perf Events (perf_events) / Perf tool (Perf) [2],[3] 
performance monitoring for multiple users perf-security.rst document 
suggested by Thomas Gleixner is introduced [4] that:

a) states perf_events/Perf access security concerns for multi user environment
b) refers to base Linux access control and management principles
c) extends documentation of possible perf_event_paranoid knob settings 

The file serves as single knowledge source for perf_events/Perf security and 
access control related matter according to decisions, discussion and  
PoC prototype previously made here [5],[6].

The file can later be extended with information describing:

a) perf_events/Perf usage models and its security implications
b) perf_events/Perf user interface, its changes and related security implications
c) security related implications of monitoring by a specific perf_events PMU [2]

---
Alexey Budankov (2):
  Documentation/admin-guide: introduce perf-security.rst file
  Documentation/admin-guide: update admin-guide index.rst

 Documentation/admin-guide/index.rst         |  1 +
 Documentation/admin-guide/perf-security.rst | 77 +++++++++++++++++++++
 2 files changed, 78 insertions(+)
 create mode 100644 Documentation/admin-guide/perf-security.rst
