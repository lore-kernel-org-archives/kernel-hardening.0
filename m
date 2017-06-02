From: riel@redhat.com
Date: Fri,  2 Jun 2017 11:20:04 -0400
Message-Id: <20170602152010.2064-1-riel@redhat.com>
Subject: [kernel-hardening] [PATCH 0/6] move mmap_area and PIE binaries away from the stack
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, akpm@linux-foundation.org, mingo@kernel.org, oleg@redhat.com, lwoodman@redhat.com, mhocko@suse.de, danielmicay@gmail.com, will.deacon@arm.com, benh@kernel.crashing.org
List-ID: <kernel-hardening.lists.openwall.com>

There are a few bugs causing the kernel to sometimes map PIE
binaries and the mmap_area where the stack is supposed to go.

This series fixes them for x86, ARM64, and PPC.
S390 seems to be ok.

If people are fine with this approach, I can work my way
through other architectures, too.
