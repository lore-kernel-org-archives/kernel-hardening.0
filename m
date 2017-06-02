From: riel@redhat.com
Date: Fri,  2 Jun 2017 11:20:05 -0400
Message-Id: <20170602152010.2064-2-riel@redhat.com>
In-Reply-To: <20170602152010.2064-1-riel@redhat.com>
References: <20170602152010.2064-1-riel@redhat.com>
Subject: [kernel-hardening] [PATCH 1/6] binfmt_elf: document load_bias a little bit
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, akpm@linux-foundation.org, mingo@kernel.org, oleg@redhat.com, lwoodman@redhat.com, mhocko@suse.de, danielmicay@gmail.com, will.deacon@arm.com, benh@kernel.crashing.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Rik van Riel <riel@redhat.com>

After me and another unnamed developer got confused by the subtraction
of vaddr in this branch of the code, followed by adding vaddr back in
a little bit later, for the third time, maybe it is time to document
this quirky bit of code.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 fs/binfmt_elf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 5075fd5c62c8..8c3f4dbc7603 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -930,10 +930,16 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		if (loc->elf_ex.e_type == ET_EXEC || load_addr_set) {
 			elf_flags |= MAP_FIXED;
 		} else if (loc->elf_ex.e_type == ET_DYN) {
-			/* Try and get dynamic programs out of the way of the
+			/*
+			 * Try and get dynamic programs out of the way of the
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
-			 * follow the loader, and is not movable.  */
+			 * follow the loader, and is not movable.
+			 *
+			 * The load_bias is the difference between the address
+			 * in the elf header and the address where the binary
+			 * is mmapped.
+			 */
 			load_bias = ELF_ET_DYN_BASE - vaddr;
 			if (current->flags & PF_RANDOMIZE)
 				load_bias += arch_mmap_rnd();
-- 
2.9.3
