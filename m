From: Ruslan Nikolaev <nruslan_devel@yahoo.com>
Subject: [PATCH v1 02/06]: Avoid using the same object file in the kernel and
 modules
Message-ID: <3633bff2-d07d-e135-a583-6fada6bf7671@yahoo.com>
Date: Tue, 15 Jan 2019 13:58:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: kernel-hardening@lists.openwall.com
Cc: thgarnie@google.com, x86@kernel.org, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Avoid using the same object file in the kernel and modules

The patch is by Hassan Nadeem and Ruslan Nikolaev. This extends
the prior PIE kernel patch (by Thomas Garnier) to also support
position-independent modules that can be placed anywhere in the
48/64-bit address space (for better KASLR).

Signed-off-by: Ruslan Nikolaev <nruslan_devel@yahoo.com>
---
  Makefile             |    2 +-
  entropy_common_dec.c |    2 ++
  fse_decompress_dec.c |    2 ++
  zstd_common_dec.c    |    2 ++
  4 files changed, 7 insertions(+), 1 deletion(-)

diff -uprN a/lib/zstd/entropy_common_dec.c b/lib/zstd/entropy_common_dec.c
--- a/lib/zstd/entropy_common_dec.c	1969-12-31 19:00:00.000000000 -0500
+++ b/lib/zstd/entropy_common_dec.c	2019-01-15 11:22:25.688186400 -0500
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: BSD-2-Clause OR GPL-2.0
+#include "entropy_common.c"
diff -uprN a/lib/zstd/fse_decompress_dec.c b/lib/zstd/fse_decompress_dec.c
--- a/lib/zstd/fse_decompress_dec.c	1969-12-31 19:00:00.000000000 -0500
+++ b/lib/zstd/fse_decompress_dec.c	2019-01-15 11:22:25.688186400 -0500
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: BSD-2-Clause OR GPL-2.0
+#include "fse_decompress.c"
diff -uprN a/lib/zstd/Makefile b/lib/zstd/Makefile
--- a/lib/zstd/Makefile	2019-01-15 11:20:44.987165514 -0500
+++ b/lib/zstd/Makefile	2019-01-15 11:22:25.688186400 -0500
@@ -6,4 +6,4 @@ ccflags-y += -O3
  zstd_compress-y := fse_compress.o huf_compress.o compress.o \
  		   entropy_common.o fse_decompress.o zstd_common.o
  zstd_decompress-y := huf_decompress.o decompress.o \
-		     entropy_common.o fse_decompress.o zstd_common.o
+		     entropy_common_dec.o fse_decompress_dec.o zstd_common_dec.o
diff -uprN a/lib/zstd/zstd_common_dec.c b/lib/zstd/zstd_common_dec.c
--- a/lib/zstd/zstd_common_dec.c	1969-12-31 19:00:00.000000000 -0500
+++ b/lib/zstd/zstd_common_dec.c	2019-01-15 11:22:25.688186400 -0500
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+#include "zstd_common.c"
