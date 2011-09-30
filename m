Reply-To: kernel-hardening@lists.openwall.com
From: Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <20110930130353.0da54517.akpm00@gmail.com>
References: <20110927175453.GA3393@albatros>
	 <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros>
	 <20110928144614.38591e97.akpm00@gmail.com> <20110930195329.GA2020@albatros>
	 <20110930130353.0da54517.akpm00@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 13:15:14 -0700
Message-ID: <1317413714.16137.666.camel@nimitz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
To: Andrew Morton <akpm00@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org, Kees Cook <kees@ubuntu.com>, Valdis.Kletnieks@vt.edu, Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

I stuck a printk in there.  It's not exactly called 100x a second, but
there were 5 distinct users just for me to boot and ssh in:

[    3.130408] meminfo read called by: 'udevd' 1
[    3.326649] meminfo read called by: 'dhclient-script' 2
[    4.624943] meminfo read called by: 'klogd' 3
[    8.008019] meminfo read called by: 'dhclient-script' 4
[    8.083091] meminfo read called by: 'ps' 5
[   48.171038] meminfo read called by: 'bash' 6

Granted, those were likely privileged.  But, that's a good list of
processes that I would rather not see break.

-- Dave
