From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH] Btrfs: drop a VLA in btrfs_check_super_csum()
Date: Tue, 13 Mar 2018 20:50:22 +0100
Message-Id: <1520970622-19535-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Avoid a VLA[1] by using a real constant expression instead of a variable.
The compiler should be able to optimize the original code and avoid using
an actual VLA. Anyway this change is useful because it will avoid a false
positive with -Wvla, it might also help the compiler generating better
code.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 fs/btrfs/disk-io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 21f34ad..88cef92 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -403,8 +403,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 
 	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
 		u32 crc = ~(u32)0;
-		const int csum_size = sizeof(crc);
-		char result[csum_size];
+		char result[sizeof(crc)];
 
 		/*
 		 * The super_block structure does not span the whole
@@ -415,7 +414,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
 		btrfs_csum_final(crc, result);
 
-		if (memcmp(raw_disk_sb, result, csum_size))
+		if (memcmp(raw_disk_sb, result, sizeof(result)))
 			ret = 1;
 	}
 
-- 
1.9.1
