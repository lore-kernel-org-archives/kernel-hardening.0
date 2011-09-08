Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 8 Sep 2011 16:52:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110908165201.59e82c71.akpm@linux-foundation.org>
In-Reply-To: <20110908060405.GH28162@sun>
References: <20110906165144.GJ18425@mtj.dyndns.org>
	<20110906172952.GA28055@albatros>
	<20110906173341.GM18425@mtj.dyndns.org>
	<20110907112301.GA12157@albatros>
	<20110907215329.GB28162@sun>
	<20110907151323.613e62e7.akpm@linux-foundation.org>
	<20110907224234.GD28162@sun>
	<20110907155332.beda7d3d.akpm@linux-foundation.org>
	<20110908054826.GF28162@sun>
	<20110908055025.GG28162@sun>
	<20110908060405.GH28162@sun>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, containers@lists.osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Nathan Lynch <ntl@pobox.com>, kernel-hardening@lists.openwall.com, Oren Laadan <orenl@cs.columbia.edu>, Daniel Lezcano <dlezcano@fr.ibm.com>, Glauber Costa <glommer@parallels.com>, James Bottomley <jbottomley@parallels.com>, Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>, Pavel Emelyanov <xemul@parallels.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 8 Sep 2011 10:04:05 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> fs, proc: Introduce the /proc/<pid>/map_files/ directory v11

Ho hum, I've pretty much run out of excuses to avoid merging this.

except...

We don't really want to bloat fs/proc/base.o by 4k until all the other
things which support c/r are mergeable and we know that the whole
project is actually useful.  When will we be at this stage?

<looks at the warning>

fs/proc/base.c: In function 'proc_map_files_instantiate':
fs/proc/base.c:2348: warning: assignment from incompatible pointer type

err, that code will crash at runtime and it isn't trivial to fix. 
How could this happen?

>
> ...
>
> +				if (fa)
> +					flex_array_free(fa);
>
> ...
>
> +		if (fa)
> +			flex_array_free(fa);

I think I'll do this:

From: Andrew Morton <akpm@linux-foundation.org>

Lots of callers are avoiding passing NULL into flex_array_free().  Move
the check into flex_array_free() in the usual fashion.

Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c                 |    6 ++----
 lib/flex_array.c               |    2 ++
 security/selinux/ss/policydb.c |    9 +++------
 3 files changed, 7 insertions(+), 10 deletions(-)

diff -puN lib/flex_array.c~lib-flex_arrayc-accept-null-arg-to-flex_array_free lib/flex_array.c
--- a/lib/flex_array.c~lib-flex_arrayc-accept-null-arg-to-flex_array_free
+++ a/lib/flex_array.c
@@ -142,6 +142,8 @@ EXPORT_SYMBOL(flex_array_free_parts);
 
 void flex_array_free(struct flex_array *fa)
 {
+	if (!fa)
+		return;
 	flex_array_free_parts(fa);
 	kfree(fa);
 }
diff -puN fs/proc/base.c~lib-flex_arrayc-accept-null-arg-to-flex_array_free fs/proc/base.c
--- a/fs/proc/base.c~lib-flex_arrayc-accept-null-arg-to-flex_array_free
+++ a/fs/proc/base.c
@@ -2514,8 +2514,7 @@ static int proc_map_files_readdir(struct
 			fa = flex_array_alloc(sizeof(info), nr_files, GFP_KERNEL);
 			if (!fa || flex_array_prealloc(fa, 0, nr_files, GFP_KERNEL)) {
 				ret = -ENOMEM;
-				if (fa)
-					flex_array_free(fa);
+				flex_array_free(fa);
 				up_read(&mm->mmap_sem);
 				mmput(mm);
 				goto out;
@@ -2556,8 +2555,7 @@ static int proc_map_files_readdir(struct
 			p = flex_array_get(fa, i);
 			fput(p->file);
 		}
-		if (fa)
-			flex_array_free(fa);
+		flex_array_free(fa);
 		mmput(mm);
 	}
 	}
diff -puN security/selinux/ss/policydb.c~lib-flex_arrayc-accept-null-arg-to-flex_array_free security/selinux/ss/policydb.c
--- a/security/selinux/ss/policydb.c~lib-flex_arrayc-accept-null-arg-to-flex_array_free
+++ a/security/selinux/ss/policydb.c
@@ -769,16 +769,13 @@ void policydb_destroy(struct policydb *p
 		hashtab_destroy(p->symtab[i].table);
 	}
 
-	for (i = 0; i < SYM_NUM; i++) {
-		if (p->sym_val_to_name[i])
-			flex_array_free(p->sym_val_to_name[i]);
-	}
+	for (i = 0; i < SYM_NUM; i++)
+		flex_array_free(p->sym_val_to_name[i]);
 
 	kfree(p->class_val_to_struct);
 	kfree(p->role_val_to_struct);
 	kfree(p->user_val_to_struct);
-	if (p->type_val_to_struct_array)
-		flex_array_free(p->type_val_to_struct_array);
+	flex_array_free(p->type_val_to_struct_array);
 
 	avtab_destroy(&p->te_avtab);
 
_
