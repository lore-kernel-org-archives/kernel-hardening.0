From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH 2/3] Add label and license to genalloc.rst
Date: Wed,  2 May 2018 05:05:21 +0400
Message-Id: <20180502010522.28767-3-igor.stoppa@huawei.com>
In-Reply-To: <20180502010522.28767-1-igor.stoppa@huawei.com>
References: <20180502010522.28767-1-igor.stoppa@huawei.com>
To: mhocko@kernel.org, akpm@linux-foundation.org, keescook@chromium.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: willy@infradead.org, labbott@redhat.com, linux-kernel@vger.kernel.org, igor.stoppa@huawei.com
List-ID: <kernel-hardening.lists.openwall.com>

Add SPDX license to genalloc.rst, then a label, to allow cross-referencing.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
---
 Documentation/core-api/genalloc.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/core-api/genalloc.rst b/Documentation/core-api/genalloc.rst
index 6b38a39fab24..0b5ade832ee8 100644
--- a/Documentation/core-api/genalloc.rst
+++ b/Documentation/core-api/genalloc.rst
@@ -1,3 +1,7 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. _genalloc:
+
 The genalloc/genpool subsystem
 ==============================
 
-- 
2.14.1
