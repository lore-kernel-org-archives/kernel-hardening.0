Date: Fri, 9 Mar 2018 12:27:08 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH v2] power: supply: da9150-fg: remove VLA usage
Message-ID: <20180309182708.GA18542@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>, Support Opensource <support.opensource@diasemi.com>, Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

In preparation to enabling -Wvla, remove VLA usage and replace it
with fixed-length arrays.

DA9150_QIF_LONG_SIZE (4 bytes) is the biggest size of an attribute which can
be accessed [1].

Fixed as part of the directive to remove all VLAs from
the kernel: https://lkml.org/lkml/2018/3/7/621

[1] https://marc.info/?l=kernel-hardening&m=152059600524753&w=2

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Use DA9150_QIF_LONG_SIZE instead of DA9150_QIF_BYTE_SIZE as the
   maximum size for array 'buf'. Thanks to Adam Thomson for the
   feedback on this.
 - Update changelog based on Adam's comments.

 drivers/power/supply/da9150-fg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/da9150-fg.c b/drivers/power/supply/da9150-fg.c
index 8b8ce97..7ea2188 100644
--- a/drivers/power/supply/da9150-fg.c
+++ b/drivers/power/supply/da9150-fg.c
@@ -92,7 +92,7 @@ struct da9150_fg {
 static u32 da9150_fg_read_attr(struct da9150_fg *fg, u8 code, u8 size)
 
 {
-	u8 buf[size];
+	u8 buf[DA9150_QIF_LONG_SIZE];
 	u8 read_addr;
 	u32 res = 0;
 	int i;
@@ -111,7 +111,7 @@ static void da9150_fg_write_attr(struct da9150_fg *fg, u8 code, u8 size,
 				 u32 val)
 
 {
-	u8 buf[size];
+	u8 buf[DA9150_QIF_LONG_SIZE];
 	u8 write_addr;
 	int i;
 
-- 
2.7.4
