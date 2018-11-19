From: Alexey Budankov <alexey.budankov@linux.intel.com>
Subject: [PATCH v1 0/2]: Documentation/admin-guide: introduce
 perf-security.rst file and extend perf_event_paranoid documentation
Message-ID: <0ac97cd0-4773-fff6-7d4e-74c4a1f076c4@linux.intel.com>
Date: Mon, 19 Nov 2018 08:37:41 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Andi Kleen <ak@linux.intel.com>, Jonatan Corbet <corbet@lwn.net>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


To facilitate informed decision making by system administrators [1]
to permit and manage access to PCL/Perf [2],[3] performance monitoring 
for multiple users perf-security.rst document suggested by Thomas Gleixner 
is introduced [4] that:

a) states PCL/Perf access security concerns for multi user environment
b) refers to base Linux access control and management principles
c) extends documentation of possible perf_event_paranoid knob settings 

The file serves as single knowledge source for PCL/Perf security and 
access control related matter according to decisions, discussion and  
PoC prototype previously made here [5],[6].

The file can later be extended with information describing:

a) PCL/Perf usage models and its security implications
b) PCL/Perf user interface, its changes and related security implications
c) security related implications of monitoring by a specific PCL PMU [2]

---
 Alexey Budankov (2):
	Documentation/admin-guide: update admin-guide index.rst
	Documentation/admin-guide: introduce perf-security.rst file

 Documentation/admin-guide/index.rst         |  1 +
 Documentation/admin-guide/perf-security.rst | 83 +++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

---
[1] https://marc.info/?l=linux-kernel&m=153815883923913&w=2
[2] http://man7.org/linux/man-pages/man2/perf_event_open.2.html
[3] https://perf.wiki.kernel.org/index.php/Main_Page
[4] https://marc.info/?l=linux-kernel&m=153837512226838&w=2
[5] https://marc.info/?l=linux-kernel&m=153736008310781&w=2
[6] https://lkml.org/lkml/2018/5/21/156
