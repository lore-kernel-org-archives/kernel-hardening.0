Subject: [PATCH v1 1/2]: Documentation/admin-guide: update admin-guide
 index.rst
From: Alexey Budankov <alexey.budankov@linux.intel.com>
References: <0ac97cd0-4773-fff6-7d4e-74c4a1f076c4@linux.intel.com>
Message-ID: <810bb4aa-777f-77ed-19f0-882354bdf9c7@linux.intel.com>
Date: Mon, 19 Nov 2018 08:41:31 +0300
MIME-Version: 1.0
In-Reply-To: <0ac97cd0-4773-fff6-7d4e-74c4a1f076c4@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Andi Kleen <ak@linux.intel.com>, Jonatan Corbet <corbet@lwn.net>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


Extend index.rst index file at admin-guide root directory with 
the reference to perf-security.rst file being introduced.

Signed-off-by: Alexey Budankov <alexey.budankov@linux.intel.com>
---
 Documentation/admin-guide/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
index 0873685bab0f..885cc0de9114 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -75,6 +75,7 @@ configure specific aspects of kernel behavior to your liking.
    thunderbolt
    LSM/index
    mm/index
+   perf-security
 
 .. only::  subproject and html
