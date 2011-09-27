Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 27 Sep 2011 13:08:09 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
In-Reply-To: <20110927175453.GA3393@albatros>
Message-ID: <alpine.DEB.2.00.1109271304470.11361@router.home>
References: <20110927175453.GA3393@albatros>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH 1/2] mm: restrict access to slab files under procfs and
 sysfs
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org, Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>, Valdis.Kletnieks@vt.edu, Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This also needs to other /proc files I believe,


Acked-by: Christoph Lameter <cl@linux.com>


Possible candidates:

christoph@oldy:~/n/linux-2.6$ grep proc_create mm/*
mm/swapfile.c:	proc_create("swaps", 0, NULL, &proc_swaps_operations);
mm/vmstat.c:	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
mm/vmstat.c:	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
mm/vmstat.c:	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
mm/vmstat.c:	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);

vmstat and zoneinfo in particular give similar information to what is
revealed through the slab proc files.
