Date: Mon, 12 Feb 2018 17:31:57 +0200
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/6] Protectable Memory
References: <20180211031920.3424-1-igor.stoppa@huawei.com>
 <20180211031920.3424-5-igor.stoppa@huawei.com>
 <20180211123743.GC13931@rapoport-lnx>
 <e7ea02b4-3d43-9543-3d14-61c27e155042@huawei.com>
 <20180212114310.GD20737@rapoport-lnx>
 <20180212125347.GE20737@rapoport-lnx>
 <68edadf0-2b23-eaeb-17de-884032f0b906@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68edadf0-2b23-eaeb-17de-884032f0b906@huawei.com>
Message-Id: <20180212153156.GF20737@rapoport-lnx>
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: willy@infradead.org, rdunlap@infradead.org, corbet@lwn.net, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, jglisse@redhat.com, hch@infradead.org, cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 12, 2018 at 03:41:57PM +0200, Igor Stoppa wrote:
> 
> 
> On 12/02/18 14:53, Mike Rapoport wrote:
> > 'scripts/kernel-doc -v -none 
> 
> That has a quite interesting behavior.
> 
> I run it on genalloc.c while I am in the process of adding the brackets
> to the function names in the kernel-doc description.
> 
> The brackets confuse the script and it fails to output the name of the
> function in the log:
> 
> lib/genalloc.c:123: info: Scanning doc for get_bitmap_entry
> lib/genalloc.c:139: info: Scanning doc for
> lib/genalloc.c:152: info: Scanning doc for
> lib/genalloc.c:164: info: Scanning doc for

 
> 
> The first function does not have the brackets.
> The others do. So what should I do with the missing brackets?
> Add them, according to the kernel docs, or leave them out?

Seems that kernel-doc does not consider () as a valid match for the
identifier :)
 
Can you please check with the below patch?

> I'd lean toward adding them.
> 
> --
> igor
 
-- 
Sincerely yours,
Mike.

>From 35255bc2d7d2a63be4f78a7bf4eec83ab0dc4f3f Mon Sep 17 00:00:00 2001
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Date: Mon, 12 Feb 2018 17:19:04 +0200
Subject: [PATCH] scripts: kernel_doc: fixup reporting of function identifiers

When function description includes brackets after the function name as
suggested by Documentation/doc-guide/kernel-doc, the kernel-doc script
omits the function name from "Scanning doc for" report.
Extending match for identifier name with optional brackets fixes this
issue.

Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
---
 scripts/kernel-doc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index fee8952037b1..a6a9a8ef116c 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1873,7 +1873,7 @@ sub process_file($) {
 	    }
 	    elsif (/$doc_decl/o) {
 		$identifier = $1;
-		if (/\s*([\w\s]+?)\s*-/) {
+		if (/\s*([\w\s]+?)(\(\))?\s*-/) {
 		    $identifier = $1;
 		}
 
-- 
2.7.4
