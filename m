From: Igor Stoppa <igor.stoppa@huawei.com>
Subject: [PATCH 2/8] Add label to genalloc.rst for cross reference
Date: Tue, 13 Mar 2018 23:45:48 +0200
Message-ID: <20180313214554.28521-3-igor.stoppa@huawei.com>
In-Reply-To: <20180313214554.28521-1-igor.stoppa@huawei.com>
References: <20180313214554.28521-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: david@fromorbit.com, willy@infradead.org, rppt@linux.vnet.ibm.com, keescook@chromium.org, mhocko@kernel.org
Cc: labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor Stoppa <igor.stoppa@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

Put a label at the beginning of the genalloc.rst, to allow other
documents to cross-reference it.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
---
 Documentation/core-api/genalloc.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/core-api/genalloc.rst b/Documentation/core-api/genalloc.rst
index 6b38a39fab24..39dba5bb7b05 100644
--- a/Documentation/core-api/genalloc.rst
+++ b/Documentation/core-api/genalloc.rst
@@ -1,3 +1,5 @@
+.. _genalloc:
+
 The genalloc/genpool subsystem
 ==============================
 
-- 
2.14.1
